package Inprint::Fascicle::Sprite;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use POSIX qw/ceil floor/;

use GD;
use GD::Text::Wrap;
use GD::Tiler qw(tile);

use base 'Mojolicious::Controller';

sub index {

    my $c = shift;

    my @errors;

    my $i_width = $c->param("w");
    my $i_height = $c->param("h");
    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");

    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", $i_fascicle)->Hash;

    my $tempPath = $c->config->get("store.temp");
    my $spriteFolder = "$tempPath/fascicles/". $fascicle->{id} ."-". $fascicle->{variation};
    my $spriteFile  = "$spriteFolder/${i_width}x${i_height}_sprite.png";

    if (! -e $spriteFile) {
        render_sprite($c, $fascicle->{id}, $spriteFolder, $i_width, $i_height);
    }
    
    if (-e $spriteFile) {
        
        $c->tx->res->headers->content_length(-s $spriteFile);
        $c->tx->res->headers->content_type("image/png");
        
        $c->res->content->asset(
            Mojo::Asset::File->new(path => $spriteFile)
        );

        $c->rendered;
    } else {
       $c->res->code(404);
    }

}

sub updatePagePositions {

    my $c = shift;
    my $fascicle = shift;

    $c->Q("UPDATE fascicles_pages SET spritepos=0 WHERE fascicle=?", $fascicle);

    my $pages = $c->Q(" SELECT * FROM fascicles_pages WHERE fascicle =? ORDER BY seqnum ", $fascicle)->Hashes;

    my $count = 0;
    foreach my $page (@$pages){
        $count++;
        $c->Do("UPDATE fascicles_pages SET spritepos=? WHERE id=?", [$count, $page->{id}]);
    }

};

