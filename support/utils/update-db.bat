dropdb -U inprint inprint-5.0
createdb -U inprint -E utf8 inprint-5.0
psql -U inprint inprint-5.0 < gazeta-2011-08-09.sql
