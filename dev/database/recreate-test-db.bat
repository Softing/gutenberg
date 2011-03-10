
set DB=inprint-5.0-test

dropdb -U inprint %DB%
createdb -U inprint -O inprint -E utf8 %DB%
psql -U inprint %DB% < inprint-dev-schema.sql
psql -U inprint %DB% < inprint-dev-data-10-common.sql
psql -U inprint %DB% < inprint-dev-data-20-advert.sql
psql -U inprint %DB% < inprint-dev-data-30-fascicles.sql
psql -U inprint %DB% < inprint-dev-data-50-demo.sql