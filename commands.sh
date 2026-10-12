#!/bin/bash
set -e

echo "===== 1. Tạo custom bridge network ====="
docker network create app-net

echo "===== 2. Tạo named volume ====="
docker volume create db-data

echo "===== 3. Chạy DB container (postgres) ====="
docker run -d \
  --name db-server \
  --network app-net \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=appdb \
  -v db-data:/var/lib/postgresql/data \
  postgres:15-alpine

echo "Chờ Postgres khởi động..."
sleep 10

echo "===== 4. Chạy Backend container tham gia app-net ====="
docker run -d \
  --name app-container \
  --network app-net \
  -e DB_HOST=db-server \
  -e DB_PORT=5432 \
  -p 8082:3000 \
  hw-backend:v1

echo "===== 5. Thêm dữ liệu vào DB ====="
docker exec db-server psql -U postgres -d appdb -c "CREATE TABLE students(id SERIAL, name TEXT);"
docker exec db-server psql -U postgres -d appdb -c "INSERT INTO students(name) VALUES ('Huyen');"
docker exec db-server psql -U postgres -d appdb -c "SELECT * FROM students;"

echo "===== 6. Xóa CỨNG container DB ====="
docker rm -f db-server

echo "===== 7. Tạo lại DB container mới, gắn CÙNG volume db-data ====="
docker run -d \
  --name db-server \
  --network app-net \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=appdb \
  -v db-data:/var/lib/postgresql/data \
  postgres:15-alpine
sleep 10

echo "===== 8. Xác minh dữ liệu còn nguyên sau khi tái tạo ====="
docker exec db-server psql -U postgres -d appdb -c "SELECT * FROM students;"
