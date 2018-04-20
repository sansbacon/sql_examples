-- Table: extra_misc.season
-- information about start/end of nfl seasons

-- DROP TABLE extra_misc.season;

CREATE TABLE extra_misc.season
(
  season_id serial NOT NULL,
  season_year smallint,
  week smallint,
  week_start timestamp without time zone,
  week_end timestamp without time zone,
  CONSTRAINT season_pkey PRIMARY KEY (season_id),
  CONSTRAINT season_season_year_week_key UNIQUE (season_year, week)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_misc.season
  OWNER TO nfldb;
