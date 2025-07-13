# Repository Guidelines

* Модели `app/models/sensor_data/base.rb` и все их потомки работают через базу данных **ClickHouse**.
* В тестах допускается использование ClickHouse, данные должны реально сохраняться.
* База ClickHouse установлена и настроена. Для её создания используйте `rake db:create:clickhouse`, миграции запускайте через `rake db:migrate:clickhouse`.
* Для остальных моделей используется PostgreSQL. Создание базы: `rake db:create:primary`, миграции: `rake db:migrate:primary`.
* Для написанного кода необходимо писать unit‑ и интеграционные тесты. Тесты должны покрывать все ветвления.
