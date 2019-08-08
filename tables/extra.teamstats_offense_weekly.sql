-- Table: extra.teamstats_offense_weekly

-- DROP TABLE extra.teamstats_offense_weekly;

CREATE TABLE extra.teamstats_offense_weekly
(
  teamstats_offense_weekly_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  source character varying,
  source_team_code character varying NOT NULL,
  pass_cmp smallint,
  pass_att smallint,
  pass_yds smallint,
  pass_int smallint,
  pass_td smallint,
  pass_sacked smallint,
  pass_sacked_yds smallint,
  rush_att smallint,
  rush_yds smallint,
  rush_td smallint,
  plays_offense smallint,
  CONSTRAINT teamstats_offense_weekly_pkey PRIMARY KEY (teamstats_offense_weekly_id),
  CONSTRAINT unique_season_year_week_source_source_team_code UNIQUE (season_year, week, source, source_team_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.teamstats_offense_weekly
  OWNER TO nfldb;
