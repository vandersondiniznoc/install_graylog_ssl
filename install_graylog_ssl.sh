#!/bin/bash
set -e

# ========== CONFIG ==========
DOMAIN="graylog.seudominio.com.br"
EMAIL="seu@email.com"
ADMIN_PASS="admin123"  # Altere depois
# ============================

echo "🔧 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalando dependências..."
sudo apt install -y apt-transport-https openjdk-17-jre-headless uuid-runtime pwgen curl gnupg2 wget nginx certbot python3-certbot-nginx gnupg lsb-release

echo "🧩 Instalando MongoDB..."
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update && sudo apt install -y mongodb-org
sudo systemctl enable mongod --now

echo "📦 Instalando OpenSearch (Graylog compatível)"
wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.tar.gz
tar -xzf opensearch-2.11.1-linux-x64.tar.gz
sudo mv opensearch-2.11.1 /opt/opensearch
sudo useradd -r -s /bin/false opensearch
sudo chown -R opensearch:opensearch /opt/opensearch

# Criar service systemd
cat <<EOF | sudo tee /etc/systemd/system/opensearch.service
[Unit]
Description=OpenSearch
After=network.target

[Service]
Type=simple
User=opensearch
Group=opensearch
ExecStart=/opt/opensearch/bin/opensearch
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable opensearch.service
sudo systemctl start opensearch.service

echo "📦 Instalando Graylog"
wget https://packages.graylog2.org/repo/packages/graylog-5.2-repository_latest.deb
sudo dpkg -i graylog-5.2-repository_latest.deb
sudo apt update && sudo apt install graylog-server -y

echo "🔐 Gerando senha secreta e hash"
SECRET=$(pwgen -N 1 -s 96)
HASH=$(echo -n "$ADMIN_PASS" | sha256sum | awk '{print $1}')

sudo sed -i "s/password_secret =.*/password_secret = $SECRET/" /etc/graylog/server/server.conf
sudo sed -i "s/root_password_sha2 =.*/root_password_sha2 = $HASH/" /etc/graylog/server/server.conf
sudo sed -i "s/#http_bind_address = 127.0.0.1:9000/http_bind_address = 127.0.0.1:9000/" /etc/graylog/server/server.conf
sudo sed -i "s/#http_external_uri =/http_external_uri = https:\/\/$DOMAIN\//" /etc/graylog/server/server.conf

sudo systemctl enable graylog-server
sudo systemctl start graylog-server

echo "🌐 Configurando NGINX com Let's Encrypt SSL..."
cat <<EOF | sudo tee /etc/nginx/sites-available/graylog
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/graylog /etc/nginx/sites-enabled/graylog
sudo nginx -t && sudo systemctl reload nginx

echo "🔒 Gerando certificado SSL com Certbot..."
sudo certbot --nginx --non-interactive --agree-tos -d "$DOMAIN" -m "$EMAIL"

echo "✅ Finalizado!"
echo "Acesse: https://$DOMAIN"
echo "Login: admin | Senha: $ADMIN_PASS"
