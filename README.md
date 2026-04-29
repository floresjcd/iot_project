# Mini-Projeto: Sistema Web Flask com CRUD, Autenticação JWT e Deploy no Render

## Descrição do Projeto

Este mini-projeto consiste em um sistema web desenvolvido com Flask, seguindo o padrão arquitetural MVC (Model–View–Controller). Ele oferece um CRUD (Create, Read, Update, Delete) completo para gerenciamento de registros (neste caso, produtos), autenticação de usuários com JWT (JSON Web Tokens), autorização baseada em roles (Admin e Usuário Comum), persistência de dados utilizando SQLAlchemy com PostgreSQL, e está configurado para implantação na nuvem através da plataforma Render.

O objetivo é demonstrar a construção de uma aplicação web robusta e escalável, abordando conceitos essenciais de desenvolvimento de software e práticas de deploy.

## Funcionalidades Principais

1.  **CRUD Completo para Produtos**: Permite criar, listar, editar e excluir registros de produtos.
2.  **Autenticação de Usuários**: 
    *   Criação de conta.
    *   Login de usuários com senhas armazenadas via hashing seguro (Werkzeug).
    *   Geração de um token JWT após autenticação bem-sucedida.
3.  **Autorização Baseada em Roles**: 
    *   **Admin**: Pode criar, editar e excluir todos os produtos.
    *   **Usuário Comum**: Pode apenas visualizar e editar seus próprios produtos.
4.  **Padrão MVC**: 
    *   **Models**: Classes Python (`User`, `Product`) que representam tabelas do banco de dados usando Flask-SQLAlchemy.
    *   **Views**: Respostas em formato JSON para todas as requisições da API.
    *   **Controllers**: Rotas Flask que gerenciam a lógica de negócio, interagem com os models e retornam as views (JSON).
5.  **Persistência de Dados**: Utiliza Flask-SQLAlchemy para mapeamento objeto-relacional com um banco de dados PostgreSQL.
6.  **Deploy na Nuvem**: Configurado para implantação automatizada na plataforma Render, incluindo a configuração de um banco de dados PostgreSQL gerenciado.

## Estrutura do Projeto e Descrição dos Arquivos

```
iot_project/
├── app/
│   ├── __init__.py         # Inicializa o aplicativo Flask, configura SQLAlchemy e JWT, e registra os blueprints dos controllers.
│   ├── controllers/
│   │   ├── __init__.py    # Torna 'controllers' um pacote Python.
│   │   ├── auth_controller.py    # Define as rotas para registro e login de usuários, gerando tokens JWT.
│   │   └── product_controller.py # Define as rotas para operações CRUD de produtos, incluindo controle de acesso por role.
│   ├── models/
│   │   ├── __init__.py    # Torna 'models' um pacote Python e importa os modelos User e Product.
│   │   ├── user.py             # Define o modelo `User` para o banco de dados, incluindo hashing de senha e roles.
│   │   └── product.py          # Define o modelo `Product` para o banco de dados.
│   └── views/                  # (Neste projeto, as 
views são JSON, então esta pasta está vazia, mas seria usada para templates HTML em um projeto com frontend tradicional.)
│       └── __init__.py    # Torna 'views' um pacote Python.
├── config/
│   └── config.py           # Contém a classe `Config` para gerenciar as configurações da aplicação, como chaves secretas e URI do banco de dados.
├── scripts/
│   └── init_db.sql         # Um script SQL opcional para criar as tabelas `users` e `products` manualmente no PostgreSQL.
├── .env                    # Arquivo para armazenar variáveis de ambiente localmente, como chaves secretas e a URL do banco de dados.
├── requirements.txt        # Lista todas as dependências Python necessárias para o projeto.
├── run.py                  # O ponto de entrada principal da aplicação Flask, responsável por criar e executar o aplicativo.
└── render.yaml             # Arquivo de configuração para o deploy automatizado da aplicação e do banco de dados no Render.
└── README.md               # Este arquivo, contendo a documentação completa do projeto.
```

## Configuração do Ambiente Local

### Pré-requisitos

Antes de começar, certifique-se de ter os seguintes softwares instalados:

*   **Python 3.8+**
*   **pip** (gerenciador de pacotes Python)
*   **PostgreSQL** (servidor de banco de dados)
*   **git** (para clonar o repositório)
*   **Visual Studio Code** (ou sua IDE preferida)

### Passos para Instalação e Execução

1.  **Clone o repositório (se aplicável)**:
    ```bash
    git clone <URL_DO_SEU_SEU_REPOSITORIO>
    cd iot_project
    ```

