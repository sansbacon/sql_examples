-- Table: extra_misc.team_xref
-- Different sites use different team codes
-- e.g. NOS vs. NO, NEP vs. NE, JAC vs. JAX
-- Provides cross-references from nfldb.team table

-- DROP TABLE extra_misc.team_xref;

CREATE TABLE extra_misc.team_xref
(
  team_xref_id serial NOT NULL,
  nflcom_team_id character(3) NOT NULL,
  source character varying(50) NOT NULL,
  source_team_id character varying(10) NOT NULL,
  source_team_name character varying(50) NOT NULL,
  source_team_city character varying(50) NOT NULL,
  CONSTRAINT team_xref_pkey PRIMARY KEY (team_xref_id),
  CONSTRAINT team_xref_nflcom_team_id_fkey FOREIGN KEY (nflcom_team_id)
      REFERENCES public.team (team_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT team_xref_nflcom_team_id_source_key UNIQUE (nflcom_team_id, source),
  CONSTRAINT team_xref_source_team_id_source_key UNIQUE (source_team_id, source)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_misc.team_xref
  OWNER TO nfldb;
