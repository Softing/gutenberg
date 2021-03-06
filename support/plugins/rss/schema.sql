CREATE SCHEMA plugins_rss;

SET search_path = plugins_rss, pg_catalog;

CREATE TABLE rss
(
  id uuid NOT NULL DEFAULT public.uuid_generate_v4(),
  entity uuid NOT NULL,
  title character varying NOT NULL,
  description character varying NOT NULL,
  fulltext character varying,
  sitelink character varying NOT NULL,
  priority character varying NOT NULL DEFAULT 0, 
  published boolean NOT NULL DEFAULT false,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT rss_pkey PRIMARY KEY (id)
);

CREATE TABLE rss_feeds
(
  id uuid NOT NULL DEFAULT public.uuid_generate_v4(),
  url character varying NOT NULL,
  title character varying NOT NULL,
  description character varying NOT NULL,
  published boolean NOT NULL DEFAULT false,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT rss_feeds_pkey PRIMARY KEY (id)
);


CREATE TABLE rss_feeds_mapping
(
  id uuid NOT NULL DEFAULT public.uuid_generate_v4(),
  feed uuid NOT NULL,
  nature character varying NOT NULL,
  tag uuid NOT NULL,
  CONSTRAINT rss_feeds_mapping_pkey PRIMARY KEY (id),
  CONSTRAINT rss_feeds_mapping_feed_fkey FOREIGN KEY (feed)
      REFERENCES plugins_rss.rss_feeds (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);