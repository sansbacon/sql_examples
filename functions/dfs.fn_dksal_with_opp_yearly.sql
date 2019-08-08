-- dfs.fn_dksal_with_opp_yearly.sql
-- gets yearly dfs salaries by week with opponent information

DROP FUNCTION dfs.fn_dksal_with_opp_yearly(integer, integer, integer);

CREATE OR REPLACE FUNCTION dfs.fn_dksal_with_opp_yearly(
    IN year integer,
    IN start_week integer,
    IN end_week integer)
  RETURNS TABLE(seas smallint, week smallint, plyrid int, plyr character varying,
  pos character varying, team character varying, opp character varying, is_home boolean, salary smallint, pctcap numeric) AS
$BODY$
DECLARE  
    wk int;
BEGIN
   FOR wk IN SELECT * FROM generate_series(start_week, end_week)
   LOOP
    RETURN QUERY 
        WITH g AS (
	  SELECT gm.team_id, gm.is_home 
	  FROM base.vw_gamesmeta AS gm
	  WHERE gm.season_year = $1 AND gm.week = wk
	)
	select 
	  dk.season_year as seas, 
	  dk.week,
	  dk.source_player_id::int as plyrid,
	  dk.source_player_name as plyr,
	  dk.dfs_position as pos,
	  dk.source_team_id as team,
	  dk.source_team_opp_id as opp,
	  g.is_home,
	  dk.salary,
	  dk.pctcap
	from dfs.fn_dksal_sws($1, wk) AS dk
	left join g ON dk.source_team_id = g.team_id;   
   END LOOP;
END $BODY$
  LANGUAGE plpgsql;