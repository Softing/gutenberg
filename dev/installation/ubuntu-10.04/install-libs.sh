apt-get install build-essential
apt-get install libdevel-simpletrace-perl
apt-get install libtest-mockmodule-perl
apt-get install libconfig-tiny-perl
apt-get install libdbd-pg-perl
apt-get install libyaml-perl
apt-get install libossp-uuid-perl
apt-get install libfile-copy-recursive-perl
apt-get install libwww-perl
apt-get install libhtml-scrubber-perl

perl -MCPAN -e 'install DBIx::Connector' 
perl -MCPAN -e 'install IO::Epoll'
perl -MCPAN -e 'install File::Util'