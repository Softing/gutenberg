package Inprint::Fascicle::Print;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Data::Dumper;
use Encode qw(decode encode);
use PDF::API2;
use PDF::TextBlock;

use Inprint::Database;

use base 'Mojolicious::Controller';

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

use constant A3 => {
    name        => "A3",

    width       => 75,
    height      => 90,

    htop        => 815,
    top         => 700,
    ftop        => 200,

    pcx         => 10,
    pcy         => 20,

    xcount      => 12,
    ycount      => 6,

    fontsize    => 6,

    padding     => 20,
    spadding    => 3,

};

use constant A4 => {

    name        => "A4",

    width       => 75,
    height      => 100,

    top         => 460,
    htop        => 570,
    ftop        => 20,

    pcx         => 10,
    pcy         => 20,

    xcount      => 10,
    ycount      => 4,

    fontsize    => 6,

    padding     => 10,
    spadding    => 3,
};

sub print {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_size     = $c->param("size");
    my $i_mode     = $c->param("mode");

    my @data, my @errors;

    my $Cpage;
    if ($i_size eq "a3") { $Cpage = A3 };
    if ($i_size eq "a4") { $Cpage = A4 };

    my ($x1, $y1, $PageWidth, $PageHeight) = PDF::API2::Util::page_size($Cpage->{name});

    if ($i_mode eq "landscape") {
        my $tempW = $PageWidth;
        $PageWidth = $PageHeight;
        $PageHeight = $tempW;
        $tempW = undef;
    }

    ##################################################

    my $pdf = PDF::API2->new();

    my $fascicle = Inprint::Database::FascicleService($c)->load( id => $i_fascicle );
    my $edition  = Inprint::Database::EditionService($c)->load( id => $fascicle->{edition} );

    my $page;

    my $itmcount  = 0;
    my $blkcount  = 0;
    my $sblkcount = 0;
    my $rowcount  = 0;

    my $iteration = 0;
    my $pagecount = 0;

    my $lastpage  = undef;

    for my $record (@{ $fascicle->Pages }) {

        $iteration++;

        # make new row in flow
        if ($itmcount == $Cpage->{xcount}) {
            $rowcount++;
            $blkcount  = -1;
            $sblkcount = 0;
            $itmcount  = 0;
        }

        # make new page in flow
        if (!$page || $rowcount == $Cpage->{ycount}) {

            $pagecount++;

            $page = $pdf->page->mediabox($PageWidth, $PageHeight);

            my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );

            draw_header($page, $font, $Cpage, $fascicle->Edition->shortcut ."/". $fascicle->shortcut);

            $itmcount = 0;
            $rowcount = 0;
        }

        # process flow

        $itmcount++;

        my $pagenum = $record->seqnum;
        my $pagemod = $record->seqnum %2;


        # firstpage
        if ($pagenum %2 == 1 && !$lastpage) {

        my $x = ($itmcount * $Cpage->{width}) - $Cpage->{width};
            $x = $x + ( $Cpage->{padding} * $blkcount ) + ( $Cpage->{spadding} * $sblkcount ) + $Cpage->{padding};

            my $y = 0 - ($rowcount * $Cpage->{height});
            $y = $y - ( ($Cpage->{padding}+20) * $rowcount );

            draw_empty_page($pdf, $page, $x, $y, $Cpage, $record);

            $itmcount++;
        }

        # block padding
        if ($pagenum %2 == 0 || $pagenum %2 == 1 && $lastpage %2 == 1 && $itmcount > 1 ) {
            $blkcount++
        } else {
            $sblkcount++
        }

        # empty pages
        if ($pagenum %2 == 1 && $pagenum - $lastpage != 1 || $pagenum %2 == 0 && $pagenum - $lastpage != 1 ) {

            my $x = ($itmcount * $Cpage->{width}) - $Cpage->{width};
            $x = $x + ( $Cpage->{padding} * $blkcount ) + ( $Cpage->{spadding} * $sblkcount ) + $Cpage->{padding};

            my $y = 0 - ($rowcount * $Cpage->{height});
            $y = $y - ( ($Cpage->{padding}+20) * $rowcount );

            draw_empty_page($pdf, $page, $x, $y, $Cpage, $record);

            $itmcount++;
        }

        # draw page
        my $x = ($itmcount * $Cpage->{width}) - $Cpage->{width};
        $x = $x + ( $Cpage->{padding} * $blkcount ) + ( $Cpage->{spadding} * $sblkcount ) + $Cpage->{padding};

        my $y = 0 - ($rowcount * $Cpage->{height});
        $y = $y - ( ($Cpage->{padding}+20) * $rowcount );

        draw_page($pdf, $page, $x, $y, $Cpage, $record);

        $lastpage = $pagenum;

    }

    my $tempPath = $c->config->get("store.temp");
    die "Cant write to $tempPath" unless -w $tempPath;

    my $pdf_filename = "$tempPath/". $c->uuid .".pdf";

    $pdf->saveas( $pdf_filename );
    $pdf->end;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $filename = "$Cpage->{name}_$edition->{shortcut}_$fascicle->{shortcut}_${mday}_". ($mon+1) ."_". ($year+1900) .".pdf";

    $filename =~ s/\s+/_/g;

    $c->tx->res->headers->content_length(-s $pdf_filename);
    $c->tx->res->headers->content_type("application/pdf;name=$filename");
    $c->tx->res->headers->content_disposition("attachment;name=$filename");

    $c->res->content->asset(
        Mojo::Asset::File->new(path => $pdf_filename )
    );

    $c->on(finish => sub {
        die 1;
        unlink $pdf_filename;
    });

    $c->rendered;
}

