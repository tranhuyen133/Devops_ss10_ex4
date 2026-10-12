# Session 10 - Ex4: Custom Network & Named Volume

Kết nối Backend + PostgreSQL qua Custom Bridge Network và kiểm tra Data Persistence bằng Named Volume.

## Thành phần
- Network: `app-net` (bridge) — cho container giao tiếp qua tên service (DNS).
- Volume: `db-data` — lưu dữ liệu Postgres bền vững ngoài container.
- Containers: `db-server` (postgres:15-alpine), `app-container` (backend).

## Cách chạy
\`\`\`bash
chmod +x commands.sh
./commands.sh
\`\`\`

## Kiểm tra
\`\`\`bash
docker network ls | grep app-net
docker volume ls | grep db-data
docker exec -it app-container ping -c 2 db-server
\`\`\`

## Kết quả
- `ping db-server` từ backend phân giải thành công IP nội bộ của DB.
- Sau khi `docker rm -f db-server` rồi tạo lại container gắn cùng volume `db-data`,
  bảng `students` vẫn còn dữ liệu → chứng minh Data Persistence.
