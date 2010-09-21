#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";

# Enable log redirection
use CGI::Carp qw(carpout);
open(my $LOG, ">>$FindBin::Bin/../log/application.log")
    or die("Unable to open mycgi-log: $!\n");
carpout($LOG);

# Check if Mojo is installed
eval 'use Mojolicious::Commands';
die <<EOF if $@;
It looks like you don't have the Mojo Framework installed.
Please visit http://mojolicious.org for detailed installation instructions.

EOF

# Application
$ENV{MOJO_APP} ||= 'Inprint';

# Start commands
Mojolicious::Commands->start('cgi');
