#!/bin/sh

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

PERL_VERSION=5.16

#sudo port install p$PERL_VERSION-dbd-pg
#sudo port install p$PERL_VERSION-config-tiny
#sudo port install p$PERL_VERSION-data-uuid
#sudo port install p$PERL_VERSION-file-copy-recursive
#sudo port install p$PERL_VERSION-libwww-perl 
#sudo port install p$PERL_VERSION-scalar-list-utils
#sudo port install p$PERL_VERSION-moose
#sudo port install p$PERL_VERSION-moosex-types
#sudo port install p$PERL_VERSION-json-any
#sudo port install p$PERL_VERSION-gd
#sudo port install p$PERL_VERSION-gdtextutil

sudo perl -MCPAN -e 'install Mojolicious'
sudo perl -MCPAN -e 'install Mojolicious::Plugin::I18N'
sudo perl -MCPAN -e 'install DBIx::Connector'
sudo perl -MCPAN -e 'install Devel::SimpleTrace'
sudo perl -MCPAN -e 'install File::Util'
sudo perl -MCPAN -e 'install Text::Unidecode'
sudo perl -MCPAN -e 'install GD::Tiler'
sudo perl -MCPAN -e 'install MooseX::Storage'
sudo perl -MCPAN -e 'install MooseX::UndefTolerant'