2.  **Crie e ative um ambiente virtual**:
    É altamente recomendável usar um ambiente virtual para isolar as dependências do projeto.
    ```bash
    python  -m venv venv
    source venv/bin/activate  # No Windows: .\venv\Scripts\activate
    ```

3.  **Instale as dependências**:
    ```bash
    pip install -r requirements.txt
    ```

4.  **Configure o banco de dados PostgreSQL**:
    *   Crie o banco de dados `iot_db`.
    *   Crie o usuário `bloguser` com senha e conceda as permissões necessárias.

    No pgAdmin, abra o Query Tool e execute os comandos abaixo:

    ```sql
    -- Cria o usuário bloguser
    CREATE ROLE bloguser WITH LOGIN PASSWORD '123456';

    -- Cria o database iot_db com owner bloguser
    CREATE DATABASE iot_db
        OWNER bloguser
        ENCODING 'UTF8'
        LC_COLLATE = 'C'
        LC_CTYPE = 'C'
        TEMPLATE template0;

    -- Concede permissões de uso e criação no schema public
    \c iot_db

    GRANT USAGE ON SCHEMA public TO bloguser;
    GRANT CREATE ON SCHEMA public TO bloguser;

    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bloguser;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bloguser;

    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bloguser;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bloguser;
    ```

    *   **Alternativa**: use o arquivo `scripts/setup_iot_db.sql`, que contém o mesmo script de criação do banco e do usuário.
    *   O SQLAlchemy criará automaticamente as tabelas `users` e `products` na primeira execução, se elas ainda não existirem.

5.  **Configure as variáveis de ambiente**:
    Crie um arquivo `.env` na raiz do projeto (`iot_project/.env`) com o seguinte conteúdo, substituindo os valores pelos seus:
    ```ini
    SECRET_KEY=sua_chave_secreta_aqui_gerada_aleatoriamente
    JWT_SECRET_KEY=sua_chave_jwt_secreta_aqui_gerada_aleatoriamente
    DATABASE_URL=postgresql://seu_usuario:sua_senha@localhost:5432/iot_db
    ```
    *   `SECRET_KEY`: Uma string longa e aleatória para segurança do Flask.
    *   `JWT_SECRET_KEY`: Uma string longa e aleatória para assinar os tokens JWT.
    *   `DATABASE_URL`: A URL de conexão com o seu banco de dados PostgreSQL local.

6.  **Execute a aplicação Flask**:
    ```bash
    python run.py
    ```
    A aplicação estará disponível em `http://127.0.0.1:5000`.

## Uso da API (Endpoints)

Todos os endpoints retornam JSON.

### Autenticação

*   **`POST /api/auth/register`**
    *   **Corpo da Requisição**: `{"username": "novo_usuario", "password": "senha_segura", "role": "user"}` (role pode ser "admin" ou "user")
    *   **Resposta**: `{"msg": "Usuário criado com sucesso"}`

*   **`POST /api/auth/login`**
    *   **Corpo da Requisição**: `{"username": "usuario_existente", "password": "senha_correta"}`
    *   **Resposta**: `{"access_token": "seu_token_jwt_aqui"}`

### Produtos (Requer Token JWT no cabeçalho `Authorization: Bearer <token>`)

*   **`POST /api/products/`**
    *   **Corpo da Requisição**: `{"name": "Produto X", "description": "Descrição do Produto X", "price": 99.99}`
    *   **Resposta**: Dados do produto criado.
    *   **Autorização**: Admin ou Usuário Comum (cria produto associado ao seu `user_id`).

*   **`GET /api/products/`**
    *   **Resposta**: Lista de todos os produtos (Admin) ou apenas os produtos do usuário logado (Usuário Comum).
    *   **Autorização**: Admin ou Usuário Comum.

*   **`PUT /api/products/<id>`**
    *   **Corpo da Requisição**: `{"name": "Novo Nome", "price": 120.00}` (campos opcionais)
    *   **Resposta**: Dados do produto atualizado.
    *   **Autorização**: Admin (qualquer produto) ou Usuário Comum (apenas seus próprios produtos).

*   **`DELETE /api/products/<id>`**
    *   **Resposta**: `{"msg": "Produto excluído"}`
    *   **Autorização**: Admin (qualquer produto) ou Usuário Comum (apenas seus próprios produtos).


### Testando a API no Postman  
Uma API que utiliza autenticação JWT requer alguns passos específicos no Postman, pois você precisa obter um token e depois enviá-lo nas requisições subsequentes.

qui está o roteiro de testes para o mini-projeto:

