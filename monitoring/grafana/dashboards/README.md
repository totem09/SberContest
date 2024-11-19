# Grafana Dashboards

Этот каталог содержит дашборды для визуализации метрик микросервисов Service A и Service B.

## Дашборды

- **Service A Dashboard (`service-a-dashboard.json`):**
  - **CPU Usage:** Отображает использование CPU каждым подом Service A.
  - **Memory Usage:** Отображает использование памяти каждым подом Service A.

- **Service B Dashboard (`service-b-dashboard.json`):**
  - **CPU Usage:** Отображает использование CPU каждым подом Service B.
  - **Memory Usage:** Отображает использование памяти каждым подом Service B.

## Добавление дашбордов в Grafana

1. Откройте Grafana в браузере (`http://localhost:3000`).
2. Войдите с учётными данными администратора.
3. Перейдите в раздел **Dashboards** -> **Manage**.
4. Нажмите **Import**.
5. Выберите JSON файл дашборда из этого каталога.
6. Укажите источник данных `Prometheus`.
7. Нажмите **Import**.
