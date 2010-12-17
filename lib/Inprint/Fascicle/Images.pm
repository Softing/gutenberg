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
use GD::Text::Wrap;

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
        
        $img->filledRectangle($x1, $y1, $x2, $y2,$darkgray);
        $img->rectangle($x1, $y1, $x2, $y2,$black);
        
        my $font;
        my $fontsize;
        my $fontheight;
        if ($^O eq "MSWin32") {
            $font = 'C:\Windows\Fonts\ARIALUNI.TTF';
            $fontsize = 8;
            $fontheight = 5;
        }
        
        if ($^O eq "linux") {
            $font = '/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf';
            $fontsize = 8;
        }
        
        my $wrapbox = GD::Text::Wrap->new( $img,
            line_space  => 0,
            color       => $black,
            text        => $module->{shortcut}
        );
        
        $wrapbox->set_font(gdMediumBoldFont);
        $wrapbox->set_font($font, $fontsize);
        $wrapbox->set(align => 'center', width => $x2-$x1);
        
        my $txty = ($y2-$y1)/2;
        $txty = $y1+$txty - $fontheight;
        
        $wrapbox->draw( $x1, $txty);
        
    }
    
    $c->tx->res->headers->content_type('image/png');
    $c->render_data($img->png);

}

1;
