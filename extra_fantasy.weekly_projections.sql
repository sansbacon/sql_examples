-- Table: extra_fantasy.weekly_projections
-- TODO: this is basically empty

-- DROP TABLE extra_fantasy.weekly_projections;

CREATE TABLE extra_fantasy.weekly_projections
(
  weekly_projections_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  source character varying NOT NULL,
  nflcom_player_id character varying(10),
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  source_team_code character varying NOT NULL,
  projection_type character varying NOT NULL,
  projection numeric NOT NULL,
  CONSTRAINT weekly_projections_pkey PRIMARY KEY (weekly_projections_id),
  CONSTRAINT weekly_projections_source_season_year_week_source_player_id_key UNIQUE (source, season_year, week, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.weekly_projections
  OWNER TO nfldb;
