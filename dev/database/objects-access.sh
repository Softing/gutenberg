#!/bin/sh

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

sudo -u postgres psql inprint-5.0 -c " SELECT 'GRANT ALL ON ' || schemaname || '.' || tablename || ' TO inprint;' FROM pg_tables WHERE schemaname IN ('public', 'plugins') ORDER BY schemaname, tablename; "
