# Rocky Linux 9.4 Slim FastAPI Lightweight Container

このリポジトリは、Rocky Linux 9.4 minimalをベースにした軽量FastAPIアプリケーション実行コンテナの構成例です。

## 特徴

* Rocky Linux 9.4 minimalベースの超軽量構成
* 必要最低限のツール・ユーティリティ同梱（vi, nano, logrotate, wget, curl, procps, crond, postfix等）
* Oracle Instant Client組込済み
* Python 3.9 ＆ 主要パッケージ同梱
* Shift-JIS, EUC-JPエンコーディングに対応
* FastAPIアプリを `/app` ディレクトリで管理
* 起動時に環境変数`SMTP_SERVER`で外部SMTPサーバを指定可能（Postfixリレー）

---

## ディレクトリ構成例

```
.
├── Dockerfile
├── requirements.txt
├── startup.sh
└── app
    └── main.py
```

---

## ビルド方法

```sh
docker build -t my-lightweight-app .
```

---

## 起動方法

### シンプル起動

```sh
docker run -p 8000:8000 my-lightweight-app
```

### 外部SMTPリレー指定で起動（例）

```sh
docker run -e SMTP_SERVER=smtp.example.com -p 8000:8000 my-lightweight-app
```

---

## FastAPI 動作確認

以下のURLでアプリの疎通を確認できます。

* [http://localhost:8000/](http://localhost:8000/)
  → `{"message": "Hello, FastAPI running in container!"}`
* [http://localhost:8000/ping](http://localhost:8000/ping)
  → `{"result": "pong"}`

---

## カスタマイズポイント

* `/app` 配下に自由にFastAPIアプリ（モジュール、テンプレート等）を追加できます
* `requirements.txt` で必要なPythonパッケージを追記可能
* `startup.sh`の内容や起動プロセスも変更OK
* Oracle Instant Clientはライセンス・配布条件を守ってご利用ください

---

## 注意・補足

* vi（vim-minimal）・nano等は軽量エディタとして同梱
* logrotate、crond（cron）、postfix（SMTPリレー用）も含まれます
* 日本語エンコーディング（Shift-JIS, EUC-JP）はPython標準ライブラリで利用可

---

## ライセンス

Oracle Instant Client等の配布物は各ベンダーのライセンス条件を順守してください。

---
