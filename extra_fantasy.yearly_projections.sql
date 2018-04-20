-- Table: extra_fantasy.yearly_projections

-- DROP TABLE extra_fantasy.yearly_projections;

CREATE TABLE extra_fantasy.yearly_projections
(
  yearly_projections_id serial NOT NULL,
  season_year smallint NOT NULL,
  nflcom_player_id character varying(10),
  source_player_name character varying(50),
  source character varying(50) NOT NULL,
  source_player_id character varying(50) NOT NULL,
  source_player_position character varying(20),
  source_player_team character varying(20),
  fantasy_points_ppr real,
  pass_att real,
  pass_cmp real,
  pass_int real,
  pass_td real,
  pass_yds real,
  sack real,
  rec real,
  rec_td real,
  rec_yds real,
  pass_targets real,
  rush_att real,
  rush_td real,
  rush_yds real,
  fumbles real,
  CONSTRAINT yearly_projections_pkey PRIMARY KEY (yearly_projections_id),
  CONSTRAINT yearly_projections_player_id_site_season_key UNIQUE (nflcom_player_id, source, season_year)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.yearly_projections
  OWNER TO nfldb;

-- Index: extra_fantasy.yearly_projections_season_player_id_idx

-- DROP INDEX extra_fantasy.yearly_projections_season_player_id_idx;

CREATE INDEX yearly_projections_season_player_id_idx
  ON extra_fantasy.yearly_projections
  USING btree
  (season_year, nflcom_player_id COLLATE pg_catalog."default");

-- Index: extra_fantasy.yearly_projections_season_pos_idx

-- DROP INDEX extra_fantasy.yearly_projections_season_pos_idx;

CREATE INDEX yearly_projections_season_pos_idx
  ON extra_fantasy.yearly_projections
  USING btree
  (season_year, source_player_position COLLATE pg_catalog."default");

