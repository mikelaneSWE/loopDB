# loopDB
2nd Project - API/DB &amp; Docker Exercise

Hello!

Welcome back and thanks again for another challenge!  I put this together over the course of the weekend, finishing up Monday night.  
Both exercises have been completed, verified, and this one is added to Git.
This is once again some of my code, and GitHub Copilot integrated with the base Ben provided.  I will breakdown the approach and blockers I encountered during the video.  
But, for now, I included some cliff notes and thoughts witin the ReadMe file and Repo Landing Page.  
Let me know if you have any questions or concerns, I can not wait to hear from you guys again!  Whatever it takes, I am ready, disciplined, and eager.

# Database Test Suite - User Tests

## Overview
This project contains a suite of database tests focused on user-related functionality. Recently, one of the tests began failing unexpectedly, despite no reported changes from the development team. This repository contains the necessary files to reproduce and fix the issue.

## Project Structure
- `test_database.js` - Contains the database test suite
- `setup_db.sql` - Database initialization script
- `setup_db.sql.b64` - Base64 encoded version of the setup script (for Docker)
- `Dockerfile` - Container configuration for running tests
- `run_test.sh` - Shell script to execute the test suite

## Discovery, Diagnosis, Fixes, Debugging, Testing

Breakdown:
- Observed and fixed failing test by ensuring inserted test data matches DB validation: added a `password_hash` to the first INSERT in `test_database.js` so the `validate_user_trigger` does not raise an exception.

- Made the Docker environment runnable, adding a few things:
	- Updated base image in `Dockerfile` to `node:14-bullseye` so apt repositories are valid.
	- Made Postgres config handling robust (no hardcoded version path) so `pg_hba.conf` and `postgresql.conf` updates work across Postgres versions.
	- Normalized Windows CRLF line endings for shell scripts inside the image and made `run_test.sh` executable.
	- Set the container CMD to run `run_test.sh` with `bash` so the shebang and bash options are respected.
	- Added `sed` normalization step in the Docker build to avoid shell parsing errors from CRLF.

- Improved test runner script `run_test.sh`:
	- Converted to Unix line endings, added a `pg_isready` loop to wait for Postgres before running tests.

Result: Docker image builds and the test suite runs inside the container; `npm test` inside the container shows `3 passing` tests. Woo!

How I Confirmed:
- Decoded `setup_db.sql.b64` locally to inspect schema/triggers.
- Ran `docker build -t qa-db-debug-test .` and `docker run --rm -it qa-db-debug-test` — the container started Postgres, loaded the SQL, and mocha reported `3 passing`.
