# Развёртывание СУП Redmine для проекта

Redmine 4.0.6, PostgreSQL 12, Apache 2.4 + Phusion Passenger, Ubuntu 20.04 LTS.

| Файл | Назначение |
|------|------------|
| `master.conf` | виртуальный хост Apache `proj.ru`, Redmine по адресу `/redmine` |
| `database.yml.example` | шаблон подключения к БД (без пароля) |
| `backup_redmine.sh` | резервное копирование: `pg_dump` + `rsync`, хранится 7 копий |

Расписание резервного копирования (cron): `30 2 * * * /home/redmine/backup_redmine.sh`.
