-- extra_dfs_draft_prior.sql
-- puts DRAFT.com data dump on prior seasons into tables
-- https://blog.draft.com/2018/03/12/attention-nerds-prior-raw-best-ball-data/

-- Only 4 positions allowed in DRAFT.com drafts
DROP TYPE IF EXISTS extra_dfs_draft_prior.drpos;
CREATE TYPE extra_dfs_draft_prior.drpos AS ENUM
   ('QB',
    'RB',
    'WR',
    'TE');  
ALTER TYPE extra_dfs_draft_prior.drpos
  OWNER TO nfldb;

-- Only 2 types allowed in DRAFT.com drafts
DROP TYPE IF EXISTS extra_dfs_draft_prior.drtimer;
CREATE TYPE extra_dfs_draft_prior.drtimer AS ENUM
   ('Slow',
    'Fast');  
ALTER TYPE extra_dfs_draft_prior.drtimer
  OWNER TO nfldb;


-- Table: extra_dfs_draft_prior.league
-- All of the leagues on DRAFT.com
-- DROP TABLE extra_dfs_draft_prior.league;

CREATE TABLE extra_dfs_draft_prior.league
(
  draft_id char(36),
  participants smallint NOT NULL,
  draft_tm timestamp without time zone NOT NULL,
  entry_cost smallint NOT NULL,
  draft_timer extra_dfs_draft_prior.drtimer NOT NULL,
  complete_true_false boolean NOT NULL,
  CONSTRAINT league_draft_id_pk PRIMARY KEY (draft_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs_draft_prior.league
  OWNER TO nfldb;

-- Table: extra_dfs_draft_prior.player
-- All of the players in the DRAFT.com player pool
-- DROP TABLE extra_dfs_draft_prior.player;

CREATE TABLE extra_dfs_draft_prior.player
(
  player_id int NOT NULL,
  first_name text,
  last_name text,
  "position" extra_dfs_draft_prior.drpos,
  team char(3),
  team_name text,
  CONSTRAINT player_player_id_pk PRIMARY KEY (player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs_draft_prior.player
  OWNER TO nfldb;

  
-- Table: extra_dfs_draft_prior.draft
-- Results from all of the bestball drafts on DRAFT.com
-- DROP TABLE extra_dfs_draft_prior.draft;

CREATE TABLE extra_dfs_draft_prior.draft
(
  draft_id character(36) references extra_dfs_draft_prior.league (draft_id),
  team_id character(36) NOT NULL,
  player_id integer references extra_dfs_draft_prior.player (player_id),
  pick_day date NOT NULL,
  round_number smallint NOT NULL,
  pick_number integer NOT NULL,
  CONSTRAINT draft_id_player_id UNIQUE (draft_id, player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs_draft_prior.draft
  OWNER TO nfldb;

-- Table: extra_dfs_draft_prior.player_scoring
-- Weekly results for all players using DRAFT.com scoring
-- DROP TABLE extra_dfs_draft_prior.player_scoring;
CREATE TABLE extra_dfs_draft_prior.player_scoring
(
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  player_id integer references extra_dfs_draft_prior.player (player_id),
  points numeric(4,2),
  CONSTRAINT results_pkey PRIMARY KEY (season_year, week, player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs_draft_prior.player_scoring
  OWNER TO nfldb;


-- Table: extra_dfs_draft_prior.team_scoring
-- Weekly results for all players using DRAFT.com scoring
-- DROP TABLE extra_dfs_draft_prior.team_scoring;

CREATE TABLE extra_dfs_draft_prior.team_scoring
(
  draft_id character(36) NOT NULL,
  team_id character(36) NOT NULL,
  points numeric(6,2) NOT NULL,
  rk smallint,
  CONSTRAINT team_scoring_draft_id_fkey FOREIGN KEY (draft_id)
      REFERENCES extra_dfs_draft_prior.league (draft_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT team_scoring_draft_id_team_id_key UNIQUE (draft_id, team_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs_draft_prior.team_scoring
  OWNER TO nfldb;

-- Index: extra_dfs_draft_prior.team_scoring_draft_id_rk_idx

-- DROP INDEX extra_dfs_draft_prior.team_scoring_draft_id_rk_idx;

CREATE INDEX team_scoring_draft_id_rk_idx
  ON extra_dfs_draft_prior.team_scoring
  USING btree
  (draft_id COLLATE pg_catalog."default", rk);

-- Index: extra_dfs_draft_prior.team_scoring_points_rk_idx

-- DROP INDEX extra_dfs_draft_prior.team_scoring_points_rk_idx;

CREATE INDEX team_scoring_points_rk_idx
  ON extra_dfs_draft_prior.team_scoring
  USING btree
  (points, rk);
  
