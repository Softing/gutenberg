package Inprint::Utils::MooseUUID;
use strict;
use warnings;

our $VERSION = '0.02';
our $AUTHORITY = 'CPAN:JROCKWAY';

use MooseX::Types -declare => ['UUID'];
use MooseX::Types::Moose qw(Str);

sub _validate_uuid {
    my ($str) = @_;
	$str = uc($str);
    return $str =~ /^[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}$/;
}

subtype UUID,
  as Str, where { _validate_uuid($_) };

coerce UUID,
  # i've never seen lowercase UUIDs, but someone's bound to try it
  from Str, via { uc };

1;

__END__