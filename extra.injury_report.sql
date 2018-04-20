-- Table: extra.injury_report
-- This is for scraping NFL injury reports
-- TODO: this table is incomplete, not sure if have scraper

-- DROP TABLE extra.injury_report;

CREATE TABLE extra.injury_report
(
  injury_report_id serial NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  player_id character varying(10),
  esbid character varying(20),
  firstname character varying(50),
  lastname character varying(50),
  player character varying(50),
  team_code character varying(4),
  "position" character varying(10),
  injury character varying(255),
  practicestatus character varying(255),
  gamestatus character varying(255),
  CONSTRAINT injury_report_pkey PRIMARY KEY (injury_report_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE extra.injury_report
  OWNER TO nfldb;
