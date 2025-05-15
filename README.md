# Дипломный практикум в Yandex.Cloud - `Бакулев Евгений`

### Создание облачной инфраструктуры

1. Создаем пользователя, навешиваем права, создаем бакет для Terraform - [Backend](https://github.com/garrkiss/diplom/tree/main/terraform/backend)

Успешное выполнение terraform apply
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/1.png)

Бакет появился на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/2.png)

Пользователь создан на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/3.png)

Выведем secret_key для передачи в другой terraform для инфраструктуры
```
terraform output secret_key
```

2. Подключаем S3 для хранения стейт файла, создаем сети, инфраструктуру и генерируем host.yaml для Kubersray - [Infrastructure](https://github.com/garrkiss/diplom/tree/main/terraform/infrastructure)

Успешное выполнение terraform apply
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/infrastructure/1.png)

ВМ появились на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/infrastructure/2.png)

Создана сеть и подсети на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/infrastructure/3.png)

Появился tfstate в бакете
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/infrastructure/4.png)


### Создание Kubernetes кластера

1. Подготавливаем Kuberspray

```
git clone https://github.com/kubernetes-sigs/kubespray
sudo apt install python3-pip
source venv/bin/activate
cd kubespray/
pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
```
2. Вносим изменения в конфигурацию
   
- Включаем параметры в addons.yaml
```  
ingress_nginx_enabled: true
helm_enabled: true
````
- Включаем параметры в k8s-cluster.yaml
````
kubeconfig_localhost: true
````

3. Запускаем ansible-playbook
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/kuberspray/1.png)

Плейбук успешно отработал
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/kuberspray/2.png)

Копируем из каталога папки кластера admin.conf в .kube и проверяем командой kubectl get pods --all-namespaces
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/kuberspray/3.png)


### Создание тестового приложения

Запушил код в [Gitlab](https://gitlab.com/garrkiss/test-app)
В качестве Registy выбран [Docker hub](https://hub.docker.com/repository/docker/garrkiss/test-app)
![Скрин]https://github.com/garrkiss/diplom/blob/main/img/test-app/1.png


### Подготовка cистемы мониторинга и деплой приложения



### Установка и настройка CI/CD
