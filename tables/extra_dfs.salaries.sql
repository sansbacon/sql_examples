-- Table: extra_dfs.salaries
-- Stores DFS salaries
-- TODO: need 2017

-- DROP TABLE extra_dfs.salaries;

CREATE TABLE extra_dfs.salaries
(
  salaries_id serial NOT NULL,
  season_year smallint,
  week smallint,
  nflcom_player_id character varying(10),
  team character varying(10),
  source character varying(50),
  source_player_id character varying(50),
  source_player_name character varying(50),
  dfs_site character varying(5),
  dfs_position character varying(5),
  salary smallint
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs.salaries
  OWNER TO nfldb;
