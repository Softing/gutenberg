#!/bin/sh

# 3:2
if [ -f wallpaper-3x2.jpg ] 
then
    mogrify -resize 1152x768  wallpaper-3x2.jpg 1152x768.jpg
    mogrify -resize 1280x854  wallpaper-3x2.jpg 1280x854.jpg
    mogrify -resize 1440x960  wallpaper-3x2.jpg 1440x960.jpg
fi

#4:3
if [ -f wallpaper-4x3.jpg ] 
then
    mogrify -resize 1024x768  wallpaper-4x3.jpg 1024x768.jpg
    mogrify -resize 1152x864  wallpaper-4x3.jpg 1152x864.jpg
    mogrify -resize 1280x960  wallpaper-4x3.jpg 1280x960.jpg
    mogrify -resize 1400x1050 wallpaper-4x3.jpg 1400x1050.jpg
    mogrify -resize 1600x1200 wallpaper-4x3.jpg 1600x1200.jpg
fi

#5:3 - 1280x768
if [ -f wallpaper-5x3.jpg ] 
then
    mogrify -resize 1280x768 wallpaper-5x3.jpg 1280x768.jpg
fi

#5:4 - 1280x1024
if [ -f wallpaper-5x4.jpg ] 
then
    mogrify -resize 1280x1024 wallpaper-5x4.jpg 1280x1024.jpg
fi

#16:9
if [ -f wallpaper-16x9.jpg ] 
then
    mogrify -resize 1280x720  wallpaper-16x9.jpg 1280x720.jpg
    mogrify -resize 1365x768  wallpaper-16x9.jpg 1365x768.jpg
    mogrify -resize 1600x900  wallpaper-16x9.jpg 1600x900.jpg
    mogrify -resize 1920x1080 wallpaper-16x9.jpg 1920x1080.jpg
fi

#16:10
if [ -f wallpaper-16x10.jpg ] 
then
    mogrify -resize 1280x800  wallpaper-16x10.jpg 1280x800.jpg
    mogrify -resize 1440x900  wallpaper-16x10.jpg 1440x900.jpg
    mogrify -resize 1680x1050 wallpaper-16x10.jpg 1680x1050.jpg
    mogrify -resize 1920x1200 wallpaper-16x10.jpg 1920x1200.jpg
fi
