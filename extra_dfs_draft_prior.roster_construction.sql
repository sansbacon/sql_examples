-- Materialized View: extra_dfs_draft_prior.roster_construction

-- DROP MATERIALIZED VIEW extra_dfs_draft_prior.roster_construction;

CREATE MATERIALIZED VIEW extra_dfs_draft_prior.roster_construction AS 
 WITH t AS (
         SELECT league.draft_id
           FROM extra_dfs_draft_prior.league
        ), t2 AS (
         SELECT d.draft_id,
            d.team_id,
            d.round_number,
            d.pick_number,
            d.player_id,
            p.first_name,
            p.last_name,
            p."position"
           FROM extra_dfs_draft_prior.draft d
             LEFT JOIN extra_dfs_draft_prior.player p ON d.player_id = p.player_id
          WHERE (d.draft_id IN ( SELECT t.draft_id
                   FROM t))
        ), t3 AS (
         SELECT t2.draft_id,
            t2.team_id,
            t2."position",
            count(t2."position") AS npos
           FROM t2
          GROUP BY t2.draft_id, t2.team_id, t2."position"
        ), t4 AS (
         SELECT draft.draft_id,
            draft.team_id,
            draft.pick_number AS draft_slot
           FROM extra_dfs_draft_prior.draft
          WHERE draft.round_number = 1
        )
 SELECT t3.draft_id,
    t3.team_id,
    t3."position",
    t3.npos,
    t4.draft_slot,
    l.participants,
    l.entry_cost
   FROM t3
     LEFT JOIN t4 ON t3.draft_id = t4.draft_id AND t3.team_id = t4.team_id
     LEFT JOIN extra_dfs_draft_prior.league l ON t3.draft_id = l.draft_id
WITH DATA;

ALTER TABLE extra_dfs_draft_prior.roster_construction
  OWNER TO nfldb;
