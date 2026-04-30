# Guia Rápido: Verificar Erros 500 no Render

## 🔴 Problema: Erros 500 em Todos os Endpoints

Os erros 500 indicam um problema no servidor, geralmente:
- Conexão com banco de dados falhou
- Erro na inicialização da aplicação
- Erro na importação de módulos

## 📋 Passos para Diagnosticar

### 1. Acesse o Render Dashboard
- URL: https://dashboard.render.com
- Selecione: **flask-iot-app**

### 2. Verifique os Logs
Clique em "Logs" no topo da página

**Procure por:**
- `Error` ou `ERROR` em vermelho
- `Traceback` - mostra o erro exato
- `AttributeError`
- `ImportError`
- `Database connection error`

### 3. Problemas Comuns e Soluções

#### Problema A: "app has no attribute 'app'"
```
gunicorn.errors.AppImportError: Failed to find attribute 'app' in 'app'
```

**Solução:**
Verifique se `app/__init__.py` termina com:
```python
# Create app instance for gunicorn
app = create_app()
```

#### Problema B: "DATABASE_URL not found"
```
KeyError: 'DATABASE_URL'
```

**Solução:**
1. Vá para Settings → Environment Variables no Render
2. Adicione: `DATABASE_URL` com a string de conexão PostgreSQL

#### Problema C: "Failed to connect to database"
```
psycopg2.OperationalError: could not connect to server
```

**Solução:**
1. Verifique se o banco de dados está criado
2. Verifique se as credenciais estão corretas
3. Execute migrations: `db.create_all()`

#### Problema D: "ModuleNotFoundError"
```
ModuleNotFoundError: No module named 'flask'
```

**Solução:**
- Verifique se `requirements.txt` está correto
- Render deve executar `pip install -r requirements.txt` automaticamente

---

## 🔧 Correções Rápidas

### Adicionar Tratamento de Erros Melhor

Edite `app/__init__.py` para adicionar:

```python
# Adicione após app = Flask(__name__)
@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return jsonify({'error': 'Internal server error', 'message': str(error)}), 500

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404
```

### Verificar Inicialização

Crie um endpoint de health check:

```python
@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'message': 'App is running'}), 200
```

---

## 📝 Checklist para Revisar

- [ ] `app/__init__.py` tem `app = create_app()` no final
- [ ] `requirements.txt` contém todas as dependências
- [ ] `render.yaml` tem `startCommand: gunicorn run:app`
- [ ] `DATABASE_URL` está em Environment Variables
- [ ] `SECRET_KEY` está em Environment Variables
- [ ] `JWT_SECRET_KEY` está em Environment Variables
- [ ] Banco de dados PostgreSQL está criado

---

## 🚀 Passos para Resolver

1. **Verificar Logs**
   - Acesse Render Dashboard → Logs
   - Procure a mensagem de erro específica

2. **Corrigir Código**
   - Se erro é de importação, corrija em `app/__init__.py`
   - Se erro é de banco, verifique variáveis de ambiente

3. **Testar Localmente**
   ```bash
   python run.py
   ```

4. **Deploy Novamente**
   ```bash
   git add .
   git commit -m "Fix 500 errors"
   git push
   ```

---

## ⚠️ Se os Logs Não Mostram o Erro

Tente esses endpoints para debug:

```powershell
# Teste 1: Verificar se app está rodando
curl https://seu-app.onrender.com/health

# Teste 2: Verificar erro 500 com mais detalhes
curl -v https://seu-app.onrender.com/api/auth/register
```

---

## 📞 Próximas Ações

1. **Acesse o Render Dashboard agora**
2. **Procure a mensagem de erro nos Logs**
3. **Me mostre a mensagem de erro exata**
4. **Corrija baseado na solução acima**
