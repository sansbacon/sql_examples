-- extra_misc.draft.draft_summary

WITH t AS (
  select source_team_code, draft_year, draft_round, count(source_team_code) as num_picks
  from extra_misc.draft
  group by source_team_code, draft_year, draft_round
)

SELECT t.*,
  SUM(num_picks) over (PARTITION BY source_team_code, draft_year ORDER BY draft_round 
                       rows between unbounded preceding and current row) as tot_picks
FROM t
ORDER BY source_team_code, draft_year, draft_round
