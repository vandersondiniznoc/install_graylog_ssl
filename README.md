# 🔎 Graylog + SSL Installer for Debian 12

Este projeto fornece um script shell automatizado para instalar e configurar o **Graylog 5.x** com **SSL via Let's Encrypt**, além de todas as dependências necessárias, como:

- Java 17 (OpenJDK)
- MongoDB 6
- OpenSearch 2.x (compatível com Graylog)
- Graylog Server
- NGINX como proxy reverso com HTTPS automático

---

## 🚀 Funcionalidades

✅ Instalação 100% automatizada  
✅ Criação de senha de admin e hash SHA256  
✅ Proxy reverso com NGINX  
✅ SSL grátis via Let's Encrypt  
✅ Serviço iniciado automaticamente

---

## 🧰 Requisitos

- Sistema: **Debian 12**
- Acesso root (`sudo`)
- Domínio válido apontando para o servidor (ex: `graylog.seudominio.com.br`)
- Portas abertas:
  - `80` e `443` (NGINX/SSL)
  - `9000` (interna para Graylog)

---

## ⚙️ Instalação

1. Clone o repositório:

```bash
git clone https://github.com/vandersondiniznoc/graylog-debian12-ssl.git
cd graylog-debian12-ssl
