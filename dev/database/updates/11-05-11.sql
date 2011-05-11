ALTER TABLE ad_modules RENAME COLUMN check_width TO width;
ALTER TABLE ad_modules RENAME COLUMN check_height TO height;
ALTER TABLE ad_modules RENAME COLUMN check_width_float TO fwidth;
ALTER TABLE ad_modules RENAME COLUMN check_height_float TO fheight;

ALTER TABLE fascicles_modules RENAME COLUMN check_width TO width;
ALTER TABLE fascicles_modules RENAME COLUMN check_height TO height;
ALTER TABLE fascicles_modules RENAME COLUMN check_width_float TO fwidth;
ALTER TABLE fascicles_modules RENAME COLUMN check_height_float TO fheight;

//ALTER TABLE fascicles_requests ADD COLUMN origin_width   real DEFAULT 0 NOT NULL;
//ALTER TABLE fascicles_requests ADD COLUMN origin_height  real DEFAULT 0 NOT NULL;
//ALTER TABLE fascicles_requests ADD COLUMN origin_fwidth  real DEFAULT 0 NOT NULL;
//ALTER TABLE fascicles_requests ADD COLUMN origin_fheight real DEFAULT 0 NOT NULL;

ALTER TABLE fascicles_tmpl_modules ADD COLUMN width   real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_tmpl_modules ADD COLUMN height  real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_tmpl_modules ADD COLUMN fwidth  real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_tmpl_modules ADD COLUMN fheight real DEFAULT 0 NOT NULL;


