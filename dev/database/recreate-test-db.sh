#/bin/sh

dropdb -U inprint inprint-5.0-test
createdb -U inprint -O inprint -E utf8 inprint-5.0-test
psql -U inprint inprint-5.0-test < inprint-dev-schema.sql
psql -U inprint inprint-5.0-test < inprint-dev-data-10-common.sql
psql -U inprint inprint-5.0-test < inprint-dev-data-20-advert.sql
psql -U inprint inprint-5.0-test < inprint-dev-data-30-fascicles.sql