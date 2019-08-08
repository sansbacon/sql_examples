-- Materialized View: extra_dfs_draft_prior.draft_player_results
-- DROP MATERIALIZED VIEW extra_dfs_draft_prior.draft_player_results;

CREATE MATERIALIZED VIEW extra_dfs_draft_prior.draft_player_results AS 
 WITH t AS (
         SELECT d_1.draft_id,
            d_1.team_id,
            d_1.player_id,
            p.first_name,
            p.last_name,
            p."position"
           FROM extra_dfs_draft_prior.draft d_1
             LEFT JOIN extra_dfs_draft_prior.player p ON d_1.player_id = p.player_id
        ), t2 AS (
         SELECT final_result.player_id,
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
           FROM crosstab('SELECT player_id, week, live_projected_points::numeric
FROM extra_dfs_draft_prior.results ORDER BY 1'::text, 'SELECT w FROM generate_series(1,16) w'::text) final_result(player_id bigint, w1 numeric, w2 numeric, w3 numeric, w4 numeric, w5 numeric, w6 numeric, w7 numeric, w8 numeric, w9 numeric, w10 numeric, w11 numeric, w12 numeric, w13 numeric, w14 numeric, w15 numeric, w16 numeric)
        ), t3 AS (
         SELECT p.first_name,
            p.last_name,
            p.team,
            p."position",
            t2.player_id,
            t2.w1,
            t2.w2,
            t2.w3,
            t2.w4,
            t2.w5,
            t2.w6,
            t2.w7,
            t2.w8,
            t2.w9,
            t2.w10,
            t2.w11,
            t2.w12,
            t2.w13,
            t2.w14,
            t2.w15,
            t2.w16
           FROM t2
             JOIN extra_dfs_draft_prior.player p ON t2.player_id = p.player_id
        )
 SELECT d.draft_id,
    d.team_id,
    t3.first_name,
    t3.last_name,
    t3.team,
    t3."position",
    t3.player_id,
    t3.w1,
    t3.w2,
    t3.w3,
    t3.w4,
    t3.w5,
    t3.w6,
    t3.w7,
    t3.w8,
    t3.w9,
    t3.w10,
    t3.w11,
    t3.w12,
    t3.w13,
    t3.w14,
    t3.w15,
    t3.w16
   FROM extra_dfs_draft_prior.draft d
     LEFT JOIN t3 ON d.player_id = t3.player_id
WITH DATA;

ALTER TABLE extra_dfs_draft_prior.draft_player_results
  OWNER TO nfldb;

-- Index: extra_dfs_draft_prior.draft_player_results_draft_id_team_id_player_id_idx

-- DROP INDEX extra_dfs_draft_prior.draft_player_results_draft_id_team_id_player_id_idx;

CREATE INDEX draft_player_results_draft_id_team_id_player_id_idx
  ON extra_dfs_draft_prior.draft_player_results
  USING btree
  (draft_id COLLATE pg_catalog."default", team_id COLLATE pg_catalog."default", player_id);

-- Index: extra_dfs_draft_prior.draft_player_results_draft_id_team_id_position_idx

-- DROP INDEX extra_dfs_draft_prior.draft_player_results_draft_id_team_id_position_idx;

CREATE INDEX draft_player_results_draft_id_team_id_position_idx
  ON extra_dfs_draft_prior.draft_player_results
  USING btree
  (draft_id COLLATE pg_catalog."default", team_id COLLATE pg_catalog."default", "position" COLLATE pg_catalog."default");

