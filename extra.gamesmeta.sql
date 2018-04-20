-- Table: extra.gamesmeta
-- gamesmeta stores "metainformation" about games
-- includes team, opponent, scores, lines

-- DROP TABLE extra.gamesmeta;

CREATE TABLE extra.gamesmeta
(
  games_meta_id serial NOT NULL,
  gsis_id gameid,
  season_year smallint,
  week smallint,
  game_date date NOT NULL,
  team_code character varying NOT NULL,
  opp character varying NOT NULL,
  days_last_game smallint,
  q1 smallint,
  q2 smallint,
  q3 smallint,
  q4 smallint,
  ot1 smallint,
  s smallint,
  is_ot boolean,
  consensus_spread numeric,
  consensus_game_ou numeric,
  consensus_implied_total numeric,
  is_home boolean,
  is_win boolean,
  CONSTRAINT gamesmeta_pkey PRIMARY KEY (games_meta_id),
  CONSTRAINT gamesmeta_season_year_week_team_code_key UNIQUE (season_year, week, team_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.gamesmeta
  OWNER TO nfldb;
