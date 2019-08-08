-- dfs.fn_dksal_with_opp.sql
-- shows salary query with opp / location

WITH g AS (
  SELECT team_id, is_home FROM base.vw_gamesmeta
  WHERE season_year = 2018 AND week = 14
)

select 
  dk.season_year as seas, 
  dk.week,
  dk.source_player_name as plyr,
  dk.dfs_position as pos,
  dk.source_team_id as team,
  dk.source_team_opp_id as opp,
  g.is_home,
  dk.salary,
  dk.pctcap
from dfs.fn_dksal_sws(2018, 14) AS dk
left join g ON dk.source_team_id = g.team_id