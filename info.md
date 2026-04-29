# Instruções para Setup Manual no Render

Este documento fornece instruções passo a passo para configurar manualmente o projeto IoT no Render, criando um Web Service e um banco de dados PostgreSQL, sem usar o arquivo `render.yaml`.

## Pré-requisitos
- Conta no Render (acesse [render.com](https://render.com) e faça login).
- Repositório GitHub com o código do projeto (certifique-se de que o repositório esteja público ou vinculado à sua conta Render).
- Conhecimento básico de PostgreSQL e Python.

## Passo 1: Criar o Banco de Dados PostgreSQL
1. Acesse o painel do Render em [dashboard.render.com](https://dashboard.render.com).
2. Clique em "New" > "PostgreSQL".
3. Configure o banco de dados:
   - **Name**: Escolha um nome único, como `iot-project-db`.
   - **Database**: Deixe como padrão ou defina como `iot_db`.
   - **User**: Deixe como padrão ou defina um nome de usuário.
   - **Region**: Escolha uma região próxima (ex.: US East).
   - Clique em "Create Database".
4. Aguarde a criação. Anote as credenciais fornecidas:
   - **Host**: Ex.: `dpg-xxxxxxx.render.com`
   - **Port**: Geralmente 5432.
   - **Database Name**: Ex.: `iot_db`
   - **Username**: Ex.: `iot_user`
   - **Password**: A senha gerada (guarde em um local seguro).
5. Após a criação, vá para a aba "Connections" no painel do banco e copie a **Internal Database URL** ou construa a string de conexão no formato:
   ```
   postgresql://username:password@host:port/database
   ```
   Exemplo: `postgresql://iot_user:senha123@dpg-xxxxxxx.render.com:5432/iot_db`

## Passo 2: Configurar o Banco de Dados (Executar Scripts SQL)
Antes de conectar a aplicação, você precisa executar os scripts SQL para inicializar o banco.

1. No painel do Render, vá para o seu banco PostgreSQL recém-criado.
2. Clique na aba "Query" ou use uma ferramenta externa como pgAdmin ou psql para conectar ao banco usando as credenciais acima.
3. Execute os scripts na ordem:
   - Primeiro, execute `scripts/init_db.sql` (cria tabelas básicas).
   - Depois, execute `scripts/setup_iot_db.sql` (configurações específicas do IoT).
   - Opcionalmente, execute `scripts/fix_permissions.sql` se houver problemas de permissões.
4. Verifique se as tabelas foram criadas corretamente (ex.: tabelas de usuários e produtos baseadas nos modelos em `app/models/`).

**Nota**: Se preferir, você pode executar esses scripts localmente usando uma ferramenta como psql ou pgAdmin, conectando-se ao banco Render via internet.

## Passo 3: Criar o Web Service
1. No painel do Render, clique em "New" > "Web Service".
2. Conecte ao repositório GitHub:
   - Selecione o repositório `iot_project` (ou o nome correto do seu repo).
   - Escolha a branch `main` (ou a branch desejada).
3. Configure o serviço:
   - **Name**: Ex.: `iot-project-web`.
   - **Environment**: Selecione "Python".
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `python run.py` (verifique se `run.py` é o ponto de entrada da aplicação; ajuste se necessário, ex.: `gunicorn app:app` se for Flask).
4. Defina as variáveis de ambiente:
   - Clique em "Environment" e adicione:
     - `DATABASE_URL`: Cole a string de conexão do PostgreSQL criada no Passo 1 (ex.: `postgresql://iot_user:senha123@dpg-xxxxxxx.render.com:5432/iot_db`).
     - Adicione outras variáveis necessárias, como chaves de API ou configurações específicas (verifique `config/config.py` para mais detalhes).
5. Clique em "Create Web Service".
6. Aguarde o deploy. O Render irá construir e iniciar a aplicação automaticamente.

## Passo 4: Verificar o Setup
1. Após o deploy, acesse a URL fornecida pelo Render (ex.: `https://iot-project-web.onrender.com`).
2. Teste a aplicação: Verifique se a conexão com o banco funciona (ex.: endpoints de autenticação e produtos em `app/controllers/`).
3. Monitore logs: No painel do Web Service, vá para "Logs" para verificar erros ou mensagens de inicialização.
4. Se houver problemas:
   - Verifique se a `DATABASE_URL` está correta.
   - Certifique-se de que os scripts SQL foram executados corretamente.
   - Ajuste comandos de build/start se necessário.

## Notas Adicionais
- **Custos**: Render cobra por uso de recursos. O plano gratuito inclui limites; upgrade se necessário.
- **Segurança**: Nunca exponha senhas ou chaves em código público. Use variáveis de ambiente.
- **Atualizações**: Para atualizar o código, faça push no GitHub; o Render fará deploy automático.
- **Alternativas**: Se preferir automação, considere usar o `render.yaml` fornecido no projeto para deploy blueprint.
- **Suporte**: Consulte a documentação do Render em [docs.render.com](https://docs.render.com) para mais detalhes.

Se encontrar problemas, forneça mais detalhes sobre erros nos logs.