package Inprint::Fascicle::Print;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Encode qw(decode encode);
use PDF::API2;
use PDF::TextBlock;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

use constant A3 => {
    name    => "A3",
    top     => 800,
    width   => 100,
    height  => 140,
};

use constant A4 => {

    name    => "A4",

    top     => 460,
    htop    => 570,
    ftop    => 20,

    pcx     => 10,
    pcy     => 20,

    xcount  => 10,
    ycount  => 5,

    padding => 5,
    width   => 75,
    height  => 100,
};

use base 'Mojolicious::Controller';

sub print {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_size     = $c->param("size");
    my $i_mode     = $c->param("mode");

    my @data, my @errors;

    my $Cpage = A4;

    if ($i_size eq "a3") {
        $Cpage = A3;
    }

    my ($x1, $y1, $PageWidth, $PageHeight) = PDF::API2::Util::page_size($Cpage->{name});

    if ($i_mode eq "landscape") {
        my $tempW = $PageWidth;
        $PageWidth = $PageHeight;
        $PageHeight = $tempW;
        $tempW = undef;
    }

    ##################################################

    my $pdf = PDF::API2->new();

    my $pages = $c->sql->Q("
        SELECT id, seqnum as pagenum, seqnum as pagename, w as linex, h as liney
        FROM fascicles_pages
        WHERE fascicle = ?
        ORDER BY pagenum
    ", $i_fascicle)->Hashes;

    foreach my $page (@$pages) {

        $page->{modules} = $c->sql->Q("
            SELECT t1.id, t1.title, t1.w, t1.h, t2.x, t2.y, rq.shortcut as request_title
            FROM
                fascicles_modules t1
                    LEFT JOIN fascicles_requests rq ON rq.module = t1.id,
                fascicles_map_modules t2
            WHERE 1=1
                AND t1.id = t2.module
                AND t1.fascicle = ?
                AND t2.page = ?
                AND t2.placed = true

        ", [ $i_fascicle, $page->{id} ])->Hashes;

    }

    my $page;

    my $itmcount  = 0;
    my $blkcount  = 0;
    my $rowcount  = 0;

    my $iteration = 0;
    my $pagecount = 0;

    my $lastpage  = undef;

    for my $record (@$pages) {

        $iteration++;

        # make new row in flow
        if ($itmcount == $Cpage->{xcount}) {
            $rowcount++;
            $blkcount = 0;
            $itmcount = 0;
        }

        # make new page in flow
        if (!$page || $rowcount == $Cpage->{ycount}) {

            $pagecount++;

            $page = $pdf->page->mediabox($PageWidth, $PageHeight);

            my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );

            draw_header($page, $font, $Cpage, "ГЗР /2011-11");

            $itmcount = 0;
            $rowcount = 0;
        }

        # process flow

        $itmcount++;

        my $pagenum = $record->{pagenum};
        my $pagemod = $record->{pagenum} %2;

        # frstpage
        if ($pagenum %2 == 1 && !$lastpage) {
            $itmcount++;
        }

        # block padding
        if ($pagenum %2 == 0
            || $pagenum %2 == 1 && $lastpage %2 == 1 && $itmcount > 1 ) {
            $blkcount++
        }

        # empty pages
        if ($pagenum %2 == 1 && $pagenum - $lastpage != 1
            || $pagenum %2 == 0 && $pagenum - $lastpage != 1 ) {

            my $x = ($itmcount * $Cpage->{width}) - $Cpage->{width};
            $x = $x + ( $Cpage->{padding} *2* $blkcount ) + $Cpage->{padding};

            my $y = 0 - ($rowcount * $Cpage->{height});
            $y = $y - ( ($Cpage->{padding}+20) * $rowcount );

            draw_empty_page($page, $x, $y, $Cpage);

            $itmcount++;
        }

        # draw page
        my $x = ($itmcount * $Cpage->{width}) - $Cpage->{width};
        $x = $x + ( $Cpage->{padding} *2* $blkcount ) + $Cpage->{padding};

        my $y = 0 - ($rowcount * $Cpage->{height});
        $y = $y - ( ($Cpage->{padding}+20) * $rowcount );

        draw_page($pdf, $page, $x, $y, $Cpage, $record );# if ($record->{id} eq 'af33536a-de79-4410-a5d8-479ce6a58641');

        $lastpage = $pagenum;
    }

    my $tempPath = $c->config->get("store.temp");

    my $pdf_filename = "$tempPath/table.pdf";

    $pdf->saveas( $pdf_filename );
    $pdf->end;

    $c->tx->res->headers->content_length(-s $pdf_filename);
    $c->tx->res->headers->content_type("application/pdf;name=test.pdf");
    $c->tx->res->headers->content_disposition("attachment;name=test.pdf");

    $c->res->content->asset(
        Mojo::Asset::File->new(path => $pdf_filename )
    );

    $c->rendered;
}

sub draw_page {

    my $pdf       = shift;

    my $page      = shift;
    my $x         = shift;
    my $y         = shift;
    my $PF        = shift;
    my $record    = shift;

    my $lines_x   = $record->{linex};
    my $lines_y   = $record->{liney};
    my $documents = $record->{documents};
    my $pagenum   = $record->{pagenum};
    my $modules   = $record->{modules};

    my $top    = $PF->{top};
    my $width  = $PF->{width};
    my $height = $PF->{height};

    $y = $y +$top;

    #Draw text
    my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );
    my $text = $page->text();
    $text->font($font, 8);
    $text->fillcolor("black");
    $text->translate($x + $width/2, $y-10 );
    $text->text_center($pagenum);

    # Draw lines
    my $blue_box = $page->gfx;
    $blue_box->strokecolor('black');
    $blue_box->linewidth( 1 );
    $blue_box->rect( $x, $y, $width, $height );
    $blue_box->stroke;

    $blue_box->linewidth( .1 );

    foreach my $cord ( @$lines_x ) {

        my ($a,$b) = split '/', $cord;

        my $xcord = $x + ($width * ($a/$b));

        my $line = $page->gfx;
        $line->move( $xcord, $y );
        $line->line( $xcord, $y+$height );
        $line->stroke;
    }

    foreach my $cord ( @$lines_y ) {

        my ($a,$b) = split '/', $cord;

        my $ycord = $height - ($height * ($a/$b)) + $y;

        my $line = $page->gfx;
        $line->strokecolor("black");
        $line->move( $x, $ycord );
        $line->line( $x+$width, $ycord );
        $line->stroke;

    }

    my $c = 0;

    # Draw modules
    foreach my $item (@$modules) {

        $c++;

        #next if $c == 1;

        my $mx = $item->{x};
        my $my = $item->{y};

        my $mw = $item->{w};
        my $mh = $item->{h};

        my $modx = get_cord($mx);
        my $mody = get_cord($my);
        my $modw = get_cord($mw);
        my $modh = get_cord($mh);

        my $modxcord = $x;
        my $modycord = $y + ($height - ( ($height * $modh) + ($height * $mody) ) );

        #die "$mx, $my, $mw, $mh > $modx, $mody, $modw, $modh ";

        my $modbox = $page->gfx;

        $modbox->fillcolor('orange');
        $modbox->linewidth( .1 );

        $modbox->rect( $modxcord, $modycord, $width * $modw, $height * $modh );

        $modbox->fillstroke;

        my $fs = 6/pt;

        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                     pdf => $pdf,
                     fillcolor => 'black',
                     size => $fs,
                })
            }
        });

        #$tb->x($modxcord + ($width * ($modw/2) ));
        #$tb->y($modycord);

        $tb->x($modxcord);
        $tb->y($modycord + (($height * $modh)/2) - ($fs/2));

        $tb->w($width * $modw);
        $tb->h($height * $modh);

        $tb->align("center");

        $tb->lead(6/pt);

        $tb->page($page);

        $tb->text( "$item->{title} $item->{request_title}" );
        $tb->apply;

    }

    #die $c;

    ## Draw documents
    #my $doccount = 0;
    #foreach my $item (@$documents) {
    #
    #    $doccount++;
    #
    #    my $padding = 4;
    #
    #    my $textbox = $page->gfx;
    #    $textbox->fillcolor("#f5f5f5");
    #    $textbox->rect( $x+$padding, $y + $height - $doccount*10, $width-$padding-$padding, 8 );
    #    $textbox->fill;
    #
    #    my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );
    #    my $text = $page->text();
    #    $text->font($font, 6);
    #    $text->fillcolor("black");
    #    $text->translate($x+5, $y + $height - $doccount*8 );
    #    $text->text(encode( "cp1251", $item ));
    #
    #}
}

sub draw_empty_page {
    my $page = shift;
    my $x    = shift;
    my $y    = shift;
    my $PF   = shift;

    my $top    = $PF->{top};
    my $width  = $PF->{width};
    my $height = $PF->{height};

    $y = $y +$top;

    # Draw lines
    my $empty_box = $page->gfx;
    $empty_box->strokecolor("#F5F5F5");
    $empty_box->linewidth( 1 );
    $empty_box->rect( $x, $y, $width, $height );
    $empty_box->stroke;
}

sub draw_header {

    my $page = shift;
    my $font = shift;
    my $PF   = shift;

    my $string = shift;

    my $text = $page->text();
    $text->font($font, 12);
    $text->translate(10, $PF->{htop} + 8);
    $string = encode( "cp1251", $string );
    $text->text($string);

    my $line = $page->gfx;
    $line->move( 0, $PF->{htop});
    $line->line( 1000, $PF->{htop});
    $line->stroke;
}

sub get_cord {
    my $string = shift;
    my ($a,$b) = split '/', $string;
    return ($a/$b);
}

1;
