-- Table: extra_dfs.fl_models
-- stores fantasylabs models, including JSON
-- TODO: needs 2017

-- DROP TABLE extra_dfs.fl_models;

CREATE TABLE extra_dfs.fl_models
(
  fl_models_id serial NOT NULL,
  ts timestamp with time zone,
  modelname character varying(25),
  modeldate character varying(10),
  season_year smallint,
  week smallint,
  model text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_dfs.fl_models
  OWNER TO nfldb;
