#!/bin/sh

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

apt-get -y install build-essential

apt-get -y install libconfig-tiny-perl
apt-get -y install libdbd-pg-perl
apt-get -y install libdevel-simpletrace-perl
apt-get -y install libfile-copy-recursive-perl
apt-get -y install libgd-gd2-perl
apt-get -y install libgd-text-perl
apt-get -y install libhtml-scrubber-perl
apt-get -y install libossp-uuid-perl
apt-get -y install libtext-unidecode-perl
apt-get -y install libtest-mockmodule-perl
apt-get -y install libwww-perl
apt-get -y install libyaml-perl
apt-get -y install libimage-exiftool-perl

apt-get -y install apache2
apt-get -y install ghostscript
apt-get -y install imagemagick
apt-get -y install perlmagick
apt-get -y install postgresql
apt-get -y install postgresql-contrib
apt-get -y install sun-java6-jre

a2enmod rewrite
a2enmod expires

/etc/init.d/apache2 restart
/etc/init.d/postgresql-8.4 restart

perl -MCPAN -e 'install DBIx::Connector'
perl -MCPAN -e 'install IO::Epoll'
perl -MCPAN -e 'install File::Util'
perl -MCPAN -e 'install Convert::Cyrillic'
perl -MCPAN -e 'install Mojolicious'
