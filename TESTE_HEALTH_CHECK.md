# Script para Testar Health Check e Ver Erros Detalhados

## 1️⃣ Teste o Health Check

```powershell
$APP_URL = "https://iot-project-web.onrender.com"

# Teste se a app está respondendo
Write-Host "=== TESTE DE HEALTH CHECK ===" -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri "$APP_URL/health" -Method GET
    Write-Host "✓ Health Check OK" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | Format-List
} catch {
    Write-Host "✗ Health Check FALHOU" -ForegroundColor Red
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
}
```

## 2️⃣ Se Health Check Falhar

**Verifique os Logs no Render:**

1. Acesse https://dashboard.render.com
2. Selecione **flask-iot-app**
3. Clique em **"Logs"** no topo
4. Procure por:
   - `error` ou `ERROR` em vermelho
   - `Traceback` para ver a mensagem de erro exata
   - Copie toda a mensagem de erro

## 3️⃣ Erros Mais Comuns Que Agora Aparecem

Agora com o melhor tratamento de erros, você verá:

### Erro 1: Problema com Banco de Dados
```
"Database connection failed: could not connect to server"
```
**Solução:** Verifique `DATABASE_URL` em Environment Variables

### Erro 2: Falta de Variáveis de Ambiente
```
"KeyError: 'DATABASE_URL'"
```
**Solução:** Adicione em Settings → Environment Variables

### Erro 3: Módulo Não Encontrado
```
"ModuleNotFoundError: No module named 'flask'"
```
**Solução:** Verifique `requirements.txt` e `buildCommand`

---

## 4️⃣ Próximo Passo

1. **Execute o teste de health check acima**
2. **Se falhar, copie o erro exacto**
3. **Mostre-me a mensagem de erro do Render**
4. **Corrijo o problema baseado no erro real**

---

## 5️⃣ Após Corrigir

```powershell
# Fazer commit das correções
git add .
git commit -m "Add error handling and health check endpoint"
git push

# Esperar 2-3 minutos pelo redeploy
# Depois testar novamente
```
