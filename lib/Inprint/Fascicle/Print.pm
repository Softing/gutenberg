package Inprint::Fascicle::Print;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use POSIX;
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

    width       => 82,
    height      => 75,
    
    htop        => 815,
    top         => 725,
    
    xcount      => 14,
    ycount      => 8,
    
    fontsize    => 6,
    fontmod     => 4,
    fontsizemax => 6,
    
    padding     => 5,
    spadding    => 0,
};

use constant A4 => {
    name        => "A4",

    width       => 81,
    height      => 70,
    
    top         => 490,
    htop        => 572,
    
    xcount      => 10,
    ycount      => 6,

    fontsize    => 6,
    fontmod     => 2,    
    fontsizemax => 10,    
    
    padding     => 5,
    spadding    => 0,
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

        $record->{headline} = $c->sql->Q("
            SELECT * FROM fascicles_indx_headlines WHERE id=?",
            [ $record->headline ])->Hash;
        
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

    # Pagenum
    my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );
    my $text = $page->text();
    $text->font($font, 8);
    $text->fillcolor("black");
    $text->translate($x + $width/2, $y-10 );
    $text->text_center($pagenum);
    
    # Headline
    my $text_headline  = PDF::TextBlock->new({
        pdf       => $pdf,
        fonts => {
            default => PDF::TextBlock::Font->new({
                pdf => $pdf,
                fillcolor => '#000000',
                size => 6,
                font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
            })
        }
    });

    if ($record->headline) {
        $text_headline->x($x);
        $text_headline->y($y + $height + 3);
        $text_headline->w($width);
        $text_headline->h(100);
        $text_headline->align("center");
        $text_headline->page($page);
        $text_headline->text( encode( "cp1251", $record->headline->{title}) );
        $text_headline->apply;
    }

    # Draw lines
    foreach my $cord ( @$lines_x ) {
        my ($a,$b) = split '/', $cord;
        my $xcord = $x + ($width * ($a/$b));
        my $line = $page->gfx;
        $line->strokecolor('#ececec');
        $line->move( $xcord, $y );
        $line->line( $xcord, $y+$height );
        $line->stroke;
    }

    foreach my $cord ( @$lines_y ) {
        my ($a,$b) = split '/', $cord;
        my $ycord = $height - ($height * ($a/$b)) + $y;
        my $line = $page->gfx;
        $line->strokecolor('#ececec');
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
        $modbox->linewidth( .1 );
        $modbox->rect( $modxcord, $modycord, $width * $modw, $height * $modh );
        $modbox->strokecolor("000000");
        $modbox->fillcolor('#d1d1d1');
        $modbox->fillstroke;

        my $module_x = $modxcord;
        my $module_y = $modycord + (($height * $modh)/2);
        my $module_w = $width * $modw;
        my $module_h = $height * $modh;

        my $tb1  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => '#000000',
                    size => 5,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb1->x($modxcord + 1);
        $tb1->y( $modycord + 1 );
        $tb1->w($width * $modw);
        $tb1->h($height * $modh);
        $tb1->align("left");
        $tb1->page($page);
        $tb1->text( encode( "cp1251", $item->title) );
        $tb1->apply;
        
        my $module_text = " " . $item->Request->shortcut;
        my $module_fontsize = ($PF->{fontsize}/pt);
        
        $module_fontsize = ceil( $module_w ) * $PF->{fontmod};
        
        if ($module_fontsize < $PF->{fontsize}) {
            $module_fontsize = $PF->{fontsize};
        }
        
        if ($module_fontsize > $PF->{fontsizemax}) {
            $module_fontsize = $PF->{fontsizemax};
        }
        
        my $tb  = PDF::TextBlock->new({
            pdf       => $pdf,
            fonts => {
                default => PDF::TextBlock::Font->new({
                    pdf => $pdf,
                    fillcolor => '#000000',
                    size => $module_fontsize,
                    font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                })
            }
        });

        $tb->x($modxcord);
        #my $ycenter = ceil ( ($modycord + $height * $modh) - $modycord) / 2;        
        #$tb->y( $modycord + $ycenter );
        
        $tb->y( $modycord + ($height * $modh - 10) );
        
        $tb->w($width * $modw);
        $tb->h($height * $modh);
        
        $tb->align("center");
        $tb->lead($module_fontsize * 1.2);
        
        $tb->page($page);

        $tb->text( encode( "cp1251", $module_text) );
        
        $tb->apply;
    }

    # Draw documents
    my $box_color = "#C8C8C8";
    my $box_progress = 100;
    my $padding = 1;
    
    my $y_offset = $y + $height - 8;

    # Draw holes
    if (@$holes) {

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
        
        my @hole_text;
        my $hole_text_length = 0;
        foreach my $item (@$holes) {
            my $text = "[". $item->title ."]";
            $hole_text_length += length($text);
            push @hole_text, $text;
        }

        my $tb_x = $x + $padding;
        my $tb_y = $y_offset;
        
        my $tb_w = $width;
        my $tb_h = $PF->{fontsize};
        
        #my $line_count = ceil ( ( $hole_text_length * $PF->{fontsize}) / $tb_w );
        
        my $line_count = 1;
        
        $tb->x($tb_x);
        $tb->y($tb_y);
        
        $tb->w($tb_w);
        #$tb->h($tb_h * $line_count);
        
        $tb->align("left");
        $tb->lead($PF->{fontsize} * 1.2);
        $tb->parspace(0);
        $tb->page($page);
        
        $tb->text(encode("cp1251", join(" ", @hole_text) ));
        
        my ($endw, $ypos) = $tb->apply;

        my $modbox = $page->gfx;
        $modbox->rect( $x, $ypos + 4, $tb->w, (($y + $height - 4) - ($ypos)) );
        $modbox->fillcolor('orange');
        $modbox->fill;
        
        ($endw, $ypos) = $tb->apply;
        
        $y_offset = $ypos - 6;
    }
    
    foreach my $item (@$documents) {

        my @pages = split /[^\d]/, $item->pages;
    
        my $is_first = 0;
        my $is_last  = 0;

        if ($pagenum == $pages[0]) {
            $is_first = 1;
        }
        
        if ($pagenum == $pages[$#pages]) {
            $is_last = 1;
        }
        
        my $fontsize = $PF->{fontsize}+1;
        
        my $box_x = ($x+$padding);
        my $box_y = $y_offset;
        
        $box_y = $y_offset;

        my $line_color = "black";
        if ($box_progress > $item->{progress}) {
            $box_progress = $item->{progress};
            $line_color = "#" . $item->{color};
        }
        
        my $gfx = $page->gfx();

        # Draw document
        if ( $is_first || ( $is_last && $#$documents > 0 && $pagenum -1 != $pages[0] ) ) {
            
            my $tb  = PDF::TextBlock->new({
                pdf       => $pdf,
                fonts => {
                    default => PDF::TextBlock::Font->new({
                        pdf => $pdf,
                        fillcolor => 'black',
                        size => $fontsize,
                        font => $pdf->corefont( "Verdana", -encode=> "windows-1251" )
                    })
                }
            });
    
            $tb->x($box_x);
            $tb->y($box_y);

            my $box_w = $width-$padding-$padding;
            my $box_h = $fontsize + 1600;

            if ($pagenum+1 ~~ @pages) {
                $box_w += $box_w;
            }
            
            if ($pagenum+2 ~~ @pages) {
                $box_w += $box_w;
            }
            
            $tb->w($box_w + 0);
            $tb->h($box_h);

            my $text = encode("cp1251",
                ( $item->title || "--" ) ." / ". ( $item->manager_shortcut || "--" )
            );
            
            $tb->align("left");
            $tb->lead($fontsize * 1.2);
            $tb->page($page);
            $tb->text( $text );
            
            my ($endw, $ypos) = $tb->apply;
            
            $y_offset = $ypos + 5;
        }

        # Draw line
        my $line_height = $y_offset;
        
        $gfx->strokecolor($line_color);
        $gfx->linewidth(1);
        
        $gfx->move( $box_x, $line_height );
        $gfx->line( $box_x + $width - 2, $line_height );
        $gfx->stroke;
        
        if ($is_first) {
            $gfx->fillcolor($line_color);
            $gfx->circle($box_x, $line_height, 2);
            $gfx->fill();
            $gfx->save;
        }
        
        if ($is_last) {
            $gfx->fillcolor($line_color);
            $gfx->circle($box_x + $width - 2, $line_height, 2);
            $gfx->fill();
            $gfx->save;
        }
        
        $y_offset = $y_offset - 12;
        
    }

=cut
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
=cut

    # Draw box
    my $box = $page->gfx;    
    $box->linewidth( .1 );
    $box->rect( $x, $y, $width, $height );
    $box->strokecolor("000000");
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
