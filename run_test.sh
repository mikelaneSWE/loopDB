#!/bin/bash
set -e

# Start PostgreSQL service
service postgresql start

# Wait for Postgres to accept connections (pg_isready returns 0 when ready)
for i in 1 2 3 4 5 6 7 8 9 10; do
	if pg_isready -q; then
		break
	fi
	sleep 1
done

# Run the test
npx mocha test_database.js
