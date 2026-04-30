# Guia de Teste Manual no Render

## 📱 Passos para Testar no Render

### 1️⃣ Verificar o Deploy

Acesse o **Render Dashboard**:
- URL: https://dashboard.render.com
- Procure por seu app **flask-iot-app**
- Verifique o status: deve estar **"live"** e em verde ✅

### 2️⃣ Obter a URL da Aplicação

No dashboard do Render, você verá algo como:
```
https://flask-iot-app-xxxxx.onrender.com
```

Salve essa URL como: `$APP_URL`

---

## 🧪 Testes com cURL

Abra um terminal PowerShell e execute os comandos abaixo:

### A. REGISTRAR UM NOVO USUÁRIO

```powershell
$APP_URL = "https://seu-app.onrender.com"  # Substitua pela sua URL

$response = Invoke-WebRequest -Uri "$APP_URL/api/auth/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "joao"
    password = "senha123"
    role = "user"
  } | ConvertTo-Json)

$response.Content | ConvertFrom-Json | Format-List
```

**Resposta esperada:**
```json
{
  "msg": "Usuário criado com sucesso"
}
```

---

### B. FAZER LOGIN

```powershell
$loginResponse = Invoke-WebRequest -Uri "$APP_URL/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "joao"
    password = "senha123"
  } | ConvertTo-Json)

$loginData = $loginResponse.Content | ConvertFrom-Json
$TOKEN = $loginData.access_token

Write-Host "Token obtido: $TOKEN"
```

**Resposta esperada:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

---

### C. CRIAR UM PRODUTO

```powershell
$productResponse = Invoke-WebRequest -Uri "$APP_URL/api/products/" `
  -Method POST `
  -Headers @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $TOKEN"
  } `
  -Body (@{
    name = "Sensor IoT"
    description = "Sensor de temperatura e umidade"
    price = 199.99
  } | ConvertTo-Json)

$productResponse.Content | ConvertFrom-Json | Format-List
```

**Resposta esperada:**
```json
{
  "id": 1,
  "name": "Sensor IoT",
  "description": "Sensor de temperatura e umidade",
  "price": 199.99,
  "user_id": 1
}
```

---

### D. LISTAR PRODUTOS

```powershell
$listResponse = Invoke-WebRequest -Uri "$APP_URL/api/products/" `
  -Method GET `
  -Headers @{"Authorization" = "Bearer $TOKEN"}

$listResponse.Content | ConvertFrom-Json | Format-List
```

**Resposta esperada:**
```json
[
  {
    "id": 1,
    "name": "Sensor IoT",
    "description": "Sensor de temperatura e umidade",
    "price": 199.99,
    "user_id": 1
  }
]
```

---

### E. CRIAR OUTRO USUÁRIO (ADMIN)

```powershell
$adminResponse = Invoke-WebRequest -Uri "$APP_URL/api/auth/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "admin"
    password = "admin123"
    role = "admin"
  } | ConvertTo-Json)

$adminResponse.Content | ConvertFrom-Json | Format-List
```

---

### F. LOGIN COMO ADMIN

```powershell
$adminLoginResponse = Invoke-WebRequest -Uri "$APP_URL/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{
    username = "admin"
    password = "admin123"
  } | ConvertTo-Json)

$adminLoginData = $adminLoginResponse.Content | ConvertFrom-Json
$ADMIN_TOKEN = $adminLoginData.access_token

Write-Host "Token Admin: $ADMIN_TOKEN"
```

---

### G. ADMIN VÊ TODOS OS PRODUTOS

```powershell
$adminListResponse = Invoke-WebRequest -Uri "$APP_URL/api/products/" `
  -Method GET `
  -Headers @{"Authorization" = "Bearer $ADMIN_TOKEN"}

$adminListResponse.Content | ConvertFrom-Json | Format-List
```

**Resposta esperada:** Lista todos os produtos de todos os usuários!

---

### H. ATUALIZAR PRODUTO

```powershell
$updateResponse = Invoke-WebRequest -Uri "$APP_URL/api/products/1" `
  -Method PUT `
  -Headers @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $TOKEN"
  } `
  -Body (@{
    name = "Sensor IoT V2"
    description = "Versão melhorada"
    price = 249.99
  } | ConvertTo-Json)

$updateResponse.Content | ConvertFrom-Json | Format-List
```

---

## 📋 Checklist de Teste

| Teste | Comando | Status |
|-------|---------|--------|
| 1. Registrar usuário | Teste A | ✓ |
| 2. Fazer login | Teste B | ✓ |
| 3. Criar produto | Teste C | ✓ |
| 4. Listar produtos | Teste D | ✓ |
| 5. Admin vê tudo | Teste G | ✓ |
| 6. Atualizar produto | Teste H | ✓ |

---

## ⚠️ Tratamento de Erros

### Erro: "Failed to connect"
- Verifique se o app está em estado "live" no Render
- Espere 1-2 minutos após o deploy

### Erro: "AttributeError: module 'app' has no attribute 'app'"
- ❌ Significa que a correção não foi aplicada
- Solução: Verifique se `app/__init__.py` tem `app = create_app()` no final

### Erro: "JWT token is invalid"
- Verifique o format do header: `"Authorization": "Bearer TOKEN"`
- Espaço entre "Bearer" e o token é obrigatório

### Erro: "DATABASE_URL not found"
- Verifique se as variáveis de ambiente estão configuradas no Render
- No Render Dashboard → Settings → Environment Variables

---

## 🔍 Monitorar Logs em Tempo Real

No Render Dashboard:
1. Selecione seu app
2. Vá para "Logs"
3. Filtre por:
   - `ERROR` - erros críticos
   - `WARNING` - avisos
   - `POST /api/auth` - requisições de autenticação

---

## ✅ Sinais de Sucesso

- ✅ Status do app é "live"
- ✅ Registro de usuário retorna 201
- ✅ Login retorna token válido
- ✅ Produtos podem ser criados
- ✅ Admin vê todos os produtos
- ✅ Usuário comum vê apenas seus produtos
- ✅ Sem erros 500 nos logs

---

## 🚀 Próximas Etapas

Se tudo passar:
1. ✅ Documentar resultados
2. ✅ Notificar stakeholders
3. ✅ Configurar monitoramento
4. ✅ Planejar melhorias futuras
