#!/bin/bash
set -e

# Postfix外部リレー先指定（環境変数SMTP_SERVERがセットされていればmain.cfを書き換え）
if [ -n "$SMTP_SERVER" ]; then
    postconf -e "relayhost = [$SMTP_SERVER]"
fi

# postfix & cron 起動
/usr/sbin/postfix start
/usr/sbin/crond

# FastAPI起動
exec su appuser -c "uvicorn main:app --host 0.0.0.0 --port 8000"
