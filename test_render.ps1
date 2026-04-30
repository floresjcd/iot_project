# Script para Testar Aplicação no Render
# Uso: .\test_render.ps1 -AppUrl "https://seu-app.onrender.com"

param(
    [string]$AppUrl = "https://iot-project-web.onrender.com",
    [switch]$Verbose
)

Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Teste Automatizado - Aplicação Render  " -ForegroundColor Cyan
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "URL da Aplicação: $AppUrl" -ForegroundColor Yellow
Write-Host ""

$testsPassados = 0
$testesFalhados = 0
$TOKEN = ""
$ADMIN_TOKEN = ""
$PRODUCT_ID = ""

function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Body,
        [string]$Token,
        [string]$ExpectedStatus
    )
    
    Write-Host "[TESTE] $Name" -ForegroundColor Cyan
    
    try {
        $headers = @{"Content-Type" = "application/json"}
        if ($Token) {
            $headers["Authorization"] = "Bearer $Token"
        }
        
        $params = @{
            Uri = "$AppUrl$Endpoint"
            Method = $Method
            Headers = $headers
        }
        
        if ($Body) {
            $params["Body"] = ($Body | ConvertTo-Json)
        }
        
        $response = Invoke-WebRequest @params
        $statusCode = $response.StatusCode
        
        Write-Host "  ✓ Status: $statusCode" -ForegroundColor Green
        
        if ($response.Content) {
            $json = $response.Content | ConvertFrom-Json
            Write-Host "  ✓ Resposta:" -ForegroundColor Green
            Write-Host "    $($json | ConvertTo-Json -Depth 2)" -ForegroundColor Green
            return $json
        }
        
        $script:testsPassados++
        return $response
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        Write-Host "  ✗ ERRO $statusCode" -ForegroundColor Red
        Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
        $script:testesFalhados++
        return $null
    }
}

# ==================== TESTES ====================

Write-Host "1. REGISTRAR USUÁRIO COMUM" -ForegroundColor Magenta
$userResponse = Test-Endpoint `
    -Name "Registrar usuário 'joao'" `
    -Method "POST" `
    -Endpoint "/api/auth/register" `
    -Body @{
        username = "joao"
        password = "senha123"
        role = "user"
    }

Write-Host ""
Write-Host "2. LOGIN DO USUÁRIO" -ForegroundColor Magenta
$loginResponse = Test-Endpoint `
    -Name "Login joao" `
    -Method "POST" `
    -Endpoint "/api/auth/login" `
    -Body @{
        username = "joao"
        password = "senha123"
    }

if ($loginResponse.access_token) {
    $TOKEN = $loginResponse.access_token
    Write-Host "  ✓ Token obtido com sucesso!" -ForegroundColor Green
}

Write-Host ""
Write-Host "3. REGISTRAR USUÁRIO ADMIN" -ForegroundColor Magenta
$adminRegisterResponse = Test-Endpoint `
    -Name "Registrar usuário 'admin'" `
    -Method "POST" `
    -Endpoint "/api/auth/register" `
    -Body @{
        username = "admin"
        password = "admin123"
        role = "admin"
    }

Write-Host ""
Write-Host "4. LOGIN DO ADMIN" -ForegroundColor Magenta
$adminLoginResponse = Test-Endpoint `
    -Name "Login admin" `
    -Method "POST" `
    -Endpoint "/api/auth/login" `
    -Body @{
        username = "admin"
        password = "admin123"
    }

if ($adminLoginResponse.access_token) {
    $ADMIN_TOKEN = $adminLoginResponse.access_token
    Write-Host "  ✓ Token admin obtido com sucesso!" -ForegroundColor Green
}

Write-Host ""
Write-Host "5. CRIAR PRODUTO (como joao)" -ForegroundColor Magenta
$productResponse = Test-Endpoint `
    -Name "Criar produto 'Sensor IoT'" `
    -Method "POST" `
    -Endpoint "/api/products/" `
    -Body @{
        name = "Sensor IoT"
        description = "Sensor de temperatura e umidade"
        price = 199.99
    } `
    -Token $TOKEN

if ($productResponse.id) {
    $PRODUCT_ID = $productResponse.id
    Write-Host "  ✓ Produto criado com ID: $PRODUCT_ID" -ForegroundColor Green
}

Write-Host ""
Write-Host "6. LISTAR PRODUTOS (como joao - vê só seus)" -ForegroundColor Magenta
$listResponse = Test-Endpoint `
    -Name "Listar produtos de joao" `
    -Method "GET" `
    -Endpoint "/api/products/" `
    -Token $TOKEN

Write-Host ""
Write-Host "7. CRIAR PRODUTO (como admin)" -ForegroundColor Magenta
$adminProductResponse = Test-Endpoint `
    -Name "Criar produto 'Controlador IoT'" `
    -Method "POST" `
    -Endpoint "/api/products/" `
    -Body @{
        name = "Controlador IoT"
        description = "Controlador wireless"
        price = 299.99
    } `
    -Token $ADMIN_TOKEN

Write-Host ""
Write-Host "8. LISTAR PRODUTOS (como admin - vê tudo)" -ForegroundColor Magenta
$adminListResponse = Test-Endpoint `
    -Name "Listar todos os produtos (admin)" `
    -Method "GET" `
    -Endpoint "/api/products/" `
    -Token $ADMIN_TOKEN

Write-Host ""
Write-Host "9. ATUALIZAR PRODUTO (como joao)" -ForegroundColor Magenta
if ($PRODUCT_ID) {
    $updateResponse = Test-Endpoint `
        -Name "Atualizar produto $PRODUCT_ID" `
        -Method "PUT" `
        -Endpoint "/api/products/$PRODUCT_ID" `
        -Body @{
            name = "Sensor IoT V2"
            description = "Versão melhorada com WiFi"
            price = 249.99
        } `
        -Token $TOKEN
}

Write-Host ""
Write-Host "10. TESTAR ERRO: Senha incorreta" -ForegroundColor Magenta
$invalidLoginResponse = Test-Endpoint `
    -Name "Login com senha errada" `
    -Method "POST" `
    -Endpoint "/api/auth/login" `
    -Body @{
        username = "joao"
        password = "senhaerrada"
    }

# ==================== RESUMO ====================

Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESUMO DOS TESTES                     " -ForegroundColor Cyan
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan

$totalTestes = $script:testsPassados + $script:testesFalhados
Write-Host ""
Write-Host "  ✓ Testes Passados: $($script:testsPassados)" -ForegroundColor Green
Write-Host "  ✗ Testes Falhados: $($script:testesFalhados)" -ForegroundColor Red
Write-Host "  Total: $totalTestes" -ForegroundColor Yellow
Write-Host ""

if ($script:testesFalhados -eq 0) {
    Write-Host "  🎉 TODOS OS TESTES PASSARAM! 🎉" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ ALGUNS TESTES FALHARAM" -ForegroundColor Red
}

Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
