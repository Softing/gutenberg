#!/usr/bin/perl

use utf8; 
use strict;

use Encode qw(decode encode);
use PDF::API2;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

my $PageSize = "A4";
my $PageOrientation = "landscape";

my ($x1, $y1, $PageWidth, $PageHeight) = PDF::API2::Util::page_size($PageSize);

my $A3 = {
	top 	=> 800,
	width 	=> 100,
	height 	=> 140,
};

my $A4 = {
	
	top 	=> 460,
	htop 	=> 570,
	ftop 	=> 20,
	
	pcx		=> 10,
	pcy		=> 20,
	
	xcount  => 10,
	ycount  => 5,
	
	padding => 5,
	width 	=> 75,
	height 	=> 100,
};

my $Cpage = $A4;

if ($PageOrientation eq "landscape") {
    my $tempW = $PageWidth;
    $PageWidth = $PageHeight;
    $PageHeight = $tempW;
    $tempW = undef;
}

##################################################

my $pdf = PDF::API2->new();

my $pages = [
	
	{ pagenum => 1, pagename => "Азия",
		linex => [ "1/10", "1/2", "9/10" ], liney => [ "1/10", "9/10" ],
		documents => [ "text 1", "text 2" ],
		modules => [
			[ "0/1", "1/10", "1/2", "1/2" ]
		]
	},
	
	{ pagenum => 2, pagename => "Азия",
		linex => [ "1/2", "9/10" ], liney => [ "1/10", "9/10" ],
		modules => [
			[ "0/1", "1/10", "1/2", "1/2" ]
		]
	},
	{ pagenum => 3, pagename => "Азия",
		linex => [ "1/2", "9/10" ], liney => [ "1/10", "9/10" ],
		modules => [
			[ "0/1", "1/10", "1/2", "1/2" ]
		]
	},
	
	{ pagenum => 4, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
	{ pagenum => 5, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
	
	{ pagenum => 7, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
	
	{ pagenum => 8, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
	{ pagenum => 9, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
	
	{ pagenum => 11, pagename => "Азия",
		linex => [ "1/10", "1/2", "1/3" ], liney => [ "1/10", "9/10" ]
	},
];

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
	
	draw_page($page, $x, $y, $Cpage, $record );
	
	$lastpage = $pagenum;
}

$pdf->saveas( 'table.pdf' );

sub draw_page {

	my $page 		= shift;
	my $x 			= shift;
	my $y 			= shift;
	my $PF 			= shift;
	my $record 		= shift;
	
	my $lines_x 	= $record->{linex};
	my $lines_y 	= $record->{liney};
	my $documents 	= $record->{documents};
	my $pagenum 	= $record->{pagenum};
	my $modules 	= $record->{modules};
	
	my $top    		= $PF->{top};
	my $width 	 	= $PF->{width};
	my $height 		= $PF->{height};
	
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

	# Draw modules
	foreach my $item (@$modules) {
		my ($mx, $my, $mw, $mh) = @{ $item };
		
		my $modx = get_cord($mx);
		my $mody = get_cord($my);
		my $modw = get_cord($mw);
		my $modh = get_cord($mh);
		
		my $modxcord = $x + ($width * $modx);
		my $modycord = $y + ($height * $modh);
		
		my $modbox = $page->gfx;
		
		$modbox->fillcolor('black');
		$modbox->linewidth( .1 );
		$modbox->rect( $modxcord, $modycord, $width * $modw, $height * $modh );
		$modbox->fill;
		
		print "$modx $mody $modw $modh = $modxcord $modycord\n";
		
		
	}
	
	# Draw documents
	my $doccount = 0;
	foreach my $item (@$documents) {
	
		$doccount++;
		
		my $padding = 4;
		
		my $textbox = $page->gfx;
		$textbox->fillcolor("#f5f5f5");
		$textbox->rect( $x+$padding, $y + $height - $doccount*10, $width-$padding-$padding, 8 );
		$textbox->fill;
		
		my $font = $pdf->corefont( "Verdana", -encode=> "windows-1251" );
		my $text = $page->text();
		$text->font($font, 6);
		$text->fillcolor("black");
		$text->translate($x+5, $y + $height - $doccount*8 );
		$text->text(encode( "cp1251", $item ));
		
	}
	
}

sub draw_empty_page {

	my $page 		= shift;
	my $x 			= shift;
	my $y 			= shift;
	my $PF 			= shift;
	
	my $top    		= $PF->{top};
	my $width 	 	= $PF->{width};
	my $height 		= $PF->{height};
	
	$y = $y +$top;
	
	# Draw lines
	my $empty_box = $page->gfx;
	$empty_box->strokecolor("#F5F5F5");
	$empty_box->linewidth( 1 );
	$empty_box->rect( $x, $y, $width, $height );
	$empty_box->stroke;
	
}

sub draw_header {

	my $page  	= shift;
	my $font  	= shift;
	my $PF 		= shift;
	
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

#my $blue_box = $page->gfx;
#$blue_box->fillcolor("red");
#$blue_box->strokecolor("red");
#$blue_box->rect( getX(10), getY(10), 100, 150 );
#$blue_box->rect( 10, 10, 100, 150 );
#$blue_box->fill;
#$blue_box->stroke;
#$blue_box->fill(1);
#$blue_box->fillstroke;