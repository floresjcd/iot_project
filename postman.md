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
