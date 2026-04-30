# 🔍 Guia de Logs no Render

## Acessar Logs em Tempo Real

### No Render Dashboard

1. Vá para https://dashboard.render.com
2. Clique no seu app **flask-iot-app**
3. Navegue para a aba **"Logs"**
4. Você verá os logs em tempo real

---

## 🟢 Sinais de SUCESSO

### Deploy Bem-Sucedido
```
==> Uploading build...
==> Uploaded in 6.4s
==> Build successful 🎉
==> Deploying...
==> Setting WEB_CONCURRENCY=1
==> Running 'gunicorn app:app'
```

### Servidor Rodando
```
[MASTER] Worker spawned (pid: 123)
[WORKER] Listening at: 0.0.0.0:10000 (123)
[WORKER] Using worker class: sync
```

### Requisição Bem-Sucedida
```
POST /api/auth/register HTTP/1.1 200
POST /api/auth/login HTTP/1.1 200
POST /api/products/ HTTP/1.1 201
GET /api/products/ HTTP/1.1 200
```

---

## 🔴 Sinais de ERRO

### ❌ Erro: "app has no attribute 'app'"
```
AttributeError: module 'app' has no attribute 'app'
gunicorn.errors.AppImportError: Failed to find attribute 'app' in 'app'
Exited with status 1
```

**Solução:**
- Verifique se `app/__init__.py` tem no final:
  ```python
  app = create_app()
  ```

### ❌ Erro: DATABASE_URL não encontrada
```
sqlalchemy.exc.ArgumentError: Could not parse rfc1738 URL
psycopg2.OperationalError: could not translate host name
```

**Solução:**
- Vá para Settings → Environment Variables
- Verifique se `DATABASE_URL` está configurada
- Formato: `postgresql://user:pass@host:5432/dbname`

### ❌ Erro: JWT_SECRET_KEY não encontrada
```
RuntimeError: The configuration key 'JWT_SECRET_KEY' is not set
```

**Solução:**
- Vá para Settings → Environment Variables
- Adicione `JWT_SECRET_KEY` com um valor aleatório
- Salve e reinicie o app

### ❌ Erro: Port já em uso
```
Address already in use
OSError: [Errno 48] Address in use: ('0.0.0.0', 10000)
```

**Solução:**
- Redeploy no Render
- Aguarde 2-3 minutos

---

## 📋 Logs Comuns e Seus Significados

### Build Phase
```
==> Building image...                    ✓ Começando build
==> Uploading build...                   ✓ Enviando para Render
Successfully installed package-1.0       ✓ Dependências instaladas
```

### Deployment Phase
```
==> Deploying...                         ✓ Iniciando deploy
Running 'gunicorn app:app'               ✓ Iniciando servidor
Worker spawned (pid: 123)                ✓ Worker pronto
Listening at: 0.0.0.0:10000             ✓ Aceita conexões
```

### Request Logs
```
POST /api/auth/register HTTP/1.1 201    ✓ Registro sucesso
POST /api/auth/login HTTP/1.1 200       ✓ Login sucesso
POST /api/products/ HTTP/1.1 201        ✓ Produto criado
GET /api/products/ HTTP/1.1 200         ✓ Listagem sucesso
GET /api/products/ HTTP/1.1 401         ⚠ Sem autorização
```

---

## 🔎 Filtrar Logs por Tipo

### Ver apenas ERROs
```
[ERROR]
[CRITICAL]
Traceback
Exception
```

### Ver apenas WARNINGs
```
[WARNING]
[WARN]
deprecated
```

### Ver logs de uma requisição específica
```
/api/auth/login
/api/products/
POST /api/
```

---

## 📊 Estrutura de um Log de Sucesso

Quando você faz uma requisição de sucesso, deve ver:

```
→ Requisição chega ao servidor
POST /api/auth/register HTTP/1.1
Content-Type: application/json
Content-Length: 65

← Servidor processa
Processing request...

← Resposta é enviada
HTTP/1.1 201 Created
Content-Type: application/json
Content-Length: 45

{"msg": "Usuário criado com sucesso"}
```

---

## 🚨 Como Diagnosticar Problemas

### Passo 1: Verificar se app está live
```
Status: Live ✓
```
Se não estiver live, algo falhou no build

### Passo 2: Verificar últimas linhas dos logs
```
[WORKER] Listening at: 0.0.0.0:10000 ✓
```
Se não aparecer, houve erro no startup

### Passo 3: Procurar por Exceptions
```
ctrl+f → "Traceback" ou "Exception"
```
Se encontrar, copie e pesquise a solução

### Passo 4: Verificar variáveis de ambiente
```
Settings → Environment Variables
Procure: DATABASE_URL, JWT_SECRET_KEY, SECRET_KEY
```

---

## 💾 Exportar Logs

Para salvar logs para análise posterior:

1. No Render Dashboard
2. Logs → (canto superior direito)
3. Clique em "Download" ou "Copy"
4. Cole em um arquivo .txt

---

## 🔄 Redeploying Quando há Problema

Se você fez uma mudança e quer testar:

1. Faça commit do código
2. Push para GitHub
3. No Render: Manual Deploy → "Deploy Latest Commit"
4. Acompanhe o build nos logs

---

## 📲 Monitoramento Contínuo

Para acompanhar a aplicação:

1. **Render CLI** (opcional)
   ```bash
   npm install -g render
   render logs <seu-app-id>
   ```

2. **Verificar periodicamente**
   - Acesse o dashboard
   - Procure por erros nos logs
   - Teste endpoints regularmente

---

## ✅ Checklist de Diagnóstico

| Passo | O que verificar | Status |
|-------|----------------|--------|
| 1 | Status do app é "live"? | ✓ ou ✗ |
| 2 | Build completou sem erro? | ✓ ou ✗ |
| 3 | Worker está listening? | ✓ ou ✗ |
| 4 | DATABASE_URL está configurada? | ✓ ou ✗ |
| 5 | JWT_SECRET_KEY está configurada? | ✓ ou ✗ |
| 6 | Requisições retornam 200/201? | ✓ ou ✗ |
| 7 | Nenhum erro 500 nos logs? | ✓ ou ✗ |

Se todos forem ✓, sua app está 100% funcional! 🎉
