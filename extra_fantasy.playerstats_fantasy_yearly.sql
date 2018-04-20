-- Table: extra_fantasy.playerstats_fantasy_yearly

-- DROP TABLE extra_fantasy.playerstats_fantasy_yearly;

CREATE TABLE extra_fantasy.playerstats_fantasy_yearly
(
  playerstats_fantasy_yearly_id serial NOT NULL,
  nflcom_player_id character varying(10),
  source character varying NOT NULL,
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  source_team_code character varying NOT NULL,
  season_year smallint NOT NULL,
  g smallint NOT NULL,
  gs smallint,
  draftkings_points real,
  fanduel_points real,
  fantasy_points_std real,
  fantasy_points_ppr real,
  CONSTRAINT playerstats_fantasy_yearly_pkey PRIMARY KEY (playerstats_fantasy_yearly_id),
  CONSTRAINT playerstats_fantasy_yearly_season_year_source_nflcom_player_key UNIQUE (season_year, source, nflcom_player_id),
  CONSTRAINT playerstats_fantasy_yearly_season_year_source_source_player_key UNIQUE (season_year, source, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.playerstats_fantasy_yearly
  OWNER TO nfldb;

-- Trigger: pfyi_nflcom_player_id on extra_fantasy.playerstats_fantasy_yearly

-- DROP TRIGGER pfyi_nflcom_player_id ON extra_fantasy.playerstats_fantasy_yearly;

CREATE TRIGGER pfyi_nflcom_player_id
  BEFORE INSERT
  ON extra_fantasy.playerstats_fantasy_yearly
  FOR EACH ROW
  EXECUTE PROCEDURE extra_misc.nflcom_player_id();

