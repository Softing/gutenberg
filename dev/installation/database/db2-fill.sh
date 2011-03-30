#!/bin/sh

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

sudo -u postgres psql -d template1 -c "CREATE USER inprint WITH PASSWORD 'inprint';"
sudo -u postgres psql -d template1 -c "CREATE DATABASE \"inprint-5.0\" OWNER inprint ENCODING 'UTF8'"
sudo -u postgres psql -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE \"inprint-5.0\" TO inprint;"

sudo -u postgres psql inprint-5.0 < inprint-5.0-schema.sql
sudo -u postgres psql inprint-5.0 < inprint-5.0-data.sql
sudo -u postgres psql inprint-5.0 < inprint-5.0-access.sql

