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
```

- Edite o script e configure os dados no topo:
nano install_graylog_ssl.sh

Altere:
DOMAIN="graylog.seudominio.com.br"
EMAIL="seu@email.com"
ADMIN_PASS="admin123"

- Dê permissão e execute o script:
chmod +x install_graylog_ssl.sh
sudo ./install_graylog_ssl.sh

🌐 Acesso
Após a instalação, acesse via navegador:
- https://graylog.seudominio.com.br
- Usuário: admin
- Senha: definida na variável ADMIN_PASS

🛡️ Pós-instalação
- Altere a senha padrão imediatamente.
- Configure seus roteadores/firewalls para enviar logs via Syslog, GELF, etc.
- Acompanhe os logs em tempo real e crie Dashboards!

📚 Referências
- Documentação oficial Graylog
- OpenSearch
- MongoDB
- Certbot


## 🧑‍💻 Autor
**Vanderson Diniz do Nascimento**  
Especialista em Linux, Redes, Cibersegurança e ISPs  

- 🌐 [Site pessoal](https://vandersondiniz.com.br)  
- 🏢 [ISPLAB](https://isplab.com.br)  
- 💼 [LinkedIn](https://www.linkedin.com/in/vdnascdiniz/)  
- 💻 [GitHub @vandersondiniznoc](https://github.com/vandersondiniznoc)

📄 Licença
Este projeto está licenciado sob a MIT License.
