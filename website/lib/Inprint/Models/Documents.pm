package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

use Inprint::Store::Embedded;
use Inprint::Utils::Files;

use Inprint::Models::Documents::Create;
use Inprint::Models::Documents::Read;
use Inprint::Models::Documents::Update;
use Inprint::Models::Documents::Delete;
use Inprint::Models::Documents::Search;
use Inprint::Models::Documents::Utils;

1;
