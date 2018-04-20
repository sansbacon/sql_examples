-- Table: extra.teamstats_defense_yearly

-- DROP TABLE extra.teamstats_defense_yearly;

CREATE TABLE extra.teamstats_defense_yearly
(
  teamstats_defense_yearly_id serial NOT NULL,
  season_year smallint NOT NULL,
  source character varying,
  source_team_code character varying NOT NULL,
  plays_defense smallint,
  pass_cmp_opp smallint,
  pass_att_opp smallint,
  pass_yds_opp smallint,
  pass_int_opp smallint,
  pass_td_opp smallint,
  pass_sacked_opp smallint,
  pass_sacked_yds_opp smallint,
  rush_att_opp smallint,
  rush_yds_opp smallint,
  rush_td_opp smallint,
  CONSTRAINT teamstats_defense_yearly_pkey PRIMARY KEY (teamstats_defense_yearly_id),
  CONSTRAINT teamstats_defense_yearly_season_year_source_source_team_cod_key UNIQUE (season_year, source, source_team_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.teamstats_defense_yearly
  OWNER TO nfldb;
