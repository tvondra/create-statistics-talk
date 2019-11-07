ANALYZE zip_codes;

-- single-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Львів';

-- number of tuples / pages in a table
SELECT reltuples, relpages FROM pg_class
 WHERE relname = 'zip_codes';

-- statistics for a table
SELECT * FROM pg_stats
 WHERE tablename = 'zip_codes'
   AND attname = 'place_name';

-- multi-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Львів'
                          AND province_name = 'Lvivska';

-- multi-column condition, inequality
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Київ'
                          AND province_name != 'Kyiv';

-- functional dependencies
CREATE STATISTICS s (dependencies)
    ON place_name, state_name, province_name FROM zip_codes;

ANALYZE zip_codes;

SELECT dependencies FROM pg_stats_ext WHERE statistics_name = 's';

-- underestimate
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE place_name = 'Львів'
                          AND province_name = 'Lvivska';

-- overestimate #1
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE province_name = 'Kyiv'
                          AND state_name != 'Kyiv';

-- overestimate #2
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE province_name = 'Kyiv'
                          AND state_name = 'Lvivska';

-- ndistinct
EXPLAIN (ANALYZE, TIMING off)
SELECT count(*) FROM zip_codes GROUP BY province_name;

-- number of distinct groups
SELECT attname, n_distinct
  FROM pg_stats WHERE tablename = 'zip_codes';

-- multiple group by columns
EXPLAIN (ANALYZE, TIMING off)
SELECT count(*) FROM zip_codes GROUP BY place_name, province_name;

CREATE STATISTICS s (ndistinct)
    ON place_name, province_name, state_name
  FROM zip_codes;

SELECT n_distinct FROM pg_stats_ext WHERE statistics_name = 's'


