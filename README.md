# Создание MSSQL сервера с импортированным бэкапом базы в Docker в Linux (Ubuntu 20.04)

Для удобства использования команды докера оформлены в make. Запуск команд осуществляется из директории проекта или глобально при определении алиасов.

## Подготовка окружения
Установка зависимостей
```
# apt install make docker.io
```

Клонирование репозитория
```
$ git clone git@github.com:skodnik/mssql-docker.git mssql-docker
```

### Определение переменных
```
$ cd mssql-docker
$ cp .env.example .env
```

Имя будущего контейнера, имя файла бекапа базы и прочие переменные необходимо определить в '.env'.
```
$ vi .env 
```

## Работа с контейнером
### Создание чистого контейнера
```
# make create
```

### Подготовка контейнера - импорт базы данных из файла бэкапа
Файл бэкапа базы данный MSSQL необходимо разместить в текущей директории проекта.
```
# make prepare
```

Пример вывода при успехе
```
.....
Database 'DB_name' running the upgrade step from version 865 to version 866.
Database 'DB_name' running the upgrade step from version 866 to version 867.
Database 'DB_name' running the upgrade step from version 867 to version 868.
Database 'DB_name' running the upgrade step from version 868 to version 869.
RESTORE DATABASE successfully processed 1144130 pages in 69.147 seconds (129.268 MB/sec).

```

При отсутствии ошибок база доступна на `localhost:1433`, пользователь `SA`, пароль из `.env`

### Остановка контейнера
```
# make stop
```

### Запуск контейнера
```
# make start
```

### Удаление контейнера и его тома
```
# make stop
# make delete-c
```

### Удаление образа
```
# make delete-i
```
