-- Materialized View: extra_dfs_draft_prior.adp

DROP MATERIALIZED VIEW extra_dfs_draft_prior.adp;

CREATE MATERIALIZED VIEW extra_dfs_draft_prior.adp AS 
 WITH t AS (
         SELECT draft.draft_id,
            draft.team_id,
            draft.player_id,
            draft.pick_day,
            draft.round_number,
            draft.pick_number,
            extract(year from draft.pick_day) AS season_year
           FROM extra_dfs_draft_prior.draft
        ), t2 AS (
         SELECT t.season_year,
            t.player_id,
            round(avg(t.pick_number), 1) AS adp,
            max(t.pick_number) AS lowpk,
            min(t.pick_number) AS highpk
           FROM t
          GROUP BY t.season_year, t.player_id
        )
 SELECT p2.player_id,
    t2.season_year,
    p2.first_name,
    p2.last_name,
    p2."position",
    p2.team,
    t2.adp,
    t2.lowpk,
    t2.highpk
   FROM extra_dfs_draft_prior.player p2
     JOIN t2 ON p2.player_id = t2.player_id
  ORDER BY t2.adp
WITH DATA;

ALTER TABLE extra_dfs_draft_prior.adp
  OWNER TO nfldb;

-- Index: extra_dfs_draft_prior.adp_adp_season_year_idx

-- DROP INDEX extra_dfs_draft_prior.adp_adp_season_year_idx;

CREATE INDEX adp_adp_season_year_idx
  ON extra_dfs_draft_prior.adp
  (adp, season_year);

-- Index: extra_dfs_draft_prior.adp_player_id_season_year_idx

-- DROP INDEX extra_dfs_draft_prior.adp_player_id_season_year_idx;

CREATE INDEX adp_player_id_season_year_idx
  ON extra_dfs_draft_prior.adp
  (player_id, season_year);

-- Index: extra_dfs_draft_prior.adp_position_season_year_idx

-- DROP INDEX extra_dfs_draft_prior.adp_position_season_year_idx;

CREATE INDEX adp_position_season_year_idx
  ON extra_dfs_draft_prior.adp
  ("position", season_year);

