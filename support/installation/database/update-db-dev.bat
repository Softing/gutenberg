dropdb -U inprint inprint-5.0
createdb -U inprint -E utf8 inprint-5.0
psql -U inprint inprint-5.0 < inprint-5.0-dev-schema.sql
psql -U inprint inprint-5.0 < inprint-5.0-data.sql