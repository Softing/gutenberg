var mycolor = "#007aab";
var mywallpaper = 'wallpaper.jpg';
var myresolution = screen.width+'x'+screen.height;

if (myresolution <= '1024x768') {
    mywallpaper = 'wallpaper-1024x768.jpg';
}
else if (myresolution <= '1280x1024') {
    mywallpaper = 'wallpaper-1280x1024.jpg';
}
else if (myresolution <= '1400x1050') {
    mywallpaper = 'wallpaper-1400x1050.jpg';
}
else if (myresolution <= '1600x1200') {
    mywallpaper = 'wallpaper-1600x1200.jpg';
}
else if (myresolution <= '1440x900') {
    mywallpaper = 'wallpaper-1440x900.jpg';
}
else if (myresolution <= '1600x1024') {
    mywallpaper = 'wallpaper-1600x1024.jpg';
}
else if (myresolution <= '1680x1050') {
    mywallpaper = 'wallpaper-1680x1050.jpg';
}
else {
    mywallpaper = 'wallpaper-1920x1200.jpg';
}

document.body.style.background = mycolor +" url(/images/wallpapers/"+ mywallpaper +") no-repeat";