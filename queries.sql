ANALYZE zip_codes;

-- single-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Berlin';

-- number of tuples / pages in a table
SELECT reltuples, relpages FROM pg_class WHERE relname = 'zip_codes';

-- statistics for a table
SELECT * FROM pg_stats WHERE tablename = 'zip_codes' AND attname = 'place_name';

-- multi-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Berlin'
                          AND state_name = 'Berlin';

-- multi-column condition, inequality
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Berlin'
                          AND state_name != 'Berlin';

-- multi-column condition, incompatible conditions
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Berlin'
                          AND state_name = 'Bayern';

-- functional dependencies
CREATE STATISTICS s (dependencies)
    ON place_name, state_name, county_name FROM zip_codes;

ANALYZE zip_codes;

SELECT stxdependencies FROM pg_statistic_ext WHERE stxname = ‘s’;

-- ndistinct
EXPLAIN (ANALYZE, TIMING off)
SELECT 1 FROM zip_codes GROUP BY community_name;

EXPLAIN (ANALYZE, TIMING off)
SELECT 1 FROM zip_codes GROUP BY county_name;

EXPLAIN (ANALYZE, TIMING off)
SELECT 1 FROM zip_codes GROUP BY state_name;

-- number of distinct groups
SELECT attname, n_distinct
  FROM pg_stats WHERE tablename = 'zip_codes';

EXPLAIN (ANALYZE, TIMING off)
SELECT 1 FROM zip_codes GROUP BY state_name, county_name, community_name;

CREATE STATISTICS s (ndistinct)
    ON state_name, county_name, community_name
  FROM zip_codes;

SELECT stxndistinct FROM pg_statistic_ext;

