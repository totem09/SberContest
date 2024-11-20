# SberContest: Автоматизация Развёртывания и Мониторинга Микросервисной Архитектуры

## Структура проекта

- **services/** - Исходный код и dockerfile для микросервисов service a и service b
- **kubernetes/** - Манифесты Kubernetes для развертывания микросервисов и инфраструктурных компонентов
- **ci-cd/** - Конфигурация gitlab CI для автоматизации сборки, тестирования и деплоя
- **terraform/** - Скрипты terraform для создания инфраструктуры
- **ansible/** - playbook ansible для настройки узлов kubernetes
- **README.md** - Данный файл с инструкциями

## Предварительные требования

- **Docker** и **Docker Compose** для локального развёртывания
- **Kubernetes** кластер
- **kubectl** для управления Kubernetes
- **Helm** для установки Ingress Controller (NGINX Ingress)
- **GitLab** для CI/CD пайплайна
- **Terraform** и **Ansible** для инфраструктуры

## Установка и запуск

### 1. Контейнеризация микросервисов

1. **Сборка docker-образов**

    ```bash
    docker build -t ghcr.io/totem09/SberContest/service-a:latest ./services/service-a
    docker build -t ghcr.io/totem09/SberContest/service-b:latest ./services/service-b
    ```

2. **Пуш docker-образов в gitHub container registry**

    ```bash
    docker push ghcr.io/totem09/SberContest/service-a:latest
    docker push ghcr.io/totem09/SberContest/service-b:latest
    ```

### 2. Развёртывание kubernetes кластера

1. **Использование terraform для создания инфраструктуры**

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

### 3. Настройка kubernetes с ansible

1. **Запуск playbook ansible**

    ```bash
    cd ../ansible/
    ansible-playbook -i inventory playbook.yml
    ```

    - **Примечание** Убедитесь, что у вас есть файл `inventory` с указанием хостов.

### 4. Применение kubernetes манифестов

1. **Примените namespace и RBAC**

    ```bash
    kubectl apply -f kubernetes/base/namespace.yaml
    kubectl apply -f kubernetes/base/rbac.yaml
    ```

2. **Примените configMaps**

    ```bash
    kubectl apply -f kubernetes/configs/prometheus-configmap.yaml
    kubectl apply -f kubernetes/configs/grafana-configmap.yaml
    kubectl apply -f kubernetes/configs/alertmanager-configmap.yaml
    kubectl apply -f kubernetes/configs/fluentd-configmap.yaml
    ```

3. **Примените persistent volume claims**

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

### 5. Настройка CI/CD пайплайна

1. **Настройте gitlab CI переменные**

    В gitlab репозитории перейдите в `Settings` > `CI/CD` > `Variables` и добавьте следующие переменные:

    - **`GITHUB_TOKEN`**: Ваш [github personal access token](https://github.com/settings/tokens) с правами доступа к github container registry
    - **`KUBECONFIG_CONTENT`**: Содержимое вашего `kubeconfig` файла для доступа к kubernetes кластеру

2. **Запушьте изменения в основную ветку**

    Каждый коммит в основную ветку будет запускать пайплайн для сборки, тестирования и развертывания микросервисов

### 6. Доступ к сервисам

1. **Настройте файл `/etc/hosts`**

    Добавьте следующие строки, заменив `192.168.1.100` на IP-адрес вашего ingress controller:

    ```
    192.168.1.100 service-a.local
    192.168.1.100 service-b.local
    192.168.1.100 prometheus.local
    192.168.1.100 grafana.local
    192.168.1.100 alertmanager.local
    192.168.1.100 kibana.local
    ```

2. **Доступ к сервисам**

    - **Service A -** [http://service-a.local](http://service-a.local)
    - **Service B -** [http://service-b.local](http://service-b.local)
    - **Prometheus -** [http://prometheus.local](http://prometheus.local)
    - **Grafana -** [https://grafana.local](https://grafana.local)
    - **Alertmanager -** [https://alertmanager.local](https://alertmanager.local)
    - **Kibana -** [https://kibana.local](https://kibana.local)