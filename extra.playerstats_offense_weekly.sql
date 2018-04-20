-- Table: extra.playerstats_offense_weekly
-- Stores raw statistics for player on weekly basis

-- DROP TABLE extra.playerstats_offense_weekly;

CREATE TABLE extra.playerstats_offense_weekly
(
  playerstats_weekly_id serial NOT NULL,
  nflcom_player_id character varying(10),
  source character varying NOT NULL,
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  source_team_code character varying NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
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
  CONSTRAINT playerstats_offense_weekly_pkey PRIMARY KEY (playerstats_weekly_id),
  CONSTRAINT playerstats_offense_weekly_season_year_week_source_nflcom_p_key UNIQUE (season_year, week, source, nflcom_player_id),
  CONSTRAINT playerstats_offense_weekly_season_year_week_source_source_p_key UNIQUE (season_year, week, source, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.playerstats_offense_weekly
  OWNER TO nfldb;

-- Index: extra.playerstats_offense_weekly_season_year_week_source_team_cod_idx

-- DROP INDEX extra.playerstats_offense_weekly_season_year_week_source_team_cod_idx;

CREATE INDEX playerstats_offense_weekly_season_year_week_source_team_cod_idx
  ON extra.playerstats_offense_weekly
  USING btree
  (season_year, week, source_team_code COLLATE pg_catalog."default", source_player_position COLLATE pg_catalog."default", nflcom_player_id COLLATE pg_catalog."default");

