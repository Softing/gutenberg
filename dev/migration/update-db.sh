sudo -u postgres dropdb inprint-4.5 
sudo -u postgres createdb inprint-4.5 -O inprint -E utf8 
sudo -u postgres psql inprint-4.5 < inprint-4.5.sql
