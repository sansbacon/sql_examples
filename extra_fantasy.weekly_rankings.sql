-- Table: extra_fantasy.weekly_rankings

-- DROP TABLE extra_fantasy.weekly_rankings;

CREATE TABLE extra_fantasy.weekly_rankings
(
  weekly_rankings_id serial NOT NULL,
  source character varying NOT NULL,
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  source_player_team character varying,
  source_player_opp character varying,
  rank smallint NOT NULL,
  avg numeric,
  best smallint,
  worst smallint,
  stdev numeric,
  gsis_id gameid,
  nflcom_player_id character varying(10),
  nflcom_team_id character varying(3),
  ranking_type character varying(5),
  scoring_format character varying(5),
  source_last_updated date,
  CONSTRAINT weekly_rankings_pkey PRIMARY KEY (weekly_rankings_id),
  CONSTRAINT weekly_rankings_source_season_year_week_source_player_id_fmt_ke UNIQUE (source, season_year, week, source_player_id, scoring_format, ranking_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.weekly_rankings
  OWNER TO nfldb;

-- Index: extra_fantasy.weekly_rankings_season_year_week_position_rank_idx

-- DROP INDEX extra_fantasy.weekly_rankings_season_year_week_position_rank_idx;

CREATE INDEX weekly_rankings_season_year_week_position_rank_idx
  ON extra_fantasy.weekly_rankings
  USING btree
  (season_year, week, source_player_position COLLATE pg_catalog."default", rank);