sub draw_page {

    my $pdf       = shift;

    my $page      = shift;

    my $x         = shift;
    my $y         = shift;
    my $PF        = shift;
    my $record    = shift;

    my $lines_x   = $record->w;
    my $lines_y   = $record->h;
    my $pagenum   = $record->seqnum;

    my $modules   = $record->Modules;
    my $documents = $record->Documents;
    my $holes     = $record->Holes;
    my $requests  = $record->Requests;

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
    foreach my $cord ( @$lines_x ) {
        my ($a,$b) = split '/', $cord;
        my $xcord = $x + ($width * ($a/$b));
        my $line = $page->gfx;
        $line->strokecolor('#C8C8C8');
        $line->move( $xcord, $y );
        $line->line( $xcord, $y+$height );
        $line->stroke;
    }

    foreach my $cord ( @$lines_y ) {
        my ($a,$b) = split '/', $cord;
        my $ycord = $height - ($height * ($a/$b)) + $y;
        my $line = $page->gfx;
        $line->strokecolor('#C8C8C8');
        $line->move( $x, $ycord );
        $line->line( $x+$width, $ycord );
        $line->stroke;
    }

    my $c = 0;

    # Draw modules
    foreach my $item (@$modules) {

        $c++;

        my $mw = $item->w;
        my $mh = $item->h;

        my $mx = $item->MapByPage($record->id)->x;
        my $my = $item->MapByPage($record->id)->y;

        my $modx = get_cord($mx);
        my $mody = get_cord($my);
        my $modw = get_cord($mw);
        my $modh = get_cord($mh);

        my $modxcord = $x + ($width * $modx);
        my $modycord = $y + ($height - ( ($height * $modh) + ($height * $mody) ) );

        my $modbox = $page->gfx;
        $modbox->fillcolor('#f5f5f5');
        $modbox->linewidth( .1 );
        $modbox->rect( $modxcord, $modycord, $width * $modw, $height * $modh );
        $modbox->fillstroke;

        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => 'silver',
                    size => $PF->{fontsize}/pt,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb->x($modxcord);
        $tb->y( $modycord + (($height * $modh)/2));
        $tb->w($width * $modw);
        $tb->h($height * $modh);
        $tb->align("center");
        $tb->lead($PF->{fontsize}/pt);
        $tb->page($page);
        $tb->text( encode( "cp1251", $item->title ."\n". $item->Request->shortcut) );
        $tb->apply;
    }

    # Draw documents
    my $box_color = "#C8C8C8";
    my $box_progress = 100;
    my $padding = 1;
    my $doccount = 0;
    foreach my $item (@$documents) {

        $doccount++;

        if ($box_progress > $item->{progress}) {
            $box_progress = $item->{progress};
            $box_color = "#" . $item->{color};
        }

        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => 'blue',
                    size => $PF->{fontsize}/pt,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb->x($x+$padding);
        $tb->y( $y + $height - $doccount* ($PF->{fontsize}/pt + 2) );
        $tb->w($width-$padding-$padding);
        $tb->h($PF->{fontsize}/pt + 100);

        my $text = encode("cp1251",
            "*" . $item->title
            ."\n".
            $item->headline_shortcut
            ."\n".
            $item->manager_shortcut
            ."\n".
            $item->pages
            ."\n");

        $tb->align("left");
        $tb->lead($PF->{fontsize}/pt + 2);
        $tb->page($page);
        $tb->text( $text );

        $tb->apply;
    }


    # Draw holes
    foreach my $item (@$holes) {

        $doccount++;

        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => 'black',
                    size => $PF->{fontsize}/pt,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb->x($x+$padding);
        $tb->y( $y + $height - $doccount* ($PF->{fontsize}/pt + 2) );
        $tb->w($width-$padding-$padding);
        $tb->h($PF->{fontsize}/pt);

        $tb->align("left");
        $tb->lead($PF->{fontsize}/pt);
        $tb->page($page);
        $tb->text( encode("cp1251", "[". $item->title ."]") );
        $tb->apply;

    }

    # Draw requests
    foreach my $item (@$requests) {

        $doccount++;

        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => 'black',
                    size => $PF->{fontsize}/pt,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb->x($x+$padding);
        $tb->y( $y + $height - $doccount* ($PF->{fontsize}/pt + 2) );
        $tb->w($width-$padding-$padding);
        $tb->h($PF->{fontsize}/pt);

        $tb->align("left");
        $tb->lead($PF->{fontsize}/pt);
        $tb->page($page);
        $tb->text( encode("cp1251", "[". $item->shortcut ."]") );
        $tb->apply;

    }

    # Draw box
    my $box = $page->gfx;
    $box->strokecolor($box_color);
    $box->linewidth( .1 );
    $box->rect( $x, $y, $width, $height );
    $box->stroke;

    return;
}

sub draw_empty_page {
    my $pdf       = shift;

    my $page      = shift;

    my $x         = shift;
    my $y         = shift;
    my $PF        = shift;
    my $record    = shift;

    my $lines_x   = $record->w;
    my $lines_y   = $record->h;

    my $top    = $PF->{top};
    my $width  = $PF->{width};
    my $height = $PF->{height};

    $y = $y +$top;

    # Draw lines
    my $blue_box = $page->gfx;
    $blue_box->strokecolor('#f5f5f5');
    $blue_box->linewidth( 1 );
    $blue_box->rect( $x, $y, $width, $height );
    $blue_box->stroke;

    $blue_box->linewidth( .1 );
}

sub draw_header {

    my $page = shift;
    my $font = shift;
    my $PF   = shift;

    my $string = shift;

    my @abbr = qw( Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь );
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $string .= ", $abbr[$mon] $mday, " . ($year + 1900) . " в $hour:$min";

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
