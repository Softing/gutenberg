#!C:\strawberry\perl\bin\perl.exe

use strict;
use warnings;

use FindBin;


use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";

# Check if Mojo is installed
eval 'use Mojolicious::Commands';
die <<EOF if $@;
It looks like you don't have the Mojo Framework installed.
Please visit http://mojolicious.org for detailed installation instructions.

EOF

#$ENV{MOJO_TMPDIR} = 'tmp/upload';
$ENV{MOJO_MAX_MESSAGE_SIZE} = 50 * 1024 * 1024; # 50 MB

# Application
$ENV{MOJO_APP} ||= 'Inprint';

# Start commands
Mojolicious::Commands->start;