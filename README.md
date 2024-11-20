# SberContest: Автоматизация Развёртывания и Мониторинга Микросервисной Архитектуры

## Структура Проекта

- **services/**: Исходный код и Dockerfile для микросервисов Service A и Service B
- **kubernetes/**: Манифесты Kubernetes для развертывания микросервисов и инфраструктурных компонентов
- **ci-cd/**: Конфигурация GitLab CI для автоматизации сборки, тестирования и деплоя
- **terraform/**: Скрипты Terraform для создания инфраструктуры
- **ansible/**: Playbook Ansible для настройки узлов Kubernetes
- **README.md**: Данный файл с инструкциями

## Предварительные Требования

- **Docker** и **Docker Compose** для локального развёртывания
- **Kubernetes** кластер
- **kubectl** для управления Kubernetes
- **Helm** для установки Ingress Controller (NGINX Ingress)
- **GitLab** для CI/CD пайплайна
- **Terraform** и **Ansible** для инфраструктуры

## Установка и Запуск

### 1. Контейнеризация Микросервисов

1. **Сборка Docker-образов**

    ```bash
    docker build -t ghcr.io/totem09/SberContest/service-a:latest ./services/service-a
    docker build -t ghcr.io/totem09/SberContest/service-b:latest ./services/service-b
    ```

2. **Пуш Docker-образов в GitHub Container Registry**

    ```bash
    docker push ghcr.io/totem09/SberContest/service-a:latest
    docker push ghcr.io/totem09/SberContest/service-b:latest
    ```

### 2. Развёртывание Kubernetes Кластера

1. **Использование Terraform для создания инфраструктуры (например, AWS EKS)**

    ```bash
    cd terraform/
    terraform init
    terraform apply
    ```

    - Убедитесь, что вы настроили AWS CLI и имеете необходимые права доступа

2. **Получите `kubeconfig`**

    ```bash
    terraform output kubeconfig > ../kubeconfig.yaml
    export KUBECONFIG=../kubeconfig.yaml
    ```

### 3. Настройка Kubernetes с Ansible

1. **Запуск Playbook Ansible**

    ```bash
    cd ../ansible/
    ansible-playbook -i inventory playbook.yml
    ```

    - **Примечание** Убедитесь, что у вас есть файл `inventory` с указанием хостов.

### 4. Применение Kubernetes Манифестов

1. **Примените Namespace и RBAC**

    ```bash
    kubectl apply -f kubernetes/base/namespace.yaml
    kubectl apply -f kubernetes/base/rbac.yaml
    ```

2. **Примените ConfigMaps**

    ```bash
    kubectl apply -f kubernetes/configs/prometheus-configmap.yaml
    kubectl apply -f kubernetes/configs/grafana-configmap.yaml
    kubectl apply -f kubernetes/configs/alertmanager-configmap.yaml
    kubectl apply -f kubernetes/configs/fluentd-configmap.yaml
    ```

3. **Примените Persistent Volume Claims**

    ```bash
    kubectl apply -f kubernetes/pvc/grafana-pvc.yaml
    ```

4. **Разверните микросервисы и инфраструктурные компоненты**

    ```bash
    kubectl apply -f kubernetes/deployments/
    kubectl apply -f kubernetes/services/
    kubectl apply -f kubernetes/hpa/
    kubectl apply -f kubernetes/ingress/
    ```

### 5. Настройка CI/CD Пайплайна

1. **Настройте GitLab CI переменные**

    В GitLab репозитории перейдите в `Settings` > `CI/CD` > `Variables` и добавьте следующие переменные:

    - **`GITHUB_TOKEN`**: Ваш [GitHub Personal Access Token](https://github.com/settings/tokens) с правами доступа к GitHub Container Registry
    - **`KUBECONFIG_CONTENT`**: Содержимое вашего `kubeconfig` файла для доступа к Kubernetes кластеру

2. **Запушьте изменения в основную ветку**

    Каждый коммит в основную ветку будет запускать пайплайн для сборки, тестирования и развертывания микросервисов

### 6. Доступ к Сервисам

1. **Настройте файл `/etc/hosts`**

    Добавьте следующие строки, заменив `192.168.1.100` на IP-адрес вашего Ingress Controller:

    ```
    192.168.1.100 service-a.local
    192.168.1.100 service-b.local
    192.168.1.100 prometheus.local
    192.168.1.100 grafana.local
    192.168.1.100 alertmanager.local
    192.168.1.100 kibana.local
    ```

2. **Доступ к сервисам**

    - **Service A:** [http://service-a.local](http://service-a.local)
    - **Service B:** [http://service-b.local](http://service-b.local)
    - **Prometheus:** [http://prometheus.local](http://prometheus.local)
    - **Grafana:** [https://grafana.local](https://grafana.local)
    - **Alertmanager:** [https://alertmanager.local](https://alertmanager.local)
    - **Kibana:** [https://kibana.local](https://kibana.local)