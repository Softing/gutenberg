#!/bin/bash

clean() {
    echo -e "\nDeleting existing minified files..."
    find ../public/cache/js/ -name \*.min.js -exec rm {} \;
    find ../public/cache/css/ -name \*.min.css -exec rm {} \;
    find ../public/cache/plugins/ -name \*.min.js -exec rm {} \;
    find ../public/cache/plugins/ -name \*.min.css -exec rm {} \;

}

minify_js() {
    echo -e "\nMinifying JavaScript..."
    jslist=`find ../public/widgets/ -type f -name \*.js`
    
    for jsfile in $jslist
    do
        DEST=$jsfile
        DEST=${DEST/../}
        DEST=${DEST//\//\~}
        echo "Processing: ${jsfile} to $DEST"
        
        java -jar ${YUICOMPRESSOR} -o ../public/cache/js/${DEST%.*}.min.js ${jsfile}
        cat ../public/cache/js/${DEST%.*}.min.js >> ../public/cache/widgets.min.js

    done

    jslist=`find ../public/plugins/ -type f -name \*.js`
    
    for jsfile in $jslist
    do
        DEST=$jsfile
        DEST=${DEST/../}
        DEST=${DEST//\//\~}
        echo "Processing: ${jsfile} to $DEST"
        
        java -jar ${YUICOMPRESSOR} -o ../public/cache/plugins/${DEST%.*}.min.js ${jsfile}
        cat ../public/cache/plugins/${DEST%.*}.min.js >> ../public/cache/plugins.min.js
    done

}

minify_css() {
    echo -e "\nMinifying CSS..."
    csslist=`find ../public/css/ -type f -name \*.css`
    
    for cssfile in $csslist
    do
        DEST=$cssfile
        DEST=${DEST/../}
        DEST=${DEST//\//\~}
        echo "Processing: ${cssfile} to $DEST"
        java -jar ${YUICOMPRESSOR} -o ../public/cache/css/${DEST%.*}.min.css ${cssfile}
        cat ../public/cache/css/${DEST%.*}.min.css >> ../public/cache/inprint.min.css
    done

    csslist=`find ../public/plugins/ -type f -name \*.css`
    
    for cssfile in $csslist
    do
        DEST=$cssfile
        DEST=${DEST/../}
        DEST=${DEST//\//\~}
        echo "Processing: ${cssfile} to $DEST"
        java -jar ${YUICOMPRESSOR} -o ../public/cache/plugins/${DEST%.*}.min.css ${cssfile}
        cat ../public/cache/plugins/${DEST%.*}.min.css >> ../public/cache/plugins.min.css
    done
}

usage() {
    echo -e "\nminify.sh [-cjdh]"
    echo "  c : minify CSS files"
    echo "  j : minify Javascript files"
    echo "  d : delete existing minified CSS and Javascript files"
    echo "  h: print this help"
}

CSS=false
JS=false
DELETE=false
HELP=false

while getopts "cjdh" input
do
    case $input in
        c ) CSS=true;;
        j ) JS=true;;
        d ) DELETE=true;;
        h ) HELP=true;;
    esac
done

if ! $JS && ! $CSS && ! $DELETE
then
    usage
    exit 0
fi

if $HELP
then
    usage
    exit 0
fi

if ! [ `find . -type f -name yuicompressor\*.jar` ]
then
    echo "Unable to locate the YUI Compressor jar file!"
    exit 1
else 
    YUICOMPRESSOR=`find . -type f -name yuicompressor\*.jar`
fi

if $DELETE
then
    clean
fi

if $JS
then
    minify_js
fi

if $CSS
then
    minify_css
fi

echo -e "\nDone."
exit 0