sub render_sprite {

    my $c = shift;

    my @files;
    my @cords;

    my $fascicle = shift;

    my $spriteFolder = shift;

    my $spriteItemWidth = shift;
    my $spriteItemHeight = shift;

    my $spriteFile  = "$spriteFolder/${spriteItemWidth}x${spriteItemHeight}_sprite.png";

    my $spriteItemMargin = 10;

    updatePagePositions($c, $fascicle);
    my $pages = $c->Q(" SELECT * FROM fascicles_pages WHERE fascicle =? ORDER BY spritepos", $fascicle)->Hashes;

    my $spriteWidth  = ($spriteItemWidth * ($#$pages+1)) + ($spriteItemMargin * ($#$pages+1));
    my $spriteHeight = $spriteItemHeight;

    if (! -e $spriteFolder) {
        mkdir $spriteFolder;
    }

    my $linex = 0;
    my $liney = 0;
    foreach my $page (@$pages){

        my $position = $page->{spritepos} || 0;

        my $spriteSrcFile = $spriteFolder ."/${spriteItemWidth}x${spriteItemHeight}-" . $page->{id} . ".png";

        if (! -e $spriteSrcFile) {
            render_image($c, $page, $spriteSrcFile, $spriteItemWidth, $spriteItemHeight);
        }

        if (-e $spriteSrcFile) {
            push @files, $spriteSrcFile;
            push @cords, ($spriteItemWidth * ($linex))  + ($spriteItemMargin * ($linex));
            push @cords, ($spriteItemHeight * ($liney)) + ($spriteItemMargin * ($liney));
        }

        $linex ++;
        
        if ($linex == 10) {
            $linex = 0;
            $liney ++;
        }
    }

    $spriteWidth  = ($spriteItemWidth * 10) + ($spriteItemMargin * 10);
    $spriteHeight = ($spriteItemHeight * ($liney+1)) + ($spriteItemMargin * ($liney+1));
    
    my $image = GD::Tiler->tile(
        Format => "png",
        Images => \@files,
        Background => 'gray',
        Width => $spriteWidth,
        Height => $spriteHeight,
        Coordinates => \@cords
    );

    open(FILE,">$spriteFile") || die "could not write image: $!";
    binmode FILE;
    print FILE ($image);
    close(FILE);
}

sub render_image {

    my $c = shift;

    my $page = shift;
    my $file = shift;
    my $i_w = shift;
    my $i_h = shift;

    my $grid_w = $i_w || 200;
    my $grid_h = $i_h || 300;

    $page->{allowed_places} = $c->Q("
        SELECT place
        FROM fascicles_tmpl_index WHERE nature='headline' AND fascicle=? AND entity=?
    ", [ $page->{fascicle}, $page->{headline} ])->Values;

    $page->{allowed_modules} = $c->Q("
        SELECT place
        FROM fascicles_tmpl_index WHERE nature='module' AND fascicle=? AND place=ANY(?)
    ", [ $page->{fascicle}, $page->{allowed_places} ])->Values;

    # create a new image
    my $img = new GD::Image($grid_w, $grid_h);

    my $white = $img->colorAllocate(255,255,255);
    my $black = $img->colorAllocate(0,0,0);
    my $red   = $img->colorAllocate(255,0,0);
    my $blue  = $img->colorAllocate(0,0,255);

    my $gray  = $img->colorAllocate(214,214,214);
    my $darkgray  = $img->colorAllocate(227,227,227);

    my $grid = {
        color => $gray,
        w => $grid_w,
        h => $grid_h
    };

    $c->draw_page($img, $grid, $page->{w}, $page->{h});

    my $modules = $c->Q("
        SELECT DISTINCT
                t1.id, t1.title, t1.place, t1.w, t1.h, t2.placed, t2.x, t2.y,
                t3.id as place, t3.title as place_title
            FROM
                fascicles_modules t1
                    LEFT JOIN fascicles_tmpl_places t3 ON ( t1.place = t3.id ),
                fascicles_map_modules t2
            WHERE t2.module=t1.id AND t2.page = ?
    ", [ $page->{id} ])->Hashes;

    foreach my $module (@$modules) {

        $module->{requets} = $c->Q("
            SELECT id, shortcut
            FROM fascicles_requests WHERE module=?
        ", [ $module->{id} ])->Hashes;

        $module->{bg_color} = $gray;
        $module->{brd_color} = $black;
        $module->{txt_color} = $black;

        unless ($module->{place}) {
            $module->{brd_color} = $red;
        }

        unless ($module->{place} ~~ $page->{allowed_places}) {
            $module->{brd_color} = $red;
        }

        $c->draw_module($img, $grid, $module);
    }

    open(FILE,">$file") || die "could not write image: $!";
    binmode FILE;
    print FILE ($img->png);
    close(FILE);
}


sub draw_page {

    my $c = shift;

    my $img = shift;

    my $grid = shift;

    my $w = shift;
    my $h = shift;

    $img->rectangle(0,0, $grid->{w}-1, $grid->{h}-1, $grid->{color} );

    foreach my $cord ( @$w ) {
        my ($a,$b) = split '/', $cord;
        my $xcord = $grid->{w} * ($a/$b);
        $img->line( $xcord, 0, $xcord, $grid->{h}, $grid->{color});
    }

    foreach my $cord ( @$h ) {
        my ($a,$b) = split '/', $cord;
        my $ycord = $grid->{h} * ($a/$b);
        $img->line( 0, $ycord, $grid->{w}, $ycord, $grid->{color});
    }

}

sub draw_module {

    my $c = shift;
    my $img = shift;
    my $grid = shift;
    my $module = shift;

    return unless $module->{x};
    return unless $module->{y};
    return unless $module->{placed};

    my ($xl1,$xl2) = split '/', $module->{x};
    my ($yl1,$yl2) = split '/', $module->{y};

    my ($wl1,$wl2) = split '/', $module->{w};
    my ($hl1,$hl2) = split '/', $module->{h};

    my $x1 = ($xl1/$xl2) * $grid->{w};
    my $y1 = ($yl1/$yl2) * $grid->{h};

    my $w1 = ($wl1/$wl2) * $grid->{w};
    my $h1 = ($hl1/$hl2) * $grid->{h};

    my $x2 = $x1+$w1;
    my $y2 = $y1+$h1;

    if ($x2 == $grid->{w}) {
        $x2--;
    }

    if ($y2 == $grid->{h}) {
        $y2--;
    }

    $img->filledRectangle($x1, $y1, $x2, $y2, $module->{bg_color});
    $img->rectangle($x1, $y1, $x2, $y2,$module->{brd_color});

    my $font;
    my $fontsize;
    my $fontheight;

    if ($^O eq "MSWin32") {
        $font = 'C:\Windows\Fonts\lucon.ttf';
        $fontsize = 7;
        $fontheight = 5;
    }

    if ($^O eq "darwin") {
        $font = '/System/Library/Fonts/Menlo.ttc';
        $fontsize = 8;
    }

    if ($^O eq "linux") {
        $font = '/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf';
        $fontsize = 8;
    }

    my $text = $module->{title};

    my $blockWidth = $x2-$x1;
    my $blockHeight = $fontsize;

    if (${ $module->{requets} }[0]) {
        my $request = ${ $module->{requets} }[0];
        if ($request->{shortcut}) {
            $text .= "\n" . $request->{shortcut};
            my $lc = ceil( $blockWidth / (length($text) * $fontsize) );
            $blockHeight = $fontsize * $lc;
        }
    }

    my $txty = $y1 + ceil (($y2-$y1)/2) ;
    $txty -= $blockHeight/2;
    
    my $wrapbox = GD::Text::Wrap->new( $img,
        line_space  => 0,
        color       => $module->{txt_color},
        text        => "$text"
    );

    $wrapbox->set_font($font, $fontsize);

    $wrapbox->set(align => 'center', width => $blockWidth);

    $wrapbox->draw( $x1, $txty);
}

1;
