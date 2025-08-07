# Развертывание на Ubuntu Server

Эти шаги описывают развертывание приложения в окружении Ubuntu Server с использованием Docker Compose.

## Подготовка сервера
1. Установите [Docker](https://docs.docker.com/engine/install/ubuntu/) и [Docker Compose](https://docs.docker.com/compose/install/).
2. Склонируйте репозиторий проекта:
   ```bash
   git clone https://example.com/flow7_iot.git
   cd flow7_iot
   ```

## Настройка переменных окружения
1. Скопируйте шаблон файла окружения и отредактируйте его:
   ```bash
   cp .env.example .env
   ```
2. Сгенерируйте `SECRET_KEY_BASE` и добавьте его в `.env` вместе с другими параметрами:
   ```bash
   docker compose run --rm app bundle exec rake secret
   ```
   Полученное значение вставьте в переменную `SECRET_KEY_BASE`.
3. Убедитесь, что в файле `.env` установлено `RAILS_ENV=production` и заполнены остальные параметры. Пример содержимого:
   ```env
   SECRET_KEY_BASE=ключ

   POSTGRES_DB=postgres
   POSTGRES_APP_DB=flow7_iot
   POSTGRES_HOST=postgresql
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=flow7_iot

   CLICKHOUSE_DB=default_db
   CLICKHOUSE_APP_DB=flow7_iot
   CLICKHOUSE_HOST=clickhouse
   CLICKHOUSE_USER=flow7_iot
   CLICKHOUSE_PASSWORD=flow7_iot

   RAILS_ENV=production
   REDIS_URL=redis://redis:6379/1
   ```

## Запуск контейнеров
1. Соберите и запустите сервисы:
   ```bash
   docker compose up -d --build
   ```
2. Выполните создание баз данных и миграции:
   ```bash
   docker compose run --rm app bundle exec rake \
     db:create:primary db:migrate:primary \
     db:create:clickhouse db:migrate:clickhouse
   ```

После выполнения указанных команд приложение будет доступно по адресу `http://<IP_сервера>:3000`.
