ALTER TABLE ad_modules ADD COLUMN check_width real DEFAULT 0 NOT NULL;
ALTER TABLE ad_modules ADD COLUMN check_height real DEFAULT 0 NOT NULL;
ALTER TABLE ad_modules ADD COLUMN check_width_float real DEFAULT 0 NOT NULL;
ALTER TABLE ad_modules ADD COLUMN check_height_float real DEFAULT 0 NOT NULL;

ALTER TABLE fascicles_modules ADD COLUMN check_width real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_modules ADD COLUMN check_height real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_modules ADD COLUMN check_width_float real DEFAULT 0 NOT NULL;
ALTER TABLE fascicles_modules ADD COLUMN check_height_float real DEFAULT 0 NOT NULL;

ALTER TABLE cache_files ADD COLUMN file_color varchar;
ALTER TABLE cache_files ADD COLUMN file_resolution int4 DEFAULT 0 NOT NULL;
ALTER TABLE cache_files ADD COLUMN file_width real DEFAULT 0 NOT NULL;
ALTER TABLE cache_files ADD COLUMN file_height real DEFAULT 0 NOT NULL;

ALTER TABLE fascicles_requests ADD COLUMN check_status varchar DEFAULT 'new' NOT NULL;
ALTER TABLE fascicles_requests ADD COLUMN anothers_layout boolean DEFAULT false NOT NULL;
ALTER TABLE fascicles_requests ADD COLUMN imposed boolean DEFAULT false NOT NULL;

CREATE TABLE fascicles_requests_comments
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  entity uuid NOT NULL,
  member uuid NOT NULL,
  member_shortcut character varying NOT NULL,
  check_status  character varying NOT NULL,
  fulltext character varying NOT NULL,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT fascicles_requests_comments_pkey PRIMARY KEY (id)
);

CREATE TABLE fascicles_requests_files
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  fpath character varying NOT NULL,
  fname character varying NOT NULL,
  forname character varying NOT NULL,
  fextension character varying NOT NULL,
  fmime character varying NOT NULL,
  fdigest character varying NOT NULL,
  fthumbnail character varying,
  fdescription character varying,
  fsize integer NOT NULL DEFAULT 0,
  flength integer NOT NULL DEFAULT 0,
  fcolor character varying,
  fresolution integer NOT NULL DEFAULT 0,
  fwidth real NOT NULL DEFAULT 0,
  fheight real NOT NULL DEFAULT 0,
  fexists boolean NOT NULL DEFAULT true,
  fimpose boolean NOT NULL DEFAULT true,
  fstatus character varying,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT fascicles_requests_files_pkey PRIMARY KEY (id),
  CONSTRAINT fascicles_requests_files_fpath_key UNIQUE (fpath, fname)
);