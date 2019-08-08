-- Table: extra.snapcounts
-- Data from footballoutsiders
-- TODO: need to update this data

-- DROP TABLE extra.snapcounts;

CREATE TABLE extra.snapcounts
(
  snapcounts_id serial NOT NULL,
  nflcom_player_id character varying(10) NOT NULL,
  gsis_id gameid,
  season_year smallint,
  week smallint,
  source character varying(50),
  source_player_id character varying(50),
  source_player_name character varying(50),
  source_player_position character varying(10),
  source_player_team character varying(10),
  started boolean,
  total_snaps smallint,
  def_snap_pct numeric,
  def_snaps smallint,
  off_snap_pct numeric,
  off_snaps smallint,
  st_snap_pct numeric,
  st_snaps smallint,
  CONSTRAINT snapcounts_pkey PRIMARY KEY (snapcounts_id),
  CONSTRAINT pid_season_week_site UNIQUE (nflcom_player_id, season_year, week, source)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.snapcounts
  OWNER TO nfldb;
