-- drbb_database_schema.sql

-- TYPES

CREATE TYPE drbb.drposition AS ENUM
   ('QB',
    'RB',
    'FB',
    'WR',
    'TE');


-- TABLES

-- drbb.player

CREATE TABLE drbb.player
(
  player_id integer NOT NULL,
  first_name character varying(20) NOT NULL,
  last_name character varying(30) NOT NULL,
  "position" drbb.drposition,
  plyr character varying(50),
  CONSTRAINT player_pkey PRIMARY KEY (player_id)
)

CREATE TRIGGER player_plyr
  BEFORE INSERT OR UPDATE
  ON drbb.player
  FOR EACH ROW
  EXECUTE PROCEDURE drbb.plyr();
  
CREATE OR REPLACE FUNCTION drbb.plyr()
  RETURNS trigger AS
$BODY$
    BEGIN
	NEW.plyr = NEW.first_name || ' ' || NEW.last_name;
	RETURN NEW;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-- drbb.player_team

CREATE TABLE drbb.player_team
(
  player_team_id serial NOT NULL,
  player_id integer,
  season_year smallint,
  as_of date NOT NULL,
  team character varying(3) NOT NULL,
  team_name character varying(30),
  CONSTRAINT player_team_pkey PRIMARY KEY (player_team_id),
  CONSTRAINT player_team_player_id_fkey FOREIGN KEY (player_id)
      REFERENCES drbb.player (player_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT asof_pid UNIQUE (as_of, player_id)
)

-- drbb.player_pool

CREATE TABLE drbb.player_pool
(
  dbbppid serial NOT NULL,
  player_pool_id integer NOT NULL,
  pool_date date NOT NULL,
  player_id integer,
  booking_id integer NOT NULL,
  adp numeric(4,1) DEFAULT 0.0,
  projected_points numeric(5,1) DEFAULT 0.0,
  CONSTRAINT player_pool_pkey PRIMARY KEY (dbbppid),
  CONSTRAINT player_pool_player_id_fkey FOREIGN KEY (player_id)
      REFERENCES drbb.player (player_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT player_pool_player_pool_id_pool_date_booking_id_key UNIQUE (player_pool_id, pool_date, booking_id),
  CONSTRAINT player_pool_player_pool_id_pool_date_player_id_key UNIQUE (player_pool_id, pool_date, player_id)
)

-- drbb.adp

CREATE TABLE drbb.adp
(
  adp_id serial NOT NULL,
  sportradar_id character(36) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  participants smallint NOT NULL,
  entry_cost smallint NOT NULL,
  plyr character varying NOT NULL,
  team character varying,
  "position" character varying NOT NULL,
  adp numeric NOT NULL,
  min_pick smallint,
  max_pick smallint,
  CONSTRAINT adp_pkey PRIMARY KEY (adp_id),
  CONSTRAINT adp_sportradar_id_start_date_end_date_key UNIQUE (sportradar_id, start_date, end_date)
)

-- drbb.user

CREATE TABLE drbb."user"
(
  user_id character(36) NOT NULL,
  username character varying(50),
  user_experienced boolean,
  user_skill_level smallint,
  CONSTRAINT user_pkey PRIMARY KEY (user_id)
)

-- drbb.league

CREATE TABLE drbb.league
(
  league_id character(36) NOT NULL,
  season_year smallint,
  draft_time timestamp with time zone NOT NULL,
  participants smallint NOT NULL,
  entry_cost smallint NOT NULL,
  prize numeric(5,2),
  league_json jsonb,
  player_pool_id integer,
  CONSTRAINT league_pkey PRIMARY KEY (league_id)
)

-- drbb.league_user

CREATE TABLE drbb.league_user
(
  league_user_id serial NOT NULL,
  user_id character(36),
  league_id character(36),
  pick_order smallint NOT NULL,
  CONSTRAINT league_user_pkey PRIMARY KEY (league_user_id),
  CONSTRAINT league_user_league_id_fkey FOREIGN KEY (league_id)
      REFERENCES drbb.league (league_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT league_user_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES drbb."user" (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT league_user_user_id_league_id_key UNIQUE (user_id, league_id)
)

-- drbb.draft

CREATE TABLE drbb.draft (
  draft_league_id serial NOT NULL,
  league_id character(36),
  user_id character(36),
  player_id integer,
  pick_number smallint NOT NULL,
  slot_id smallint,
  CONSTRAINT draft_pkey PRIMARY KEY (draft_league_id),
  CONSTRAINT draft_league_id_fkey FOREIGN KEY (league_id)
      REFERENCES drbb.league (league_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT draft_player_id_fkey FOREIGN KEY (player_id)
      REFERENCES drbb.player (player_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT draft_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES drbb."user" (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT draft_league_id_pick_number_key UNIQUE (league_id, pick_number),
  CONSTRAINT draft_league_id_player_id_key UNIQUE (league_id, player_id)
)

-- drbb.player_scoring

CREATE TABLE drbb.player_scoring
(
  player_id integer NOT NULL,
  season_year smallint NOT NULL,
  week smallint NOT NULL,
  points numeric(4,2),
  CONSTRAINT player_scoring_pkey PRIMARY KEY (player_id, season_year, week),
  CONSTRAINT player_scoring_player_id_fkey FOREIGN KEY (player_id)
      REFERENCES drbb.player (player_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- drbb.team_scoring

CREATE TABLE drbb.team_scoring
(
  team_scoring_id serial primary key,
  league_id character(36),
  user_id character(36) NOT NULL,
  points numeric(6,2) NOT NULL,
  rk smallint,
  CONSTRAINT team_scoring_league_id_fkey FOREIGN KEY (league_id)
      REFERENCES drbb.league (league_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT team_scoring_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES drbb."user" (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT team_scoring_league_id_user_id_key UNIQUE (league_id, user_id)
)

-- drbb.draft_round

CREATE TABLE drbb.draft_round
(
  rounds_id serial primary key,
  participants smallint NOT NULL,
  pick smallint NOT NULL,
  rnd smallint NOT NULL,
  pick_order smallint,
  CONSTRAINT uq_part_pk UNIQUE (participants, pick)
)

-- FUNCTIONS

-- drbb.fn_adp

DROP FUNCTION drbb.fn_adp(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_adp(IN lids character[])
  RETURNS TABLE(player_id integer, plyr character varying, pos drbb.drposition, ndraft smallint, npk smallint, adp numeric, mdp smallint, pct75 smallint, pct25 smallint, lowpk smallint, highpk smallint) AS
$BODY$

WITH ld AS (
  SELECT * FROM drbb.fn_league_drafts(lids)
)

SELECT
    ld.player_id, p.plyr, p."position" as pos,
    (SELECT COUNT (DISTINCT league_id) FROM ld)::smallint AS ndraft,
    count(ld.player_id)::smallint as npk,
    round(avg(ld.pick_number)::numeric, 1) as adp,
    percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (ld.pick_number::double precision))::smallint AS mdp,   
    percentile_cont(0.2::double precision) WITHIN GROUP (ORDER BY (ld.pick_number::double precision))::smallint AS pct75,
    percentile_cont(0.4::double precision) WITHIN GROUP (ORDER BY (ld.pick_number::double precision))::smallint AS pct25,
    max(ld.pick_number) as lowpk,
    min(ld.pick_number) as highpk
  FROM ld
  LEFT JOIN drbb.player AS p ON ld.player_id = p.player_id
  GROUP BY ld.player_id, p.plyr, p."position"

$BODY$
  LANGUAGE sql;


-- Function: drbb.fn_draft_next_picked(character[])

-- DROP FUNCTION drbb.fn_draft_next_picked(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_draft_next_picked(IN lids character[])
  RETURNS TABLE(league_id character, pick_number smallint, pos drbb.drposition, next_qb smallint, next_rb smallint, next_te smallint, next_wr smallint) AS
$BODY$
DECLARE
    lid CHAR(36);
BEGIN
   FOREACH lid IN ARRAY lids
   LOOP
    RETURN QUERY 
	WITH d AS (
	  SELECT
	    dp.league_id, dp.pick_number, dp.pos,
	    ROW_NUMBER() OVER (PARTITION BY dp.pos ORDER BY dp.pick_number)::smallint as posrk,
	    CASE WHEN dp.tqb IS NULL THEN 0 ELSE tqb END as tqb,
	    CASE WHEN dp.trb IS NULL THEN 0 ELSE trb END as trb,
	    CASE WHEN dp.tte IS NULL THEN 0 ELSE tte END as tte,
	    CASE WHEN dp.twr IS NULL THEN 0 ELSE twr END as twr
	  FROM (SELECT * FROM drbb.fn_draft_positions (lid)) as dp
	),

	np AS (
	  SELECT 
	    d.*,
	    (SELECT d2.pick_number
	      FROM d AS d2
	      WHERE d2.pos::text = 'QB'::text AND d2.posrk = d.tqb + 1) AS next_qb,
	    (SELECT d2.pick_number
	      FROM d AS d2
	      WHERE d2.pos::text = 'RB'::text AND d2.posrk = d.trb + 1) AS next_rb,
	    (SELECT d2.pick_number
	      FROM d AS d2
	      WHERE d2.pos::text = 'TE'::text AND d2.posrk = d.tte + 1) AS next_te,
	    (SELECT d2.pick_number
	      FROM d AS d2
	      WHERE d2.pos::text = 'WR'::text AND d2.posrk = d.twr + 1) AS next_wr    
	  FROM d
	)

	SELECT
	  np.league_id, np.pick_number, np.pos, np.next_qb, np.next_rb, np.next_te, np.next_wr
	FROM np
	ORDER BY pick_number;
   END LOOP;
   RETURN;
END $BODY$
  LANGUAGE plpgsql;


-- Function: drbb.fn_draft_positions(character[])

-- DROP FUNCTION drbb.fn_draft_positions(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_draft_positions(IN lids character[])
  RETURNS TABLE(league_id character, participants smallint, user_id character, player_id integer, pos drbb.drposition, pick_number smallint, nqb smallint, nrb smallint, nte smallint, nwr smallint, tqb smallint, trb smallint, tte smallint, twr smallint) AS
$BODY$
DECLARE
    lid CHAR(36);
BEGIN
   FOREACH lid IN ARRAY lids
   LOOP
    RETURN QUERY 
	WITH d AS (
	 SELECT dr.league_id,
	    l.participants,
	    dr.user_id,
	    dr.player_id,
	    p."position" AS pos,
	    dr.pick_number
	   FROM drbb.draft dr
	     LEFT JOIN drbb.player p ON dr.player_id = p.player_id
	     LEFT JOIN drbb.league l ON l.league_id = lid
	  WHERE dr.league_id = lid
	)

	SELECT d.league_id,
	d.participants,
	d.user_id,
	d.player_id,
	d.pos,
	d.pick_number,
	COALESCE(sum(CASE WHEN d.pos = 'QB'::drbb.drposition THEN 1 ELSE 0 END) 
	    OVER (PARTITION BY d.league_id, d.user_id ORDER BY d.pick_number 
	    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS nqb,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'RB'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id, d.user_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS nrb,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'TE'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id, d.user_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS nte,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'WR'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id, d.user_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS nwr,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'QB'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS tqb,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'RB'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS trb,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'TE'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS tte,
	COALESCE(sum(
	CASE
	    WHEN d.pos = 'WR'::drbb.drposition THEN 1
	    ELSE 0
	END) OVER (PARTITION BY d.league_id ORDER BY d.pick_number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)::smallint AS twr
	FROM d;

   END LOOP;
   RETURN;
END $BODY$
  LANGUAGE plpgsql;


-- Function: drbb.fn_league_drafts(character[])

-- DROP FUNCTION drbb.fn_league_drafts(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_league_drafts(lids character[])
  RETURNS SETOF drbb.draft AS
$BODY$
  SELECT * FROM drbb.draft
  WHERE league_id = any(lids)
  ORDER by league_id, pick_number
$BODY$
  LANGUAGE sql;
  
  
-- Function: drbb.fn_league_summary(character[])

-- DROP FUNCTION drbb.fn_league_summary(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_league_summary(IN lids character[])
  RETURNS TABLE(league_id character, participants smallint, draft_time timestamp with time zone, user_id character, username character varying, skill smallint, slot smallint, qb smallint, rb smallint, wr smallint, te smallint) AS
$BODY$
DECLARE
    lid CHAR(36);
BEGIN
   FOREACH lid IN ARRAY lids
   LOOP
    RETURN QUERY 
        WITH ct AS (
            SELECT * FROM crosstab (CONCAT($$
            WITH t AS (
            select 
              d.user_id, d.pick_number, d.player_id, p.plyr, p."position" as pos
            from drbb.draft AS d
            left join drbb.player AS p ON d.player_id = p.player_id
            where league_id IN (SELECT league_id FROM drbb.league WHERE league_id = '$$, lid, $$')
            )

            SELECT 
              user_id, pos, count(pos)::smallint as n FROM t 
            GROUP BY user_id, pos ORDER BY 1,2
            $$)) 

            AS (user_id char(36), "QB" smallint, "RB" smallint, "WR" smallint, "TE" smallint)
        ),

        lu AS (
             SELECT u_1.username, u_1.user_skill_level, lu_1.* 
             FROM drbb.league_user AS lu_1
             LEFT JOIN drbb.user AS u_1 ON lu_1.user_id = u_1.user_id
             WHERE lu_1.league_id = lid
        )

        select 
          lid as league_id, 
          l.participants, 
          l.draft_time, 
          ct.user_id,
          lu.username,
          lu.user_skill_level as skill,
          lu.pick_order as slot,
          ct."QB", ct."RB", ct."WR", ct."TE"
        from ct
        left join drbb.league AS l ON lid = l.league_id
        LEFT JOIN lu ON ct.user_id = lu.user_id
        ORDER BY lu.pick_order;
   END LOOP;
END $BODY$
  LANGUAGE plpgsql;


-- Function: drbb.fn_player_scoring_pivot()

-- DROP FUNCTION drbb.fn_player_scoring_pivot();

CREATE OR REPLACE FUNCTION drbb.fn_player_scoring_pivot()
  RETURNS TABLE(season_year smallint, player_id integer, plyr character varying, pos drbb.drposition, team character varying, w1 numeric, w2 numeric, w3 numeric, w4 numeric, w5 numeric, w6 numeric, w7 numeric, w8 numeric, w9 numeric, w10 numeric, w11 numeric, w12 numeric, w13 numeric, w14 numeric, w15 numeric, w16 numeric, tot numeric) AS
$BODY$
DECLARE
  s smallint;
  seasons smallint[] := array[2017, 2018];
BEGIN
FOREACH s IN ARRAY seasons
  LOOP
    RETURN QUERY 
      WITH t1 AS (
	 SELECT 
	    final_result.player_id, 
	    COALESCE(final_result.w1, 0::numeric) AS w1,
	    COALESCE(final_result.w2, 0::numeric) AS w2,
	    COALESCE(final_result.w3, 0::numeric) AS w3,
	    COALESCE(final_result.w4, 0::numeric) AS w4,
	    COALESCE(final_result.w5, 0::numeric) AS w5,
	    COALESCE(final_result.w6, 0::numeric) AS w6,
	    COALESCE(final_result.w7, 0::numeric) AS w7,
	    COALESCE(final_result.w8, 0::numeric) AS w8,
	    COALESCE(final_result.w9, 0::numeric) AS w9,
	    COALESCE(final_result.w10, 0::numeric) AS w10,
	    COALESCE(final_result.w11, 0::numeric) AS w11,
	    COALESCE(final_result.w12, 0::numeric) AS w12,
	    COALESCE(final_result.w13, 0::numeric) AS w13,
	    COALESCE(final_result.w14, 0::numeric) AS w14,
	    COALESCE(final_result.w15, 0::numeric) AS w15,
	    COALESCE(final_result.w16, 0::numeric) AS w16
	   FROM crosstab(
	   CONCAT('SELECT player_id, week, points::numeric
		   FROM drbb.player_scoring 
		   WHERE season_year = ', s, ' ORDER BY 1')::text, 
	   'SELECT w FROM generate_series(1,16) w'::text) 
	   final_result(
	     player_id int, 
	     w1 numeric, w2 numeric, w3 numeric, w4 numeric, w5 numeric, 
	     w6 numeric, w7 numeric, w8 numeric, w9 numeric, w10 numeric, 
	     w11 numeric, w12 numeric, w13 numeric, w14 numeric, w15 numeric, w16 numeric)
       ),

       t2 AS (
         SELECT * FROM drbb.fn_player_team_season(s)
       )
       
       SELECT s AS season_year, t1.player_id, t2.plyr, t2.pos, t2.team,
       t1.w1, t1.w2, t1.w3, t1.w4, t1.w5, t1.w6, t1.w7, t1.w8, t1.w9, t1.w10, t1.w11,
       t1.w12, t1.w13, t1.w14, t1.w15, t1.w16, 
       (t1.w1 + t1.w2 + t1.w3 + t1.w4 + t1.w5 + t1.w6 + t1.w7 + 
        t1.w8 + t1.w9 + t1.w10 + t1.w11 + t1.w12 + t1.w13 + 
        t1.w14 + t1.w15 + t1.w16 ) as tot
       FROM t1 JOIN t2 on t1.player_id = t2.player_id;
    END LOOP;
  RETURN;
END $BODY$
  LANGUAGE plpgsql;


-- Function: drbb.fn_player_team_season(integer)

-- DROP FUNCTION drbb.fn_player_team_season(integer);

CREATE OR REPLACE FUNCTION drbb.fn_player_team_season(IN season integer)
  RETURNS TABLE(season_year smallint, as_of date, player_id integer, plyr character varying, pos drbb.drposition, team character varying) AS
$BODY$
 WITH pt AS (
         SELECT season_year, player_id, team,
            max(as_of) AS as_of
           FROM drbb.player_team
           GROUP BY season_year, player_id, team
           HAVING season_year = season::smallint
        )
 SELECT 
    pt.season_year,
    pt.as_of,
    pt.player_id,
    p.plyr,
    p."position" as pos,
    pt.team
   FROM pt
     LEFT JOIN drbb.player p ON pt.player_id = p.player_id
  ORDER BY pt.player_id; 
$BODY$
  LANGUAGE sql;


-- Function: drbb.fn_pos_by_round(integer, character[])

-- DROP FUNCTION drbb.fn_pos_by_round(integer, character[]);

CREATE OR REPLACE FUNCTION drbb.fn_pos_by_round(
    IN participants integer,
    IN lids character[])
  RETURNS TABLE(rnd smallint, pos character varying, avg_drafted numeric, cum_drafted numeric) AS
$BODY$

--step one: get leagues
WITH d AS (
  SELECT * FROM drbb.draft
  WHERE league_id = any(lids)
),

r AS (
 SELECT
    draft_round.participants,
    draft_round.pick,
    draft_round.rnd
   FROM drbb.draft_round
  WHERE draft_round.participants = $1
), 

t1 AS (
 SELECT 
    d.league_id,
    d.pick_number,
    p."position" as pos,
    r.rnd
   FROM d
     LEFT JOIN r ON d.pick_number = r.pick
     LEFT JOIN drbb.player p ON d.player_id = p.player_id
), 

t2 AS (
 SELECT t1.league_id,
    t1.rnd,
    t1.pos,
    count(t1.pos) AS npos
   FROM t1
  GROUP BY t1.league_id, t1.rnd, t1.pos
), 

t3 AS (
 SELECT t2.rnd,
    t2.pos,
    round(avg(t2.npos), 1) AS avg_drafted
   FROM t2
  GROUP BY t2.rnd, t2.pos
  ORDER BY t2.rnd, t2.pos
)

 SELECT t3.rnd::smallint,
    t3.pos::varchar,
    t3.avg_drafted,
    sum(t3.avg_drafted) OVER (PARTITION BY t3.pos ORDER BY t3.rnd) AS cum_drafted
   FROM t3
  ORDER BY t3.rnd, t3.pos
  $BODY$
  LANGUAGE sql;


-- Function: drbb.fn_rand_leagues(integer, integer, integer)

-- DROP FUNCTION drbb.fn_rand_leagues(integer, integer, integer);

CREATE OR REPLACE FUNCTION drbb.fn_rand_leagues(
    y integer,
    p integer DEFAULT 12,
    n integer DEFAULT NULL::integer)
  RETURNS character[] AS
$BODY$
  SELECT ARRAY((SELECT league_id FROM drbb.league
  WHERE season_year = $1 AND participants = $2
  ORDER BY RANDOM()
  LIMIT $3))
$BODY$
  LANGUAGE sql;
  
  
-- Function: drbb.fn_roster_construction(character[])

-- DROP FUNCTION drbb.fn_roster_construction(character[]);

CREATE OR REPLACE FUNCTION drbb.fn_roster_construction(IN lids character[])
  RETURNS TABLE(pos character varying, pct10 smallint, pct20 smallint, pct30 smallint, pct40 smallint, pct50 smallint, pct60 smallint, pct70 smallint, pct80 smallint, pct90 smallint) AS
$BODY$

WITH d1 AS (
 SELECT 
   d.league_id,
   d.user_id,
   (CASE WHEN p."position" = 'FB'::drbb.drposition THEN 'RB'::drbb.drposition ELSE p."position" END)::varchar AS pos
   FROM drbb.draft d
     LEFT JOIN drbb.player p ON d.player_id = p.player_id
  WHERE league_id = ANY (lids)
), 

d2 AS (
  SELECT d1.league_id,
         d1.user_id,
         d1.pos,
         count(d1.pos) AS npos
  FROM d1
  GROUP BY league_id, user_id, pos
)

 SELECT 
    d2.pos::varchar,
    percentile_cont(0.1::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct10,
    percentile_cont(0.2::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct20,
    percentile_cont(0.3::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct30,
    percentile_cont(0.4::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct40,
    percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct50,
    percentile_cont(0.6::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct60,
    percentile_cont(0.7::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct70,
    percentile_cont(0.8::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct80,
    percentile_cont(0.9::double precision) WITHIN GROUP (ORDER BY (d2.npos::double precision))::smallint AS pct90
   FROM d2
   GROUP BY d2.pos
 
$BODY$
  LANGUAGE sql;


-- Function: drbb.fn_worp(integer, integer, integer)

-- DROP FUNCTION drbb.fn_worp(integer, integer, integer);

CREATE OR REPLACE FUNCTION drbb.fn_worp(
    IN participants integer,
    IN seas integer,
    IN entry integer)
  RETURNS TABLE(player_id integer, plyr character varying, pos character varying, n smallint, ntot smallint, adp numeric, worp numeric, posrk_adp smallint, posrk_worp smallint) AS
$BODY$

WITH l AS (
  SELECT league_id
  FROM drbb.league
  WHERE 
    participants = $1 AND 
    season_year = $2 AND 
    entry_cost <= $3 
),

adp AS (
  SELECT player_id, ROUND(avg(pick_number)::numeric,1) as adp
  FROM drbb.draft
  WHERE league_id IN (SELECT league_id FROM l)
  GROUP BY player_id
),

ts AS (
  SELECT league_id, user_id
  FROM 
    drbb.team_scoring  
  WHERE 
    league_id IN (SELECT league_id FROM l) AND
    rk = 1
),

d AS (
  SELECT ts.league_id, ts.user_id, d_1.player_id, d_1.pick_number
  FROM drbb.draft AS d_1
  INNER JOIN ts ON d_1.league_id = ts.league_id AND d_1.user_id = ts.user_id
),

res AS (
SELECT 
  d.league_id, d.user_id, d.player_id, 
  p.plyr, p."position"::char(2) as pos, d.pick_number as pk,
  ceil(pick_number/3.0) as rnd
FROM d
LEFT JOIN drbb.player AS p ON d.player_id = p.player_id
ORDER BY league_id, pick_number
),

agg AS (
select player_id, plyr, pos::varchar, count(player_id)::smallint as n
from res
group by player_id, plyr, pos
order by count(player_id) DESC
),

wrp AS (
SELECT 
  agg.player_id, agg.plyr, agg.pos, agg.n,
  sq.ntot::smallint, adp.adp, round((n/sq.ntot::numeric) - 1/$1::numeric, 2) as worp
from agg left join adp ON agg.player_id = adp.player_id,
(select count(*) as ntot from l) as sq
order by adp
)

select wrp.player_id, wrp.plyr, wrp.pos, wrp.n, wrp.ntot, wrp.adp, wrp.worp,
row_number() OVER (partition by pos ORDER BY adp)::smallint as posrk_adp,
row_number() OVER (partition by pos ORDER BY worp DESC)::smallint as posrk_worp
from wrp
order by pos, row_number() OVER (partition by pos ORDER BY worp DESC)
$BODY$
  LANGUAGE sql;


-- VIEWS


-- Materialized View: drbb.mvw_league_results

-- DROP MATERIALIZED VIEW drbb.mvw_league_results;

CREATE MATERIALIZED VIEW drbb.mvw_league_results AS 
 SELECT ts.league_id,
    ts.user_id,
    ts.points,
    ts.rk,
    l.participants,
    l.entry_cost,
    l.draft_time,
    lu.pick_order
   FROM drbb.team_scoring ts
     LEFT JOIN drbb.league l ON ts.league_id = l.league_id
     LEFT JOIN drbb.league_user lu ON ts.league_id = lu.league_id AND ts.user_id = lu.user_id
WITH DATA;


-- View: drbb.vw_draft_espn_xref

-- DROP VIEW drbb.vw_draft_espn_xref;

CREATE OR REPLACE VIEW drbb.vw_draft_espn_xref AS 
 WITH d AS (
         SELECT player_xref.player_xref_id,
            player_xref.player_id,
            player_xref.source,
            player_xref.source_player_id,
            player_xref.source_player_code,
            player_xref.source_player_name,
            player_xref.source_player_position
           FROM base.player_xref
          WHERE player_xref.source = 'draft'::text
        ), e AS (
         SELECT player_xref.player_xref_id,
            player_xref.player_id,
            player_xref.source,
            player_xref.source_player_id,
            player_xref.source_player_code,
            player_xref.source_player_name,
            player_xref.source_player_position
           FROM base.player_xref
          WHERE player_xref.source = 'espn'::text
        )
 SELECT d.player_id,
    d.source_player_name AS plyr,
    d.source_player_position AS pos,
    d.source_player_id AS draft_id,
    e.source_player_id AS espn_id
   FROM d
     LEFT JOIN e ON d.player_id = e.player_id;


-- View: drbb.vw_player_pool

-- DROP VIEW drbb.vw_player_pool;

CREATE OR REPLACE VIEW drbb.vw_player_pool AS 

WITH p AS (
  SELECT player_id, plyr, "position" as pos
  FROM drbb.player
),

t AS (
  SELECT t_1.player_id, t_1.team
  FROM (
    SELECT 
      player_id, team,
      row_number() OVER (PARTITION BY player_id ORDER BY as_of DESC) AS nteam
    FROM 
      drbb.player_team AS pt) as t_1
  WHERE t_1.nteam = 1
),

pp AS (
  SELECT  
    pool_date, player_id, CASE WHEN adp > 0 THEN adp ELSE 216 END AS adp, projected_points
  FROM drbb.player_pool
  WHERE pool_date = (SELECT max(pool_date) FROM drbb.player_pool)
),

r AS (
  select
    pp.pool_date, 
    p.plyr, p.pos, t.team,
    pp.adp, 
    row_number() OVER (PARTITION BY p.pos ORDER BY adp) as posrk_adp,
    pp.projected_points,
    row_number() OVER (PARTITION BY p.pos ORDER BY projected_points DESC) as posrk_proj
  from pp
  left join p ON pp.player_id = p.player_id
  left join t ON pp.player_id = t.player_id
)

select
  pool_date, plyr, pos, team, adp, 
  posrk_adp::smallint, projected_points as proj, 
  posrk_proj::smallint, (posrk_adp - posrk_proj)::smallint AS posrk_d 
from r



-- View: drbb.vw_player_team

-- DROP VIEW drbb.vw_player_team;

CREATE OR REPLACE VIEW drbb.vw_player_team AS 
 WITH pt AS (
         SELECT player_team.player_id,
            player_team.team,
            max(player_team.as_of) AS as_of
           FROM drbb.player_team
          GROUP BY player_team.player_id, player_team.team
        )
 SELECT pt.as_of,
    pt.player_id,
    p.first_name,
    p.last_name,
    p."position",
    pt.team
   FROM pt
     LEFT JOIN drbb.player p ON pt.player_id = p.player_id
  ORDER BY pt.player_id;


-- View: drbb.vw_xref_dr_sr

-- DROP VIEW drbb.vw_xref_dr_sr;

CREATE OR REPLACE VIEW drbb.vw_xref_dr_sr AS 
 WITH sr AS (
         SELECT player_xref.player_xref_id,
            player_xref.player_id,
            player_xref.source,
            player_xref.source_player_id,
            player_xref.source_player_code,
            player_xref.source_player_name,
            player_xref.source_player_position
           FROM base.player_xref
          WHERE player_xref.source = 'sportradar'::text
        ), dr AS (
         SELECT player_xref.player_xref_id,
            player_xref.player_id,
            player_xref.source,
            player_xref.source_player_id,
            player_xref.source_player_code,
            player_xref.source_player_name,
            player_xref.source_player_position
           FROM base.player_xref
          WHERE player_xref.source = 'draft'::text
        )
 SELECT sr.player_id,
    sr.source_player_name AS plyr,
    sr.source_player_position AS pos,
    sr.source_player_id AS sr_id,
    dr.source_player_id AS dr_id
   FROM sr
     LEFT JOIN dr ON sr.player_id = dr.player_id
  ORDER BY sr.source_player_id;
