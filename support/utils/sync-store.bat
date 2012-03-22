SETLOCAL

SET HOME=/cygdrive/c/users/ilya skorik

rsync -e ssh --progress -lzuthvr --compress-level=9  ilyas@inprint.gazeta.zr.ru:/var/spool/inprint/  /cygdrive/c/Web/Store

