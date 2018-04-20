-- View: extra_dfs_draft_prior.vw_league_results

-- DROP VIEW extra_dfs_draft_prior.vw_league_results;

CREATE OR REPLACE VIEW extra_dfs_draft_prior.vw_league_results AS 
 SELECT ts.draft_id,
    ts.team_id,
    ts.score,
    ts.rk,
    l.participants,
    l.entry_cost,
    l.draft_tm
   FROM extra_dfs_draft_prior.team_scoring ts
     LEFT JOIN extra_dfs_draft_prior.league l ON ts.draft_id::text = l.draft_id
  ORDER BY ts.draft_id, ts.rk;

ALTER TABLE extra_dfs_draft_prior.vw_league_results
  OWNER TO nfldb;
