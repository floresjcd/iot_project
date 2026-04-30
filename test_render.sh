#!/bin/bash

# Script para Testar Aplicação no Render
# Uso: ./test_render.sh https://seu-app.onrender.com

APP_URL="${1:-https://flask-iot-app-4d6qfp47hvqx.onrender.com}"

echo "════════════════════════════════════════"
echo "  Teste Automatizado - Aplicação Render  "
echo "════════════════════════════════════════"
echo ""
echo "URL da Aplicação: $APP_URL"
echo ""

TESTS_PASSED=0
TESTS_FAILED=0
TOKEN=""
ADMIN_TOKEN=""
PRODUCT_ID=""

# Função para fazer testes
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    local token=$5
    
    echo "[TESTE] $name"
    
    local headers="-H 'Content-Type: application/json'"
    if [ ! -z "$token" ]; then
        headers="$headers -H 'Authorization: Bearer $token'"
    fi
    
    if [ ! -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X $method \
            $headers \
            -d "$data" \
            "$APP_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method \
            $headers \
            "$APP_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)
    
    echo "  ✓ Status: $http_code"
    echo "  ✓ Resposta:"
    echo "$body" | jq '.' 2>/dev/null || echo "$body"
    echo ""
    
    return 0
}

# ==================== TESTES ====================

echo "1. REGISTRAR USUÁRIO COMUM"
test_endpoint \
    "Registrar usuário 'joao'" \
    "POST" \
    "/api/auth/register" \
    '{"username":"joao","password":"senha123","role":"user"}'

echo ""
echo "2. LOGIN DO USUÁRIO"
response=$(curl -s -X POST \
    -H 'Content-Type: application/json' \
    -d '{"username":"joao","password":"senha123"}' \
    "$APP_URL/api/auth/login")

TOKEN=$(echo "$response" | jq -r '.access_token')
echo "  ✓ Token: $TOKEN"
echo ""

echo "3. REGISTRAR USUÁRIO ADMIN"
test_endpoint \
    "Registrar usuário 'admin'" \
    "POST" \
    "/api/auth/register" \
    '{"username":"admin","password":"admin123","role":"admin"}'

echo ""
echo "4. LOGIN DO ADMIN"
response=$(curl -s -X POST \
    -H 'Content-Type: application/json' \
    -d '{"username":"admin","password":"admin123"}' \
    "$APP_URL/api/auth/login")

ADMIN_TOKEN=$(echo "$response" | jq -r '.access_token')
echo "  ✓ Token Admin: $ADMIN_TOKEN"
echo ""

echo "5. CRIAR PRODUTO (como joao)"
response=$(curl -s -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"name":"Sensor IoT","description":"Sensor de temperatura e umidade","price":199.99}' \
    "$APP_URL/api/products/")

PRODUCT_ID=$(echo "$response" | jq -r '.id')
echo "  ✓ Resposta:"
echo "$response" | jq '.'
echo ""

echo "6. LISTAR PRODUTOS (como joao - vê só seus)"
curl -s -X GET \
    -H "Authorization: Bearer $TOKEN" \
    "$APP_URL/api/products/" | jq '.'
echo ""

echo "7. CRIAR PRODUTO (como admin)"
curl -s -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ADMIN_TOKEN" \
    -d '{"name":"Controlador IoT","description":"Controlador wireless","price":299.99}' \
    "$APP_URL/api/products/" | jq '.'
echo ""

echo "8. LISTAR PRODUTOS (como admin - vê tudo)"
curl -s -X GET \
    -H "Authorization: Bearer $ADMIN_TOKEN" \
    "$APP_URL/api/products/" | jq '.'
echo ""

echo "9. ATUALIZAR PRODUTO"
if [ ! -z "$PRODUCT_ID" ] && [ "$PRODUCT_ID" != "null" ]; then
    curl -s -X PUT \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $TOKEN" \
        -d '{"name":"Sensor IoT V2","description":"Versão melhorada com WiFi","price":249.99}' \
        "$APP_URL/api/products/$PRODUCT_ID" | jq '.'
fi
echo ""

echo "10. TESTAR ERRO: Senha incorreta"
curl -s -X POST \
    -H 'Content-Type: application/json' \
    -d '{"username":"joao","password":"senhaerrada"}' \
    "$APP_URL/api/auth/login" | jq '.'
echo ""

echo "════════════════════════════════════════"
echo "  ✓ TESTES CONCLUÍDOS"
echo "════════════════════════════════════════"
