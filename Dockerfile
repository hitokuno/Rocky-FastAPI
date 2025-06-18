FROM rockylinux/rockylinux:9.4-minimal

# 必要最低限のパッケージをインストール
RUN microdnf install -y epel-release && \
    microdnf install -y \
        python39 python3-pip python3-libs \
        nano vim-minimal logrotate wget curl procps-ng \
        postfix cronie \
        libaio unzip && \
    microdnf clean all && \
    rm -rf /var/cache/dnf /var/log/* /usr/share/doc/* /usr/share/man/* /usr/share/info/* /tmp/*

# 非rootユーザー作成
RUN useradd -m -u 1000 appuser

# Oracle Instant Client Basic インストール（URLは最新を要確認）
ENV ORACLE_IC_VERSION=21_13
RUN wget -q https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basic-linux.x64-21.13.0.0.0dbru.zip -O /tmp/ic.zip && \
    mkdir -p /opt/oracle && \
    unzip /tmp/ic.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_21_13 /opt/oracle/instantclient && \
    echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    rm -f /tmp/ic.zip

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient

# Pythonモジュール（requirements.txtで管理）
COPY requirements.txt /tmp/requirements.txt
RUN python3.9 -m pip install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt

# アプリおよび起動スクリプトを配置
WORKDIR /app
COPY app /app

# startup.shを配置＆実行権限
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh && chown -R appuser:appuser /app /startup.sh

# rootユーザー
USER root

EXPOSE 8000

ENTRYPOINT ["/startup.sh"]
