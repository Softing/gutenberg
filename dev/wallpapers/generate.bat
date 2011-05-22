
IF EXIST wallpaper-4x3.jpg (
    mogrify -resize 1024x768  -write 1024x768.jpg  wallpaper-4x3.jpg
    mogrify -resize 1152x864  -write 1152x864.jpg  wallpaper-4x3.jpg
    mogrify -resize 1280x960  -write 1280x960.jpg  wallpaper-4x3.jpg
    mogrify -resize 1400x1050 -write 1400x1050.jpg wallpaper-4x3.jpg
    mogrify -resize 1600x1200 -write 1600x1200.jpg wallpaper-4x3.jpg
)

IF EXIST wallpaper-5x4.jpg (
    mogrify -resize 1280x1024 wallpaper-5x4.jpg 1280x1024.jpg
)

IF EXIST wallpaper-16x9.jpg (
    mogrify -resize 1280x720  -write 1280x720.jpg  wallpaper-16x9.jpg
    mogrify -resize 1365x768  -write 1365x768.jpg  wallpaper-16x9.jpg
    mogrify -resize 1600x900  -write 1600x900.jpg  wallpaper-16x9.jpg
    mogrify -resize 1920x1080 -write 1920x1080.jpg wallpaper-16x9.jpg
)

IF EXIST wallpaper-16x10.jpg (
    mogrify -resize 1280x800  -write 1280x800.jpg  wallpaper-16x10.jpg
    mogrify -resize 1440x900  -write 1440x900.jpg  wallpaper-16x10.jpg
    mogrify -resize 1680x1050 -write 1680x1050.jpg wallpaper-16x10.jpg
    mogrify -resize 1920x1200 -write 1920x1200.jpg wallpaper-16x10.jpg
)
