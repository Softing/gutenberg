#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::More;
use Inprint::Frameworks::Config;

my $config = new Inprint::Frameworks::Config();

ok( $config->load("$FindBin::Bin/../"), "Loading configuration from file");

ok( $config->set("core.language",   "ru"),                      "Set config value");
ok( $config->set("core.version",    "5.0"),                     "Set config value");
ok( $config->set("core.installed",  "yes"),                     "Set config value");
ok( $config->set("core.title",      "Inprint Content"),         "Set config value");
ok( $config->set("db.name",         "inprint-4.5"),             "Set config value");
ok( $config->set("db.host",         "localhost"),               "Set config value");
ok( $config->set("db.port",         "5432"),                    "Set config value");
ok( $config->set("db.user",         "inprint"),                 "Set config value");
ok( $config->set("db.password",     "inprint"),                 "Set config value");
ok( $config->set("store.path",      "/home/ilya/AAA/store"),    "Set config value");

ok( $config->write(), "Writing config");

ok( $config->get("core.language")   eq "ru",                    "Get configg value");
ok( $config->get("core.version")    eq "5.0",                   "Get configg value");
ok( $config->get("core.installed")  eq "yes",                   "Get configg value");
ok( $config->get("core.title")      eq "Inprint Content",       "Get configg value");
ok( $config->get("db.name")         eq "inprint-4.5",           "Get configg value");
ok( $config->get("db.host")         eq "localhost",             "Get configg value");
ok( $config->get("db.port")         eq "5432",                  "Get configg value");
ok( $config->get("db.user")         eq "inprint",               "Get configg value");
ok( $config->get("db.password")     eq "inprint",               "Get configg value");
ok( $config->get("store.path")      eq "/home/ilya/AAA/store",  "Get configg value");

ok( $config->set("test.test",      "test"),    "Set config value");
ok( $config->write(), "Writing config");
ok( $config->remove("test.test"),    "Delete config value");
ok( $config->write(), "Writing config");

done_testing();
