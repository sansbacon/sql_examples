-- Table: extra_fantasy.weekly_experts_rankings
-- keeps weekly rankings by fantasypros experts

-- DROP TABLE extra_fantasy.weekly_experts_rankings;

CREATE TABLE extra_fantasy.weekly_experts_rankings
(
  weekly_experts_rankings_id serial NOT NULL,
  source character varying NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  nflcom_player_id character varying(10),
  source_player_id character varying NOT NULL,
  source_player_code character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_player_position character varying NOT NULL,
  nflcom_team_id character varying(3),
  source_player_team character varying(3) NOT NULL,
  expert_name character varying(50) NOT NULL,
  expert_affiliation character varying(50) NOT NULL,
  ranking_type character varying(10) NOT NULL,
  scoring_format character varying(5) NOT NULL,
  source_positional_rank smallint NOT NULL,
  source_positional_rank_vs_ecr smallint NOT NULL,
  CONSTRAINT weekly_experts_rankings_pkey PRIMARY KEY (weekly_experts_rankings_id),
  CONSTRAINT weekly_experts_rankings_season_year_week_source_expert_name_key UNIQUE (season_year, week, source, expert_name, expert_affiliation, source_player_id, ranking_type, scoring_format)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.weekly_experts_rankings
  OWNER TO nfldb;
