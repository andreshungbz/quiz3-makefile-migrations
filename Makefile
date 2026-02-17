# CMPS3162 Advanced Databases Quiz 3 - Makefile + Database Migrations
# Andres Hung
# February 19, 2026

# Pass in the .envrc file, which exports HOTEL_DB_DSN
include .envrc

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run/api: Run the API server application
.PHONY: run/api
run/api:
	go run ./cmd/api -db-dsn=${HOTEL_DB_DSN}

# ==================================================================================== #
# DATABASE MIGRATIONS
# ==================================================================================== #

## db/psql: Connect to the hotel database using psql as hotel_user
.PHONY: db/psql
db/psql:
	psql ${HOTEL_DB_DSN}

## db/migrations/new name=$1: Create a new database migration
.PHONY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/migrations/up: Apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up:
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${HOTEL_DB_DSN} up

## db/migrations/down: Apply all down database migrations
.PHONY: db/migrations/down
db/migrations/down:
	@echo 'Reverting all migrations...'
	migrate -path ./migrations -database ${HOTEL_DB_DSN} down

## db/migrations/fix version=$1: Force the schema_migrations table version
.PHONY: db/migrations/fix:
	@echo 'Forcing schema migrations version to ${version}...'
	migrate -path ./migrations -database ${HOTEL_DB_DSN} force ${version}
