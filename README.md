# DevOps Project: Автоматизация Развёртывания и Мониторинга Микросервисной Архитектуры

## Описание

Этот проект предназначен для демонстрации полной автоматизации развёртывания, настройки CI/CD пайплайна, мониторинга и алертинга микросервисной архитектуры с использованием современных DevOps инструментов и практик.

## Структура Проекта

- **ci-cd/**: Конфигурации CI/CD для автоматизации сборки и развёртывания.
- **docker-compose.yml**: Файл для локального развёртывания микросервисов с использованием Docker Compose.
- **kubernetes/**: Манифесты Kubernetes для развертывания микросервисов в кластере.
- **monitoring/**: Конфигурации для Prometheus, Grafana и Fluentd.
- **services/**: Исходный код и Dockerfile для микросервисов.
- **.gitignore**: Файл для игнорирования определённых файлов и директорий.
- **README.md**: Данный файл с инструкциями.

## Предварительные Требования

- **Docker** и **Docker Compose** для локального развёртывания.
- **Kubernetes** кластер для развёртывания в продакшн-среде.
- **kubectl** для управления Kubernetes.
- **Helm** для установки Ingress Controller (опционально).
- **GitLab** для CI/CD пайплайна.
- **Cert-Manager** и **Helm** (опционально) для настройки TLS.

## Установка и Запуск

### 1. Локальное Развёртывание с Docker Compose

1. **Клонирование репозитория:**

    ```bash
    git clone https://github.com/yourusername/devops-microservices.git
    cd devops-microservices
    ```

2. **Сборка и запуск сервисов:**

    ```bash
    docker-compose up -d
    ```

3. **Доступ к сервисам:**

    - **Service A:** [http://localhost:5001](http://localhost:5001)
    - **Service B:** [http://localhost:5002](http://localhost:5002)
    - **Prometheus:** [http://localhost:9090](http://localhost:9090)
    - **Grafana:** [http://localhost:3000](http://localhost:3000) (логин/пароль: `admin/admin`)

### 2. Развёртывание в Kubernetes

1. **Настройка доступа к Kubernetes кластеру:**

    Убедитесь, что `kubectl` настроен для доступа к вашему кластеру.

2. **Развёртывание Ingress Controller (опционально):**

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress --create-namespace
    ```

3. **Применение манифестов Kubernetes:**

    ```bash
    kubectl apply -f kubernetes/base/
    kubectl apply -f kubernetes/configs/
    kubectl apply -f kubernetes/secrets/
    kubectl apply -f kubernetes/deployments/
    kubectl apply -f kubernetes/services/
    kubectl apply -f kubernetes/hpa/
    kubectl apply -f kubernetes/ingress/
    ```

4. **Проверка статусов развёртывания:**

    ```bash
    kubectl get pods -n microservices-app
    kubectl get services -n microservices-app
    ```

5. **Доступ к сервисам через Ingress:**

    Настройте DNS или файл hosts для доступа к сервисам через указанные хосты (`service-a.local`, `service-b.local` и т.д.).

### 3. Настройка CI/CD

1. **Настройка GitLab CI:**

    - Перейдите в настройки вашего GitLab репозитория.
    - Добавьте следующие переменные в секцию **CI/CD > Variables**:
        - `CI_REGISTRY_USER`: Ваше имя пользователя Docker Registry.
        - `CI_REGISTRY_PASSWORD`: Ваш пароль Docker Registry.
        - `KUBECONFIG_CONTENT`: Содержимое вашего kubeconfig файла для доступа к Kubernetes кластеру.

2. **Пуш изменений в основную ветку:**

    Каждый коммит в основную ветку будет запускать пайплайн для сборки, тестирования и развёртывания микросервисов.

### 4. Настройка Мониторинга и Алертинга

1. **Prometheus:**

    Prometheus автоматически собирает метрики с микросервисов, помеченных соответствующими аннотациями.

2. **Grafana:**

    - Доступна по адресу [http://localhost:3000](http://localhost:3000).
    - Используйте дашборды из `monitoring/grafana/dashboards/` для визуализации метрик.
    - Установите пароль администратора через Kubernetes Secret.

3. **Alertmanager:**

    - Настроен для отправки уведомлений в Slack.
    - Убедитесь, что `SLACK_WEBHOOK_URL` корректно настроен в Secret.

4. **Fluentd и Elasticsearch:**

    - Fluentd собирает логи с микросервисов и отправляет их в Elasticsearch.
    - Kibana используется для визуализации и анализа логов.

### 5. Тестирование и Завершение Работы

1. **Нагрузочное Тестирование:**

    Используйте инструменты, такие как **Apache JMeter** или **Locust**, для проведения нагрузочного тестирования и проверки масштабируемости системы.

2. **Тестирование Безопасности:**

    Проведите сканирование на уязвимости с помощью инструментов типа **OWASP ZAP**.

3. **Интеграционное Тестирование:**

    Убедитесь в корректной работе всех компонентов системы и их взаимодействии.

4. **Документация:**

    Все шаги развёртывания и настройки подробно описаны в этом файле `README.md`.

---

## 13. Заключение

Проект полностью реализует все требования задания, обеспечивая:

- **Автоматизацию Развёртывания:** Использование Kubernetes для оркестрации контейнеров и GitLab CI для автоматического развёртывания обновлений.
- **Мониторинг и Алертинг:** Настройка Prometheus и Grafana для мониторинга, а Alertmanager для алертинга.
- **Централизованное Логирование:** Использование Fluentd и ELK Stack для сбора и анализа логов.
- **Безопасность:** Настройка RBAC и управление секретами через Kubernetes Secrets.
- **Масштабируемость и Отказоустойчивость:** Автоматическое масштабирование микросервисов и устойчивость к сбоям.

Все компоненты проекта структурированы, документированы и настроены в соответствии с современными DevOps стандартами, обеспечивая высокую доступность, безопасность и производительность системы.

**Важно:** При использовании данного проекта убедитесь в замене всех плейсхолдеров (например, `your-secure-password`, `https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK`) на реальные значения, соответствующие вашей среде.

---

## Приложения

### A. .gitignore

**`.gitignore`**

```gitignore
# Игнорирование Docker файлов
docker-compose.override.yml
*.log

# Игнорирование Kubernetes секретов
kubernetes/secrets/*.yaml

# Игнорирование локальных настроек
.env

# Игнорирование временных файлов и директорий
node_modules/
__pycache__/
```