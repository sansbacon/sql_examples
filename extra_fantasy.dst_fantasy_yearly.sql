-- Table: extra_fantasy.dst_fantasy_yearly
-- has fantasy scoring data for defense / special teams

-- DROP TABLE extra_fantasy.dst_fantasy_yearly;

CREATE TABLE extra_fantasy.dst_fantasy_yearly
(
  dst_fantasy_yearly_id serial NOT NULL,
  season_year smallint NOT NULL,
  nflcom_player_id character varying,
  nflcom_team_id character varying,
  source character varying NOT NULL,
  source_player_id character varying,
  source_player_code character varying,
  source_player_name character varying NOT NULL,
  source_team_id character varying,
  source_player_position character varying DEFAULT 'DST'::character varying,
  sacks numeric(5,2),
  interceptions numeric(5,2),
  fumbles_recovered numeric(5,2),
  blocked_kicks numeric(5,2),
  safeties numeric(5,2),
  touchdowns numeric(5,2),
  rushing_yards numeric(5,2),
  passing_yards numeric(5,2),
  total_yards numeric(5,2),
  points_allowed numeric(5,2),
  dst_scoring_format character varying NOT NULL,
  fantasy_points numeric(5,2) NOT NULL,
  CONSTRAINT dst_fantasy_yearly_pkey PRIMARY KEY (dst_fantasy_yearly_id),
  CONSTRAINT dst_fantasy_yearly_season_year_source_nflcom_player_id_dst__key UNIQUE (season_year, source, nflcom_player_id, dst_scoring_format),
  CONSTRAINT dst_fantasy_yearly_season_year_source_source_player_id_dst__key UNIQUE (season_year, source, source_player_id, dst_scoring_format)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.dst_fantasy_yearly
  OWNER TO nfldb;
