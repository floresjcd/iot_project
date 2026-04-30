```
╔══════════════════════════════════════════════════════════════╗
║                   TESTE NO RENDER - RESUMO                   ║
║                                                               ║
║  Você tem 3 formas de testar:                               ║
║  1. Script Automatizado (MAIS FÁCIL) ⭐                       ║
║  2. PowerShell Manual                                        ║
║  3. cURL Manual                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 🚀 OPÇÃO 1: SCRIPT AUTOMATIZADO (Recomendado)

### Para Windows:
```powershell
.\test_render.ps1
```

### Para Linux/Mac:
```bash
./test_render.sh
```

✅ Faz TUDO automaticamente:
- Registra 2 usuários
- Faz login
- Cria 2 produtos
- Testa permissões
- Mostra resultados

---

## 🎯 OPÇÃO 2: TESTE MANUAL RÁPIDO

### 1. Registrar:
```powershell
Invoke-WebRequest -Uri "https://seu-app.onrender.com/api/auth/register" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{username="joao";password="123";role="user"} | ConvertTo-Json)
```

### 2. Login:
```powershell
$r = Invoke-WebRequest -Uri "https://seu-app.onrender.com/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body (@{username="joao";password="123"} | ConvertTo-Json)
$TOKEN = ($r.Content | ConvertFrom-Json).access_token
```

### 3. Criar Produto:
```powershell
Invoke-WebRequest -Uri "https://seu-app.onrender.com/api/products/" `
  -Method POST `
  -Headers @{
    "Content-Type"="application/json"
    "Authorization"="Bearer $TOKEN"
  } `
  -Body (@{name="Sensor";description="Test";price=99.99} | ConvertTo-Json)
```

### 4. Listar Produtos:
```powershell
Invoke-WebRequest -Uri "https://seu-app.onrender.com/api/products/" `
  -Method GET `
  -Headers @{"Authorization"="Bearer $TOKEN"}
```

---

## 📊 RESPOSTAS ESPERADAS

✅ **Registrar** → Status: 201
```json
{"msg": "Usuário criado com sucesso"}
```

✅ **Login** → Status: 200
```json
{"access_token": "eyJ0eXAi..."}
```

✅ **Criar Produto** → Status: 201
```json
{"id": 1, "name": "Sensor", "price": 99.99, "user_id": 1}
```

✅ **Listar Produtos** → Status: 200
```json
[{"id": 1, "name": "Sensor", "price": 99.99}]
```

---

## ⚠️ SE ALGO DER ERRADO

| Erro | Causa | Solução |
|------|-------|---------|
| Connection refused | App offline | Aguarde no Render |
| app has no attribute | Código errado | ✓ Já foi corrigido |
| JWT invalid | Token ruim | Faça login novamente |
| 500 error | Bug no servidor | Ver logs do Render |

---

## 🔍 VERIFICAR LOGS

1. Acesse: https://dashboard.render.com
2. Clique no seu app
3. Tab "Logs"
4. Procure por:
   - ✓ "Listening at: 0.0.0.0" = OK
   - ✗ "Traceback" = ERRO
   - ✗ "Exited with status 1" = FALHOU

---

## 📝 DOCUMENTAÇÃO COMPLETA

- **TESTE_RENDER_RAPIDO.md** - Guia rápido (este arquivo)
- **TESTE_RENDER.md** - Guia completo com mais exemplos
- **GUIA_LOGS_RENDER.md** - Como ler logs e diagnosticar
- **test_render.ps1** - Script automatizado PowerShell
- **test_render.sh** - Script automatizado Bash

---

## ✅ CHECKLIST FINAL

Após testar, marque:

- [ ] Registrar usuário retorna 201
- [ ] Login retorna token válido
- [ ] Criar produto retorna 201
- [ ] Listar produtos retorna lista
- [ ] Admin vê todos os produtos
- [ ] Usuário comum vê só seus produtos
- [ ] Atualizar produto funciona
- [ ] Erro retorna status correto
- [ ] Sem erros 500 nos logs
- [ ] App está em estado "live"

**Se TODOS estão ✅, sua aplicação está pronta para produção! 🎉**
