-- Function: extra_dfs_draft_prior.roster_construction_pivot()

-- DROP FUNCTION extra_dfs_draft_prior.roster_construction_pivot();

CREATE OR REPLACE FUNCTION extra_dfs_draft_prior.roster_construction_pivot()
  RETURNS TABLE(league_size smallint, entry_cost smallint, draft_slot smallint, qb numeric, rb numeric, te numeric, wr numeric) AS
$BODY$
DECLARE
  i smallint;
  ls smallint[] := array[6, 10, 12];
  j smallint;
  lsj smallint[] := array[1, 3, 5, 10, 25, 50];

BEGIN
FOREACH j IN ARRAY lsj
  LOOP
  FOREACH i IN ARRAY ls
    LOOP
	RETURN QUERY 
		SELECT i as league_size, j as entry_cost, * FROM crosstab(
		CONCAT('SELECT draft_slot::smallint, position, round(avg(npos)::numeric, 2) as npos
		FROM extra_dfs_draft_prior.roster_construction
		WHERE entry_cost = ', j, ' AND participants = ', i, 'GROUP BY draft_slot, position
		ORDER BY 1, 2')) AS final_result(draft_slot smallint, QB NUMERIC, RB NUMERIC, TE NUMERIC, WR NUMERIC);
    END LOOP;
  END LOOP;
  RETURN;
END $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION extra_dfs_draft_prior.roster_construction_pivot()
  OWNER TO nfldb;
