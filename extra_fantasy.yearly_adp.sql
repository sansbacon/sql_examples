-- Table: extra_fantasy.yearly_adp

-- DROP TABLE extra_fantasy.yearly_adp;

CREATE TABLE extra_fantasy.yearly_adp
(
  adp_id integer NOT NULL DEFAULT nextval('extra_fantasy.adp_adp_id_seq'::regclass),
  created_at timestamp without time zone DEFAULT now(),
  season_year smallint DEFAULT 
CASE
    WHEN (date_part('month'::text, now()) > (2)::double precision) THEN date_part('year'::text, now())
    ELSE (date_part('year'::text, now()) - (1)::double precision)
END,
  nflcom_player_id character varying,
  source character varying NOT NULL,
  source_league_type character varying DEFAULT 'ppr'::character varying,
  source_player_id character varying NOT NULL,
  source_player_name character varying NOT NULL,
  source_team_code character varying NOT NULL,
  source_player_position character varying NOT NULL,
  adp numeric NOT NULL,
  position_rank smallint,
  source_player_code character varying(30),
  CONSTRAINT adp_pkey PRIMARY KEY (adp_id),
  CONSTRAINT adp_created_at_source_player_id_key UNIQUE (created_at, source_player_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra_fantasy.yearly_adp
  OWNER TO nfldb;
