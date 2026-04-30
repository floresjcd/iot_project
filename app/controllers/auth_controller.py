from flask import Blueprint, request, jsonify
from app.models.user import User
from app import db
from flask_jwt_extended import create_access_token
import logging

logger = logging.getLogger(__name__)

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        
        if not data or not data.get('username') or not data.get('password'):
            return jsonify({"msg": "Username e password são obrigatórios"}), 400
        
        if User.query.filter_by(username=data.get('username')).first():
            return jsonify({"msg": "Usuário já existe"}), 400
        
        new_user = User(username=data.get('username'), role=data.get('role', 'user'))
        new_user.set_password(data.get('password'))
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify({"msg": "Usuário criado com sucesso"}), 201
    
    except Exception as e:
        logger.error(f"Erro ao registrar: {str(e)}")
        db.session.rollback()
        return jsonify({"msg": f"Erro ao registrar: {str(e)}"}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        
        if not data or not data.get('username') or not data.get('password'):
            return jsonify({"msg": "Username e password são obrigatórios"}), 400
        
        user = User.query.filter_by(username=data.get('username')).first()
        
        if user and user.check_password(data.get('password')):
            # Incluímos o role e o id no token para facilitar a autorização
            access_token = create_access_token(identity=str(user.id), additional_claims={"role": user.role})
            return jsonify(access_token=access_token), 200
        
        return jsonify({"msg": "Credenciais inválidas"}), 401
    
    except Exception as e:
        logger.error(f"Erro ao fazer login: {str(e)}")
        return jsonify({"msg": f"Erro ao fazer login: {str(e)}"}), 500
