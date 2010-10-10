package Inprint::I18N::en;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use base 'Inprint::I18N';

use utf8;

our %Lexicon = (
  test => "test"
);

sub get {
    my $c = shift;
    my $key = shift;
    return $Lexicon{$key} || $key;
}

sub getAll {
    return \%Lexicon;
}

1;
