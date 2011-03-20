CREATE TABLE rss
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  "document" uuid NOT NULL,
  link character varying NOT NULL,
  title character varying NOT NULL,
  description character varying NOT NULL,
  fulltext character varying,
  published boolean NOT NULL DEFAULT false,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT rss_pkey PRIMARY KEY (id)
);

CREATE TABLE rss_feeds_mapping
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  feed uuid NOT NULL,
  nature character varying NOT NULL,
  tag uuid NOT NULL,
  CONSTRAINT rss_feeds_mapping_pkey PRIMARY KEY (id),
  CONSTRAINT rss_feeds_mapping_feed_fkey FOREIGN KEY (feed)
      REFERENCES rss_feeds (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE rss_feeds
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  url character varying NOT NULL,
  title character varying NOT NULL,
  description character varying NOT NULL,
  published boolean NOT NULL DEFAULT false,
  created timestamp(6) with time zone NOT NULL DEFAULT now(),
  updated timestamp(6) with time zone NOT NULL DEFAULT now(),
  CONSTRAINT rss_feeds_pkey PRIMARY KEY (id)
);

INSERT INTO rss_feeds(id, url, title, description, published, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', 'default', 'По умолчанию', 'По умолчанию', true, now(), now());
