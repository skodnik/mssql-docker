include .env

start:
	docker container start ${CONTAINER_NAME}

stop:
	docker container stop ${CONTAINER_NAME}

create:
	docker run \
	  --env 'ACCEPT_EULA=Y' \
	  --env 'SA_PASSWORD=${SA_PASSWORD}' \
	  --env 'MSSQL_PID=Express' \
	  --publish 1433:1433 \
	  --volume ${CONTAINER_NAME}_data:/var/opt/mssql \
	  --name '${CONTAINER_NAME}' \
	  --detach \
	  ${FROM_IMAGE}

prepare:
	docker exec --interactive --tty ${CONTAINER_NAME} mkdir /var/opt/mssql/backup
	docker cp ${DB_BACKUP_FILE_NAME} ${CONTAINER_NAME}:/var/opt/mssql/backup
	docker exec --interactive --tty ${CONTAINER_NAME} /opt/mssql-tools/bin/sqlcmd \
	  -S localhost -U SA -P '${SA_PASSWORD}' \
	  -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/${DB_BACKUP_FILE_NAME}"' | tr -s ' ' | cut -d ' ' -f 1-2
	docker exec --interactive --tty ${CONTAINER_NAME} /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U SA -P '${SA_PASSWORD}' \
      -Q 'RESTORE DATABASE ${DB_NAME} FROM DISK = "/var/opt/mssql/backup/${DB_BACKUP_FILE_NAME}" WITH MOVE "${DB_NAME}" TO "/var/opt/mssql/data/${DB_BACKUP_FILE_NAME}.mdf", MOVE "${DB_NAME}_Log" TO "/var/opt/mssql/data/${DB_BACKUP_FILE_NAME}.ldf"'

show-c:
	docker ps --all --size
	docker volume ls

show-i:
	docker images --all

delete-c:
	docker container rm ${CONTAINER_NAME}
	docker volume rm ${CONTAINER_NAME}_data

delete-i:
	docker rmi --force ${FROM_IMAGE}