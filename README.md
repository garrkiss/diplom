# Дипломный практикум в Yandex.Cloud - `Бакулев Евгений`

### Создание облачной инфраструктуры

1. Создаем пользователя, навешиваем права, создаем бакет для Terraform - [Backend](https://github.com/garrkiss/diplom/tree/main/terraform/backend)

![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/1.png)

Бакет появился на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/1.png)

Пользователь создан на Yandex Cloud
![Скрин](https://github.com/garrkiss/diplom/blob/main/img/backend/1.png)

Выведем secret_key для передачи в другой terraform для инфраструктуры
```
terraform output secret_key
```

2. Подключаем S3 для хранения стейт файла, создаем сеть, инфраструктуру - [Backend](https://github.com/garrkiss/diplom/tree/main/terraform/backend)


[Файл]() 


Созданный ключ KMS
![Скрин]()

Скриншот открытия страницы
![Скрин]()


### Создание Kubernetes кластера



### Создание тестового приложения



### Подготовка cистемы мониторинга и деплой приложения



### Установка и настройка CI/CD
