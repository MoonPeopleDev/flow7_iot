# API

Этот документ описывает программный интерфейс (API), предоставляемый данным приложением. Все эндпоинты располагаются под префиксом `/api/v1`.

## Структура ответов

Для ресурсов используется формáт [JSON:API](https://jsonapi.org/). При успешном запросе возвращается объект `data` с атрибутами модели. При ошибке валидации возвращается объект `errors`.

## Аутентификация

Для доступа к API аутентификация не требуется. CSRF-проверка отключена для всех эндпоинтов API.

## Общие параметры

- `page[number]` – номер страницы для списков. По умолчанию `1`.
- `page[size]` – размер страницы. По умолчанию `25`.

## Ресурсы устройств (`/devices`)

### Аппаратные модели

- `GET /devices/hardware_models` – список моделей.
- `GET /devices/hardware_models/:id` – информация о модели.
- `POST /devices/hardware_models` – создание модели. Атрибуты: `name`, `description`, `sensor_type_ids` (массив).
- `PUT /devices/hardware_models/:id` – обновление модели.
- `DELETE /devices/hardware_models/:id` – удаление модели.

### Аппаратные экземпляры

- `GET /devices/hardware_items` – список устройств.
- `GET /devices/hardware_items/:id` – информация об устройстве.
- `POST /devices/hardware_items` – создание устройства. Атрибуты: `name`, `description`, `hardware_model_id`, `serial_number`.
- `PUT /devices/hardware_items/:id` – обновление устройства.
- `DELETE /devices/hardware_items/:id` – удаление устройства.
- `PUT /devices/hardware_items/:id/reset_crypto` – сброс криптографического ключа для устройства.

### Типы датчиков

- `GET /devices/sensor_types` – список типов датчиков.
- `GET /devices/sensor_types/:id` – информация о типе датчика. В секции `meta.enums` присутствуют возможные значения перечислений (`scalable_by`, `general_data_method`, `chart_type`).
- `POST /devices/sensor_types` – создание типа датчика. Атрибуты: `name`, `description`, `data_key_name`, `scalable`, `scalable_by`, `general_data_method`, `chart_type`.
- `PUT /devices/sensor_types/:id` – обновление типа датчика.
- `DELETE /devices/sensor_types/:id` – удаление типа датчика.

### Датчики

- `GET /devices/sensors` – список датчиков.
- `GET /devices/sensors/:id` – информация о датчике.
- `POST /devices/sensors` – создание датчика (по умолчанию датчики создаются автоматически вместе с устройством).
- `PUT /devices/sensors/:id` – обновление датчика.
- `DELETE /devices/sensors/:id` – удаление датчика.
- `GET /devices/sensors/:id/data` – данные датчика за указанный период. Обязательные параметры запроса: `from` и `to` (в формате ISO 8601). Дополнительные параметры: `capacity` (`raw`, `10s`, `1m`, `10m`, `1h`) и `scalable_by` (`avg`, `max`, `min`, `sum`, `diff`, `avg_no_zeros`). В ответе возвращается объект `sensor_data` с массивом `data` и разделом `general`.

Формат ответа:
```json
{
  "data": {
    "id": "1",
    "type": "sensor_data",
    "attributes": {
      "sensor_type": { "name": "Current", "data_key_name": "i" },
      "data": [ { "at": 1710000000000, "v": 12 } ],
      "general": { "min": 12, "max": 12, "avg": 12 }
    }
  }
}
```
Поле `data` содержит массив точек. Для обычных датчиков каждая точка имеет поля `at` (в миллисекундах) и `v` (значение). Для датчиков `rfid` используется поле `rfid` вместо `v`, а для режима `rfid_hold` также присутствует `v` (`in`/`out`) и `personnel_id`.
Секция `general` зависит от значения `general_data_method` типа датчика: `min_max_average` и `min_max_diff` возвращают `{ min, max, avg }`, `sum` – `{ sum }`, `work_idle_times` – `{ work_time, idle_time }`, `rfid_hold_times` – набор ключей RFID с накопленным временем, в остальных случаях `null`.

## Приём телеметрии (`/sensor_data/receiver`)

`POST /sensor_data/receiver` – приём зашифрованных данных от устройства. На стороне устройства запрос формируется следующим образом:

1. В заголовке `X-Device-ID` передаётся серийный номер устройства.
2. В заголовке `X-Nonce` передаётся base64‑строка с инициализационным вектором для AES‑шифрования.
3. Тело запроса содержит бинарные зашифрованные данные.

Если у устройства нет сохранённого AES‑ключа, сервис сгенерирует ключ и вернёт строку `K:<ключ_в_base64>` в теле ответа. В остальных случаях возвращается JSON с результатом `{"result":"ok"}` или сообщение об ошибке.

Расшифрованные данные должны иметь структуру:

```json
{
  "firmware": "v1.2",
  "model": "model-name",
  "uptime": 12345,
  "ts": 1710000000000,
  "data": [
    { "ts": 1710000000000, "i": 12, "u": 220 },
    { "ts": 1710000006000, "i": 10, "u": 219 }
  ]
}
```

Поле `data` – массив показаний с временной меткой `ts` (в мс) и парами `ключ_датчика` – `значение`.

## Проверка работоспособности

`GET /up` – возвращает `200 OK`, если приложение успешно запущено.

## Корневой путь

`GET /` – главная страница (используется для веб-интерфейса и не относится к API).

