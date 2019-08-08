-- dfs.fn_dksal_showdown_sws.sql
-- SELECT * FROM dfs.fn_dksal_showdown_sws(2018, 14, 'tsd')


DROP FUNCTION IF EXISTS dfs.fn_dksal_showdown_sws(integer, integer, character varying);

CREATE OR REPLACE FUNCTION dfs.fn_dksal_showdown_sws(
    IN season_year integer,
    IN week integer,
    IN dfs_slate character varying DEFAULT 'main'::character varying)
  RETURNS TABLE(season_year smallint, week smallint, dfs_site character varying, dfs_slate character varying, source_player_id character varying, source_player_name character varying, source_team_id character varying, source_team_opp_id character varying, dfs_position character varying, salary smallint, pctcap numeric) AS
$BODY$

WITH t AS (
  SELECT jsonb_array_elements(data->'draftables') AS dt 
  FROM dfs.dksal
  WHERE season_year = $1 AND week = $2 AND slate = $3
),

t2 AS (
select 
  $1::smallint AS season_year, $2::smallint AS week,
  CAST(dt->>'playerId' AS int) AS source_player_id,
  CAST(dt->>'displayName' as varchar) as source_player_name,
  CAST(dt->>'teamAbbreviation' as varchar) as source_team_id,
  CASE WHEN CAST(dt->>'rosterSlotId' AS int) = 511 THEN 'CPT' ELSE 'FLEX' END as dfs_position,
  CAST(dt->>'salary' AS smallint) AS salary,
  'dk'::varchar AS dfs_site,
  $3 AS dfs_slate
from t
),

g AS (
  SELECT 
    CASE WHEN team_id = 'LA' THEN 'LAR' ELSE team_id END as team_id, 
    CASE WHEN opp_team_id = 'LA' THEN 'LAR' ELSE opp_team_id END as opp_team_id
  FROM base.vw_gamesmeta
  WHERE season_year = $1 AND week = $2
)

SELECT 
  season_year, 
  week, 
  dfs_site,
  dfs_slate, 
  source_player_id::varchar, 
  source_player_name, 
  source_team_id, 
  g.opp_team_id AS source_opp_team_id,
  dfs_position, 
  salary, 
  ROUND(salary::numeric/60000.0, 3) as pctcap
FROM t2
LEFT JOIN g ON t2.source_team_id = g.team_id
ORDER BY dfs_position, salary DESC
$BODY$
  LANGUAGE sql;
