from flask import Blueprint, request, jsonify
from app.models.product import Product
from app.models.user import User
from app import db
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt
import logging

logger = logging.getLogger(__name__)

product_bp = Blueprint('product', __name__)

@product_bp.route('/', methods=['POST'])
@jwt_required()
def create_product():
    try:
        data = request.get_json()
        user_id = get_jwt_identity()
        
        if not data or not data.get('name') or not data.get('price'):
            return jsonify({"msg": "Name e price são obrigatórios"}), 400
        
        new_product = Product(
            name=data.get('name'),
            description=data.get('description'),
            price=data.get('price'),
            user_id=user_id
        )
        db.session.add(new_product)
        db.session.commit()
        return jsonify(new_product.to_dict()), 201
    
    except Exception as e:
        logger.error(f"Erro ao criar produto: {str(e)}")
        db.session.rollback()
        return jsonify({"msg": f"Erro ao criar produto: {str(e)}"}), 500

@product_bp.route('/', methods=['GET'])
@jwt_required()
def list_products():
    try:
        claims = get_jwt()
        user_id = get_jwt_identity()
        
        if claims.get('role') == 'admin':
            products = Product.query.all()
        else:
            products = Product.query.filter_by(user_id=user_id).all()
            
        return jsonify([p.to_dict() for p in products]), 200
    
    except Exception as e:
        logger.error(f"Erro ao listar produtos: {str(e)}")
        return jsonify({"msg": f"Erro ao listar produtos: {str(e)}"}), 500

@product_bp.route('/<int:id>', methods=['PUT'])
@jwt_required()
def update_product(id):
    try:
        data = request.get_json()
        user_id = int(get_jwt_identity())
        claims = get_jwt()
        
        product = Product.query.get_or_404(id)
        
        # Apenas admin ou o dono do produto pode editar
        if claims.get('role') != 'admin' and product.user_id != user_id:
            return jsonify({"msg": "Não autorizado"}), 403
            
        product.name = data.get('name', product.name)
        product.description = data.get('description', product.description)
        product.price = data.get('price', product.price)
        
        db.session.commit()
        return jsonify(product.to_dict()), 200
    
    except Exception as e:
        logger.error(f"Erro ao atualizar produto: {str(e)}")
        db.session.rollback()
        return jsonify({"msg": f"Erro ao atualizar produto: {str(e)}"}), 500

@product_bp.route('/<int:id>', methods=['DELETE'])
@jwt_required()
def delete_product(id):
    try:
        user_id = int(get_jwt_identity())
        claims = get_jwt()
        
        product = Product.query.get_or_404(id)
        
        # Apenas admin ou o dono do produto pode excluir
        if claims.get('role') != 'admin' and product.user_id != user_id:
            return jsonify({"msg": "Não autorizado"}), 403
            
        db.session.delete(product)
        db.session.commit()
        return jsonify({"msg": "Produto excluído"}), 200
    
    except Exception as e:
        logger.error(f"Erro ao excluir produto: {str(e)}")
        db.session.rollback()
        return jsonify({"msg": f"Erro ao excluir produto: {str(e)}"}), 500
