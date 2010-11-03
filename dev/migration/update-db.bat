dropdb -U inprint -W -h localhost inprint-4.5
createdb -U inprint -W -h localhost inprint-4.5
psql -U inprint -W -h localhost inprint-4.5 < inprint-4.5.sql 