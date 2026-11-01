#!/bin/bash
# Резервное копирование Redmine: база данных, файлы вложений, конфигурация.
# Запуск: вручную или по расписанию cron (ежесуточно в 02:30).
set -euo pipefail

REDMINE_DIR=/home/redmine/redmine-4.0.6
BACKUP_ROOT=/home/redmine/backup      # при необходимости — точка монтирования каталога другой ЭВМ (/etc/fstab)
DB_HOST=127.0.0.1
DB_NAME=redmine
DB_USER=redmine                       # пароль берётся из /root/.pgpass
KEEP=7                                # сколько последних копий хранить

STAMP=$(date +%Y-%m-%d_%H-%M)
DEST="$BACKUP_ROOT/$STAMP"
mkdir -p "$DEST/config"

# 1. Дамп базы данных PostgreSQL в формате custom (восстановление — pg_restore)
pg_dump -h "$DB_HOST" -U "$DB_USER" -Fc -f "$DEST/redmine_db.dump" "$DB_NAME"

# 2. Пользовательские файлы (вложения задач, документов, wiki)
rsync -a --delete "$REDMINE_DIR/files/" "$DEST/files/"

# 3. Конфигурация приложения и веб-сервера
rsync -a "$REDMINE_DIR/config/database.yml" "$REDMINE_DIR/config/initializers/secret_token.rb" \
         /etc/apache2/sites-available/master.conf "$DEST/config/" 2>/dev/null || true

# 4. Ротация: удаляем копии старше KEEP последних
ls -1dt "$BACKUP_ROOT"/20* | tail -n +$((KEEP + 1)) | xargs -r rm -rf

echo "[$(date '+%F %T')] резервная копия создана: $DEST ($(du -sh "$DEST" | cut -f1))" | tee -a "$BACKUP_ROOT/backup.log"
