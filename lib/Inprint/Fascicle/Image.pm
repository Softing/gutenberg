package Inprint::Fascicle::Image;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use POSIX qw/ceil floor/;
use GD::Simple;

use base 'Inprint::BaseController';

sub view {
    my $c = shift;
    
    my $body;
    
    my $grid_w  = 90;
    my $grid_h = 100;
    
    # create a new image
    my $img = GD::Simple->new($grid_w*2+(10*2), $grid_h+10);
    
    
    $img = $c->draw_page($img, "${grid_w}x${grid_h}", "4x7", 0, [  [1,4,4,4, "red", "black"], [3,2,1,1, "orange", "black" ] ]);
    
    $c->tx->res->headers->content_type('image/png');
    $c->render_data($img->png);

}

sub draw_page {
    
    my $c = shift;
    
    my $img          = shift;
    my $grid_wh      = shift;
    my $grid_xy      = shift;
    my $displacement = shift;
    my $modules      = shift;
    
    my ($grid_w, $grid_h) = split "x", $grid_wh;
    my ($grid_x, $grid_y) = split "x", $grid_xy;
    
    
    my $pen_size = 1;
    my $line_height = ceil($pen_size/2);
    
    $img->penSize($pen_size);
    
    $img->moveTo($grid_w+$displacement-1,0);
    $img->lineTo($grid_w+$displacement-1,$grid_h-$line_height);
    
    $img->moveTo(0+$displacement,$grid_h-$line_height);
    $img->lineTo($grid_w+$displacement-$line_height,$grid_h-$line_height);
    
    for (my $c=0;$c<$grid_y;$c++) {
        my $px = $c * ($grid_h/$grid_y);
        $img->moveTo(0+$displacement,$px);
        $img->lineTo($grid_w+$displacement-$line_height, $px);
    }
    
    for (my $c=0;$c<$grid_x;$c++) {
        my $px = $c * ($grid_w/$grid_x);
        $img->moveTo($px+$displacement,0);
        $img->lineTo($px+$displacement,$grid_h-$line_height);
    }
    
    my $block_pen_size = 2;
    my $block_line_height = ceil($block_pen_size / 2);
    
    my $block_w = ($grid_w/$grid_x);
    my $block_h = ($grid_h/$grid_y);
    
    foreach my $block (@$modules) {
        
        $img->penSize($block_pen_size);
        
        my $x = $$block[0];
        my $y = $$block[1];
        
        my $w = $$block[2];
        my $h = $$block[3];
        
        my $bl_posx1 = ( $x-1 ) * $block_w;
        my $bl_posy1 = ( $y-1 ) * $block_h;
        
        my $bl_posx2 = ( $w * $block_w ) + $bl_posx1;
        my $bl_posy2 = ( $h * $block_h ) + $bl_posy1;
        
        my $bgcolor = $$block[4];
        my $fgcolor = $$block[5];
        
        $img->bgcolor($bgcolor);
        $img->fgcolor($fgcolor);
        
        $img->rectangle($bl_posx1 + $displacement +2, $bl_posy1 + 2, $bl_posx2 + $displacement - 2, $bl_posy2 - 2);
        
    }
    
    return $img;
}

1;
