CREATE TABLE zip_codes (
    zip_code   INT PRIMARY KEY,
    city       TEXT,
    state      TEXT,
    county     TEXT,
    latitude   REAL,
    longitude  REAL
);

-- shell command
COPY zip_codes FROM '/tmp/no_postal_codes_utf.csv' WITH (format csv, header true);

ANALYZE zip_codes;

-- single-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE city = 'Oslo';

-- number of tuples / pages in a table
SELECT reltuples, relpages FROM pg_class WHERE relname = 'zip_codes';

-- statistics for a table
SELECT * FROM pg_stats WHERE tablename = 'zip_codes' AND attname = 'city';

-- multi-column condition
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE city = 'Oslo' AND county = 'Oslo';

-- multi-column condition, inequality
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE city = 'Oslo' AND county != 'Oslo';

-- multi-column condition, incompatible conditions
EXPLAIN (ANALYZE, TIMING off)
SELECT * FROM zip_codes WHERE city = 'Oslo' AND county = 'Halden';

-- functional dependencies
CREATE STATISTICS s (dependencies)
    ON city, state, county FROM zip_codes;

ANALYZE zip_codes;

SELECT stxdependencies FROM pg_statistic_ext WHERE stxname = ‘s’;

-- ndistinct
EXPLAIN (ANALYZE, TIMING off) SELECT 1 FROM zip_codes GROUP BY county;

EXPLAIN (ANALYZE, TIMING off) SELECT 1 FROM zip_codes GROUP BY state;

-- number of distinct groups
SELECT attname, n_distinct
  FROM pg_stats WHERE tablename = 'zip_codes';

EXPLAIN (ANALYZE, TIMING off) SELECT 1 FROM zip_codes GROUP BY state, county;

CREATE STATISTICS s (ndistinct)
    ON county, state, city
  FROM zip_codes;
ANALYZE zip_codes;

SELECT stxndistinct FROM pg_statistic_ext;