### 1. Criar um novo Usuário (Register)
Primeiro, vamos criar uma conta para poder logar.
- **Método**: `POST`
- **URL**: `http://127.0.0.1:5000/api/auth/register`
- **Aba Body**: Selecione `raw` e mude o formato para `JSON`.
- **Conteúdo**:
```json
{
    "username": "jose_flores",
    "password": "senha123",
    "role": "admin"
}
```
- Clique em **Send**. Você deve receber: `{"msg": "Usuário criado com sucesso"}`.

---

### 2. Fazer Login e Obter o Token
Agora vamos autenticar para receber o token de acesso.
- **Método**: `POST`
- **URL**: `http://127.0.0.1:5000/api/auth/login`
- **Aba Body**: `raw` / `JSON`
- **Conteúdo**:
```json
{
    "username": "jose_flores",
    "password": "senha123"
}
```
- Clique em **Send**. 
- **IMPORTANTE**: Copie o valor da chave `access_token` que aparecerá na resposta (uma string longa).

---

### 3. Criar um Produto (Requer Token)
Agora vamos testar o CRUD. Como este endpoint é protegido, precisamos enviar o token.
- **Método**: `POST`
- **URL**: `http://127.0.0.1:5000/api/products/`
- **Aba Authorization**:
    - **Type**: Selecione `Bearer Token`.
    - **Token**: Cole o token que você copiou no passo anterior.
- **Aba Body**: `raw` / `JSON`
- **Conteúdo**:
```json
{
    "name": "Sensor de Umidade DHT22",
    "description": "Sensor para projetos de IoT",
    "price": 45.50
}
```
- Clique em **Send**.

---

### 4. Listar Produtos
- **Método**: `GET`
- **URL**: `http://127.0.0.1:5000/api/products/`
- **Aba Authorization**: Certifique-se de que o `Bearer Token` ainda está lá.
- Clique em **Send**. Você verá a lista de produtos em JSON.

---

### 5. Atualizar ou Excluir
- **Para Atualizar (`PUT`)**: Use a URL `http://127.0.0.1:5000/api/products/1` (substitua o `1` pelo ID real do produto) e envie o novo JSON no Body.
- **Para Excluir (`DELETE`)**: Use a URL `http://127.0.0.1:5000/api/products/1`.

---

### 6. Testar Autorização (Role)
Para testar a diferença entre **Admin** e **User**:
1.  Crie um novo usuário com `"role": "user"`.
2.  Faça login com esse novo usuário e pegue o **novo token**.
3.  Tente listar os produtos: Você verá que ele só enxerga os produtos que ele mesmo criou.
4.  Tente deletar um produto criado pelo Admin: O sistema deve retornar um erro de **"Não autorizado"** (403).    

## Deploy no Render

O projeto está configurado para deploy contínuo no Render usando o arquivo `render.yaml`.

### Passos para Deploy

1.  **Crie uma conta no Render**: Se você ainda não tem uma, crie uma conta em [render.com](https://render.com/).

2.  **Conecte seu repositório Git**: Conecte seu repositório GitHub/GitLab ao Render.

3.  **Crie um novo Blueprint**: No dashboard do Render, selecione "New" -> "Blueprint" e aponte para o seu repositório.

4.  **Configuração Automática**: O Render detectará o arquivo `render.yaml` e configurará automaticamente um serviço web (Flask) e um banco de dados PostgreSQL.

5.  **Variáveis de Ambiente**: O `render.yaml` já configura as variáveis `DATABASE_URL`, `SECRET_KEY` e `JWT_SECRET_KEY` automaticamente. A `DATABASE_URL` será preenchida com a string de conexão do banco de dados PostgreSQL criado no Render, e as chaves secretas serão geradas automaticamente.

6.  **Deploy**: O Render iniciará o processo de build e deploy. Após a conclusão, sua aplicação estará online.

## Considerações de Segurança

*   **Hashing de Senhas**: As senhas dos usuários são armazenadas usando `werkzeug.security.generate_password_hash`, garantindo que as senhas em texto claro nunca sejam salvas no banco de dados.
*   **Tokens JWT**: Os tokens JWT são usados para autenticação e autorização, com chaves secretas geradas para garantir a integridade e confidencialidade dos tokens.
*   **Variáveis de Ambiente**: Chaves secretas e credenciais de banco de dados são gerenciadas via variáveis de ambiente, evitando que sejam expostas diretamente no código-fonte.


## Autor

José Carlos Flores

Curso de Especialização em Internet das Coisas (IoT)

## Licença

Projeto desenvolvido para fins acadêmicos (IFRO - IoT).

---
