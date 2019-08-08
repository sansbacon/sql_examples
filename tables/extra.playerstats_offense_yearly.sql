-- Table: extra.playerstats_offense_yearly
-- Stores raw statistics for player on yearly basis

-- DROP TABLE extra.playerstats_offense_yearly;

CREATE TABLE extra.playerstats_offense_yearly
(
  playerstats_yearly_id integer NOT NULL DEFAULT nextval('extra.playerstats_yearly_playerstats_yearly_id_seq'::regclass),
  nflcom_player_id character varying(10),
  source character varying NOT NULL,
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  source_team_code character varying NOT NULL,
  season_year smallint NOT NULL,
  g smallint NOT NULL,
  gs smallint,
  pass_att smallint,
  pass_cmp smallint,
  pass_int smallint,
  pass_td smallint,
  pass_yds smallint,
  rec smallint,
  rec_td smallint,
  rec_yds smallint,
  rush_att smallint,
  rush_td smallint,
  rush_yds smallint,
  targets smallint,
  rec_target smallint,
  CONSTRAINT playerstats_yearly_pkey PRIMARY KEY (playerstats_yearly_id),
  CONSTRAINT playerstats_yearly_season_year_source_nflcom_player_id_key UNIQUE (season_year, source, nflcom_player_id),
  CONSTRAINT playerstats_yearly_season_year_source_source_player_id_key UNIQUE (season_year, source, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.playerstats_offense_yearly
  OWNER TO nfldb;

-- Index: extra.playerstats_offense_yearly_season_year_source_team_code_sou_idx

-- DROP INDEX extra.playerstats_offense_yearly_season_year_source_team_code_sou_idx;

CREATE INDEX playerstats_offense_yearly_season_year_source_team_code_sou_idx
  ON extra.playerstats_offense_yearly
  USING btree
  (season_year, source_team_code COLLATE pg_catalog."default", source_player_position COLLATE pg_catalog."default", nflcom_player_id COLLATE pg_catalog."default");

