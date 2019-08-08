-- fantasy.vw_watson2_projections.sql
-- joins fantasy.watson_projections, fantasy.watson_players, base.player_xref
-- shows most recent (within last 7 days) projection for players

-- TODO: add function to detect season and week covered by projection

CREATE OR REPLACE VIEW fantasy.vw_watson2_projections AS 

WITH p AS (
   SELECT 
     player_xref.player_id,
     player_xref.source_player_id::integer AS playerid
   FROM base.player_xref
   WHERE player_xref.source = 'espn_fantasy'::text
),

proj AS (
  SELECT *, row_number() OVER (PARTITION BY playerid ORDER BY execution_timestamp DESC) as rnum
  FROM fantasy.watson2
),

w AS (
  SELECT * 
  FROM proj 
  WHERE rnum = 1 AND execution_timestamp > now() - interval '7 days'
)        

SELECT 
  p.player_id,
  w.playerid AS watson_player_id,
  wp.full_name,
  wp.team_location AS team,
  wp."position" AS pos,
  round(w.score_projection, 2) AS score_projection,
  w.outside_projection,
  w.simulation_projection,
  w.score_distribution
FROM w
LEFT JOIN p ON w.playerid = p.playerid
LEFT JOIN fantasy.watson_players wp ON w.playerid = wp.playerid
WHERE wp."position" <> 'K'::text
ORDER BY (round(w.score_projection, 2)) DESC;