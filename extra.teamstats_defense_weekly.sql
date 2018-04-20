-- Table: extra.teamstats_defense_weekly
-- Stores weekly defensive stats, including:
-- passing yards allowed, passing tds allowed, 
-- sacks, qb_hits, etc. 

-- DROP TABLE extra.teamstats_defense_weekly;

CREATE TABLE extra.teamstats_defense_weekly
(
  teamstats_defense_weekly_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
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
  qb_hits smallint,
  tfl smallint,
  def_td smallint,
  return_td smallint,
  fum_rec smallint,
  safety smallint,
  CONSTRAINT teamstats_defense_weekly_pkey PRIMARY KEY (teamstats_defense_weekly_id),
  CONSTRAINT teamstats_defense_weekly_season_year_week_source_source_tea_key UNIQUE (season_year, week, source, source_team_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.teamstats_defense_weekly
  OWNER TO nfldb;
