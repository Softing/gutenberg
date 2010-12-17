package Inprint::Fascicle::Images;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use POSIX qw/ceil floor/;
use GD;
use GD::Text::Align;

use base 'Inprint::BaseController';

sub view {
    my $c = shift;
    
    my $body;
    
    my $i_page = $c->param("page");
    
    my $i_w = $c->param("w");
    my $i_h = $c->param("h");
    
    my $grid_w = $i_w || 110;
    my $grid_h = $i_h || 140;
    
    my $page = $c->sql->Q("
        SELECT id, edition, fascicle, origin, headline, seqnum, w, h, created, updated
        FROM fascicles_pages WHERE id=?
    ", [ $i_page ])->Hash;
    
    # create a new image
    my $img = new GD::Image($grid_w, $grid_h);
    
    my $white = $img->colorAllocate(255,255,255);
    my $black = $img->colorAllocate(0,0,0);
    my $red   = $img->colorAllocate(255,0,0);
    my $blue  = $img->colorAllocate(0,0,255);
    
    my $gray  = $img->colorAllocate(214,214,214);
    my $darkgray  = $img->colorAllocate(227,227,227);
    
    $img->rectangle(0,0, $grid_w-1, $grid_h-1, $gray);
    
    foreach my $cord ( @{ $page->{w} } ) {
        my ($a,$b) = split '/', $cord;
        my $xcord = $grid_w * ($a/$b);
        $img->line( $xcord, 0, $xcord, $grid_h, $gray);
    }
    
    foreach my $cord ( @{ $page->{h} } ) {
        my ($a,$b) = split '/', $cord;
        my $ycord = $grid_h * ($a/$b);
        $img->line( 0, $ycord, $grid_w, $ycord, $gray);
    }
    
    #$img = $c->draw_page($img, $grid_w ."x". $grid_h, $page->{w} ."x". $page->{h}, 0, \@modules);
    
    my $modules = $c->sql->Q("
        SELECT
            t1.id, t1.shortcut, t1.w, t1.h, t2.x, t2.y
        FROM fascicles_modules t1, fascicles_map_modules t2
        WHERE 
            t2.page = ? AND t2.module = t1.id
    ", [ $i_page ])->Hashes;
    
    
    foreach my $module (@$modules) {
        
        my ($xl1,$xl2) = split '/', $module->{x};
        my ($yl1,$yl2) = split '/', $module->{y};
        
        my ($wl1,$wl2) = split '/', $module->{w};
        my ($hl1,$hl2) = split '/', $module->{h};
        
        my $x1 = ($xl1/$xl2) * $grid_w;
        my $y1 = ($yl1/$yl2) * $grid_h;
        
        my $w1 = ($wl1/$wl2) * $grid_w;
        my $h1 = ($hl1/$hl2) * $grid_h;
        
        my $x2 = $x1+$w1;
        my $y2 = $y1+$h1;
        
        if ($x2 == $grid_w) {
            $x2--;
        }
        
        if ($y2 == $grid_h) {
            $y2--;
        }
        
        #$img->filledRectangle($x1, $y1, $x2, $y2,$darkgray);
        #$img->rectangle($x1, $y1, $x2, $y2,$black);
        
        
        my $wrapbox = GD::Text::Wrap->new( $img,
            line_space  => 0,
            color       => $black,
            text        => $module->{shortcut},
        );
        $wrapbox->set_font(gdMediumBoldFont);
        $wrapbox->set_font('arial', 10);
        $wrapbox->set(align => 'center', width => 100);
        $wrapbox->draw(10,40);
        
    }
    
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
    
    $img->bgcolor("silver");
    $img->fgcolor("silver");
    
    my $pen_size = 1;
    my $line_height = ceil($pen_size/2);
    
    $img->penSize($pen_size);
    
    #$img->moveTo(0+$displacement,0);
    #$img->lineTo($displacement,$grid_h-$line_height);
    #$img->moveTo($grid_w+$displacement-1,0);
    #$img->lineTo($grid_w+$displacement-1,$grid_h-$line_height);
    #
    #$img->moveTo(0+$displacement, 0);
    #$img->lineTo($grid_w+$displacement-$line_height,0);
    #$img->moveTo(0+$displacement,$grid_h-$line_height);
    #$img->lineTo($grid_w+$displacement-$line_height,$grid_h-$line_height);
    
    if ($grid_y < 10) {
        for (my $c=0;$c<$grid_y;$c++) {
            my $px = $c * ($grid_h/$grid_y);
            $img->moveTo(0+$displacement,$px);
            $img->lineTo($grid_w+$displacement-$line_height, $px);
        }
    }
    
    if ($grid_x < 10 ) {
        for (my $c=0;$c<$grid_x;$c++) {
            my $px = $c * ($grid_w/$grid_x);
            $img->moveTo($px+$displacement,0);
            $img->lineTo($px+$displacement,$grid_h-$line_height);
        }
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
