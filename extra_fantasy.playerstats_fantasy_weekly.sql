-- Table: extra_fantasy.playerstats_fantasy_weekly


-- DROP TABLE extra_fantasy.playerstats_fantasy_weekly;

CREATE TABLE extra_fantasy.playerstats_fantasy_weekly
(
  playerstats_fantasy_weekly_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  nflcom_player_id character varying(10),
  nflcom_team_id character varying(3),
  source character varying NOT NULL,
  source_player_id character varying,
  source_player_code character varying,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  source_team_id character varying NOT NULL,
  fantasy_points_std numeric(4,2),
  fantasy_points_ppr numeric(4,2),
  fantasy_points_hppr numeric(4,2),
  draftkings_points numeric(4,2),
  fanduel_points numeric(4,2),
  CONSTRAINT playerstats_fantasy_weekly_pkey PRIMARY KEY (playerstats_fantasy_weekly_id),
  CONSTRAINT playerstats_fantasy_weekly_season_year_week_source_nflcom_p_key UNIQUE (season_year, week, source, nflcom_player_id),
  CONSTRAINT playerstats_fantasy_weekly_season_year_week_source_source_p_cod UNIQUE (season_year, week, source, source_player_code),
  CONSTRAINT playerstats_fantasy_weekly_season_year_week_source_source_p_key UNIQUE (season_year, week, source, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.playerstats_fantasy_weekly
  OWNER TO nfldb;

-- Trigger: pfw_nflcom_player_id on extra_fantasy.playerstats_fantasy_weekly

-- DROP TRIGGER pfw_nflcom_player_id ON extra_fantasy.playerstats_fantasy_weekly;

CREATE TRIGGER pfw_nflcom_player_id
  BEFORE INSERT
  ON extra_fantasy.playerstats_fantasy_weekly
  FOR EACH ROW
  EXECUTE PROCEDURE extra_misc.nflcom_player_id();

