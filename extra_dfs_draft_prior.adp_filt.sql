-- extra_dfs_draft_prior.adp_filt
-- shows ADP for specific year and specific size draft

DROP FUNCTION IF EXISTS extra_dfs_draft_prior.adp_filt(int, int);

CREATE OR REPLACE FUNCTION extra_dfs_draft_prior.adp_filt(seas int, size int)
  RETURNS SETOF extra_dfs_draft_prior.adp AS
$BODY$
-- step one: get leagues of certain size
WITH t AS (
  SELECT draft_id
  FROM extra_dfs_draft_2017.league
  WHERE participants = size AND extract(year from draft_tm) = seas 
),

-- step two: get picks from leagues in t
t2 AS (
  SELECT *, extract(year from pick_day) as season_year
  FROM extra_dfs_draft_prior.draft
  WHERE draft_id IN (SELECT * FROM t)
),

-- step three: aggregates
t3 AS (
  SELECT
    season_year,
    player_id,
    round(avg(pick_number)::numeric, 1) as adp,
    max(pick_number) as lowpk,
    min(pick_number) as highpk
  FROM t2
  GROUP BY season_year, player_id
)

-- step four: join aggregates with player
SELECT
  p2.player_id,
  t3.season_year,
  p2.first_name,
  p2.last_name,
  p2."position",
  p2.team,
  t3.adp,
  t3.lowpk,
  t3.highpk
FROM
  extra_dfs_draft_prior.player as p2
INNER JOIN t3 ON p2.player_id = t3.player_id
ORDER BY t3.adp
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION extra_dfs_draft_2017.adp2017_n(integer)
  OWNER TO nfldb;
