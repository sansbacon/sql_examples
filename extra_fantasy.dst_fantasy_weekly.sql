-- Table: extra_fantasy.dst_fantasy_weekly
-- has fantasy scoring data for defense / special teams

-- DROP TABLE extra_fantasy.dst_fantasy_weekly;

CREATE TABLE extra_fantasy.dst_fantasy_weekly
(
  dst_fantasy_weekly_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  nflcom_player_id character varying,
  nflcom_team_id character varying,
  source character varying NOT NULL,
  source_player_id character varying,
  source_player_code character varying,
  source_player_name character varying NOT NULL,
  source_team_id character varying,
  source_player_position character varying DEFAULT 'DST'::character varying,
  sacks smallint,
  interceptions smallint,
  fumbles_recovered smallint,
  blocked_kicks smallint,
  safeties smallint,
  touchdowns smallint,
  rushing_yards smallint,
  passing_yards smallint,
  total_yards smallint,
  points_allowed smallint,
  dst_scoring_format character varying NOT NULL,
  fantasy_points smallint NOT NULL,
  CONSTRAINT dst_fantasy_weekly_pkey PRIMARY KEY (dst_fantasy_weekly_id),
  CONSTRAINT dst_fantasy_weekly_season_year_week_source_nflcom_player_id_key UNIQUE (season_year, week, source, nflcom_player_id, dst_scoring_format),
  CONSTRAINT dst_fantasy_weekly_season_year_week_source_source_player_id_key UNIQUE (season_year, week, source, source_player_id, dst_scoring_format)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.dst_fantasy_weekly
  OWNER TO nfldb;
