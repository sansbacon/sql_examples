-- Table: extra_misc.player_xref
-- Cross-reference site's player id or code to nfl.com player ID

-- DROP TABLE extra_misc.player_xref;

CREATE TABLE extra_misc.player_xref
(
  player_xref_id serial NOT NULL,
  nflcom_player_id character varying NOT NULL,
  source character varying(50) NOT NULL,
  source_player_id character varying(100) NOT NULL,
  source_player_name character varying(100) NOT NULL,
  source_player_position character varying(10),
  source_player_dob date,
  source_player_code character varying(100),
  CONSTRAINT player_xref_pkey PRIMARY KEY (player_xref_id),
  CONSTRAINT player_xref_nflcom_player_id_source_key UNIQUE (nflcom_player_id, source),
  CONSTRAINT player_xref_source_player_id_source_key UNIQUE (source_player_id, source)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_misc.player_xref
  OWNER TO nfldb;

-- Index: extra_misc.player_xref_nflcom_player_id_source_source_player_id_idx

-- DROP INDEX extra_misc.player_xref_nflcom_player_id_source_source_player_id_idx;

CREATE INDEX player_xref_nflcom_player_id_source_source_player_id_idx
  ON extra_misc.player_xref
  USING btree
  (nflcom_player_id COLLATE pg_catalog."default", source COLLATE pg_catalog."default", source_player_id COLLATE pg_catalog."default");

-- Index: extra_misc.player_xref_nflcom_player_id_source_source_player_name_idx

-- DROP INDEX extra_misc.player_xref_nflcom_player_id_source_source_player_name_idx;

CREATE INDEX player_xref_nflcom_player_id_source_source_player_name_idx
  ON extra_misc.player_xref
  USING btree
  (nflcom_player_id COLLATE pg_catalog."default", source COLLATE pg_catalog."default", source_player_name COLLATE pg_catalog."default");

