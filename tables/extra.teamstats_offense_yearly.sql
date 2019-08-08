-- Table: 

-- DROP TABLE extra.teamstats_offense_yearly;

CREATE TABLE extra.teamstats_offense_yearly
(
  teamstats_offense_yearly_id serial NOT NULL,
  season_year smallint NOT NULL,
  team character varying NOT NULL,
  pass_cmp smallint NOT NULL,
  pass_att smallint NOT NULL,
  pass_yds smallint NOT NULL,
  pass_int smallint NOT NULL,
  pass_td smallint NOT NULL,
  pass_sacked smallint NOT NULL,
  pass_sacked_yds smallint NOT NULL,
  exp_pts_pass numeric NOT NULL,
  rush_att smallint NOT NULL,
  rush_yds smallint NOT NULL,
  rush_td smallint NOT NULL,
  exp_pts_rush numeric NOT NULL,
  fumbles smallint NOT NULL,
  two_pt_md smallint NOT NULL,
  two_pt_att smallint NOT NULL,
  fga smallint NOT NULL,
  fgm smallint NOT NULL,
  drives smallint NOT NULL,
  play_count_tip smallint NOT NULL,
  score_pct numeric NOT NULL,
  turnover_pct numeric NOT NULL,
  start_avg numeric NOT NULL,
  time_avg numeric NOT NULL,
  points_avg numeric NOT NULL,
  CONSTRAINT teamstats_offense_yearly_pkey PRIMARY KEY (teamstats_offense_yearly_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.teamstats_offense_yearly
  OWNER TO nfldb;
