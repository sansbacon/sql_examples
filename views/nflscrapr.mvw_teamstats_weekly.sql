-- nflscrapr.mvw_teamstats_weekly.sql
-- materialized view of query on json data in nflscrapr
-- can save files directly and then have database pick out what I need
-- for most common stats, use materialized view as doesn't change often

CREATE MATERIALIZED VIEW nflscrapr.mvw_teamstats_weekly AS
SELECT
  gsis_id as game_id, source_team_id as team, 
  CAST(passing_data->>'Opponent' AS varchar) as opp,  
  CAST(passing_data->>'Drives' AS int) as drives,
  CAST(passing_data->>'Completions' AS int) as pass_cmp,
  CAST(passing_data->>'Attempts' AS int) as pass_att,
  CAST(passing_data->>'Total_Yards' AS int) as pass_yd,
  CAST(passing_data->>'TDs' AS int) as pass_td,
  CAST(passing_data->>'Interceptions' AS int) as pass_int,
  CAST(passing_data->>'Total_Raw_AirYards' AS int) as pass_raw_airyd,
  CAST(passing_data->>'Total_Comp_AirYards' AS int) as pass_cmp_airyd,
  CAST(receiving_data->>'Total_Raw_YAC' AS int) as pass_cmp_yac, 
  CAST(rushing_data->>'Carries' AS int) as rush_att,
  CAST(rushing_data->>'Total_Yards' AS int) as rush_yd,
  CAST(rushing_data->>'TDs' AS int) as rush_td,
  CAST(rushing_data->>'Fumbles' AS int) + CAST(receiving_data->>'Fumbles' AS int) as fumble
FROM
  nflscrapr.teamstats_weekly
ORDER BY
  gsis_id, source_team_id

WITH DATA;