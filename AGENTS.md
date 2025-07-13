# Repository Guidelines

## Purpose

This application manages IoT hardware devices and collects sensor telemetry. It provides a REST API for device management and stores sensor data in ClickHouse, while other data lives in PostgreSQL.

* Models in `app/models/sensor_data/base.rb` and all of their descendants operate via the **ClickHouse** database.
* ClickHouse may be used in tests; data must actually be saved.
* The ClickHouse database is installed and configured. Use `rake db:create:clickhouse` to create it and run migrations with `rake db:migrate:clickhouse`.
* Other models use PostgreSQL. Create the database with `rake db:create:primary` and run migrations with `rake db:migrate:primary`.
* All written code must have unit and integration tests. Tests should cover all branches.
