# 🚀 TESTE NO RENDER - GUIA RÁPIDO

## 📍 Pré-requisitos

✅ Código já está no GitHub
✅ Deploy já foi feito no Render
✅ App está com status "live"

---

## 🎯 Opção 1: TESTE AUTOMATIZADO (Recomendado)

### Windows (PowerShell)

```powershell
# Execute o script completo
.\test_render.ps1

# Ou especifique a URL customizada
.\test_render.ps1 -AppUrl "https://seu-app.onrender.com"
```

### Linux/Mac (Bash)

```bash
chmod +x test_render.sh
./test_render.sh
# ou com URL customizada
./test_render.sh https://seu-app.onrender.com
```

**O script faz automaticamente:**
1. ✓ Registra 2 usuários (um comum, um admin)
2. ✓ Faz login de ambos
3. ✓ Cria produtos
4. ✓ Testa listagem (usuário vê só seus, admin vê tudo)
5. ✓ Atualiza produto
6. ✓ Testa erro (senha errada)

---

## 🎯 Opção 2: TESTE MANUAL (Passo a Passo)

### Windows (PowerShell)

#### 1️⃣ Registrar Usuário
```powershell
$APP_URL = "https://seu-app.onrender.com"

$response = Invoke-WebRequest -Uri "$APP_URL/api/auth/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "maria"
    password = "senha123"
    role = "user"
  } | ConvertTo-Json)

$response.Content
```

#### 2️⃣ Fazer Login
```powershell
$login = Invoke-WebRequest -Uri "$APP_URL/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "maria"
    password = "senha123"
  } | ConvertTo-Json)

$TOKEN = ($login.Content | ConvertFrom-Json).access_token
Write-Host "Token: $TOKEN"
```

#### 3️⃣ Criar Produto
```powershell
$product = Invoke-WebRequest -Uri "$APP_URL/api/products/" `
  -Method POST `
  -Headers @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $TOKEN"
  } `
  -Body (@{
    name = "Sensor de Umidade"
    description = "Mede umidade relativa"
    price = 149.99
  } | ConvertTo-Json)

$product.Content
```

#### 4️⃣ Listar Produtos
```powershell
$list = Invoke-WebRequest -Uri "$APP_URL/api/products/" `
  -Method GET `
  -Headers @{"Authorization" = "Bearer $TOKEN"}

$list.Content | ConvertFrom-Json | Format-List
```

---

### Linux/Mac (cURL)

#### 1️⃣ Registrar Usuário
```bash
curl -X POST https://seu-app.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username":"maria",
    "password":"senha123",
    "role":"user"
  }'
```

#### 2️⃣ Fazer Login
```bash
TOKEN=$(curl -s -X POST https://seu-app.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"maria","password":"senha123"}' | jq -r '.access_token')

echo "Token: $TOKEN"
```

#### 3️⃣ Criar Produto
```bash
curl -X POST https://seu-app.onrender.com/api/products/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name":"Sensor de Umidade",
    "description":"Mede umidade relativa",
    "price":149.99
  }'
```

#### 4️⃣ Listar Produtos
```bash
curl -H "Authorization: Bearer $TOKEN" \
  https://seu-app.onrender.com/api/products/ | jq '.'
```

---

## ✅ CHECKLIST DE VALIDAÇÃO

Depois de testar, verifique:

| Teste | Resultado | Status |
|-------|-----------|--------|
| Registrar usuário retorna 201 | | ✓ ou ✗ |
| Login retorna token | | ✓ ou ✗ |
| Criar produto retorna 201 | | ✓ ou ✗ |
| Listar produtos retorna 200 | | ✓ ou ✗ |
| Admin vê todos produtos | | ✓ ou ✗ |
| Usuário vê só seus produtos | | ✓ ou ✗ |
| Atualizar produto funciona | | ✓ ou ✗ |
| Senha errada retorna 401 | | ✓ ou ✗ |
| Sem token retorna 401 | | ✓ ou ✗ |

---

## 📊 RESPOSTAS ESPERADAS

### Registro (201)
```json
{
  "msg": "Usuário criado com sucesso"
}
```

### Login (200)
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Criar Produto (201)
```json
{
  "id": 1,
  "name": "Sensor IoT",
  "description": "...",
  "price": 199.99,
  "user_id": 1
}
```

### Listar Produtos (200)
```json
[
  {
    "id": 1,
    "name": "Sensor IoT",
    "price": 199.99,
    "user_id": 1
  }
]
```

---

## 🐛 TROUBLESHOOTING

| Problema | Solução |
|----------|---------|
| "Connection refused" | App não está live. Aguarde no Render |
| "app has no attribute 'app'" | Verifique app/__init__.py tem `app = create_app()` |
| "JWT token is invalid" | Verifique formato: `Bearer TOKEN` (com espaço) |
| "Unauthorized (401)" | Token expirado ou inválido, faça login novamente |
| Erro 500 | Verifique logs no Render Dashboard |

---

## 📝 PRÓXIMAS ETAPAS

Depois que tudo passar:

1. ✅ Documentar os testes que funcionaram
2. ✅ Verificar logs no Render Dashboard
3. ✅ Comunicar ao time que está pronto para produção
4. ✅ Configurar CI/CD para testes automáticos

---

## 🎓 REFERÊNCIA

- **TESTE_RENDER.md** - Guia completo com mais exemplos
- **test_render.ps1** - Script automatizado (PowerShell)
- **test_render.sh** - Script automatizado (Bash)

**Precisa de ajuda?** Verifique os logs em:
👉 Render Dashboard → seu app → Logs
