-- Table: extra_misc.draft
-- the real NFL draft


-- DROP TABLE extra_misc.draft;

CREATE TABLE extra_misc.draft
(
  draft_id serial NOT NULL,
  nflcom_player_id character(10),
  source character varying(50) NOT NULL,
  source_player_id character varying,
  source_player_name character varying(100) NOT NULL,
  source_team_code character varying(3) NOT NULL,
  draft_year smallint NOT NULL,
  draft_round smallint NOT NULL,
  draft_overall_pick smallint NOT NULL,
  CONSTRAINT draft_pkey PRIMARY KEY (draft_id),
  CONSTRAINT uq_source_player_id UNIQUE (source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_misc.draft
  OWNER TO nfldb;
