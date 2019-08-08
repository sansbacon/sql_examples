-- dfs.fn_dksal_trends.sql
-- shows salary trend for player

-- select * from dfs.fn_dksal_trends(2018, 1, 14)

CREATE OR REPLACE FUNCTION dfs.fn_dksal_trends (
    IN season_year integer,
    IN week_start integer,
    IN week_end integer)
  RETURNS TABLE(
    seas smallint, week smallint, plyr character varying, pos character varying, 
    team character varying, opp character varying, is_home boolean,
    salary smallint, sal_d smallint, sal_d3 numeric, sal_max_d smallint, sal_min_d smallint, pctcap numeric) AS
$BODY$

WITH t AS (
  SELECT * FROM dfs.fn_dksal_with_opp_yearly($1, $2, $3)
),

t2 AS (
  SELECT
    seas, week, plyrid, plyr, pos, team, opp, is_home, 
    salary, 
    LAG(salary, 1) OVER (PARTITION BY plyrid ORDER BY seas, week) as sal_lw,
    ROUND(AVG(salary) OVER (PARTITION BY plyrid ORDER BY seas, week ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING), 0) as sal_avg3,
    MAX(salary) OVER (PARTITION BY plyrid) as sal_max,
    MIN(salary) OVER (PARTITION BY plyrid) as sal_min,   
    pctcap
  FROM t
)

SELECT
  seas, week, plyr, pos, team, opp, is_home, salary,
  salary - sal_lw AS sal_d, 
  salary - sal_avg3 AS sal_d3,
  salary - sal_max as sal_max_d,
  salary - sal_min as sal_min_d,
  pctcap
FROM t2
WHERE week = $3
ORDER BY array_position(array['QB'::varchar,'RB'::varchar,'WR'::varchar,'TE'::varchar,'DST'::varchar], t2.pos), t2.salary DESC

$BODY$
LANGUAGE SQL;
