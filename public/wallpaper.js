var mycolor = "#007aab";
var mywallpaper = 'wallpaper';
var myresolution = screen.width+'x'+screen.height;

if (myresolution <= '1024x768') {
    mywallpaper = '1024x768';
}
else if (myresolution <= '1280x1024') {
    mywallpaper = '1280x1024';
}
else if (myresolution <= '1400x1050') {
    mywallpaper = '1400x1050';
}
else if (myresolution <= '1600x1200') {
    mywallpaper = '1600x1200';
}
else if (myresolution <= '1440x900') {
    mywallpaper = '1440x900';
}
else if (myresolution <= '1600x1024') {
    mywallpaper = '1600x1024';
}
else if (myresolution <= '1680x1050') {
    mywallpaper = '1680x1050';
}
else {
    mywallpaper = '1920x1200';
}

document.body.style.background = mycolor +" url(/images/wallpapers/"+ mywallpaper +".png) no-repeat";
