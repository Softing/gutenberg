package Inprint::Locale;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub index {

    my $c = shift;
    
    my $json   = Mojo::JSON->new;
    
    my $string = $c->stash->{i18n}->_handle->getAll;
    
    my $jsonString = $json->encode( $string );
    
    $jsonString = "
        var inprintLocalization = $jsonString;
        function _(arg) {
            return inprintLocalization[arg] || arg;
        }
    ";

    $jsonString =~ s/\t//g;
    $jsonString =~ s/\s+/ /g;

    $c->tx->res->headers->header('Content-Type' => "text/javascript; charset=utf-8;"); 
    $c->render_text($jsonString);
}

1;