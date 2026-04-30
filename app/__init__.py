from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from config.config import Config
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

db = SQLAlchemy()
jwt = JWTManager()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    jwt.init_app(app)

    # Import and register blueprints/controllers
    from app.controllers.auth_controller import auth_bp
    from app.controllers.product_controller import product_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(product_bp, url_prefix='/api/products')

    # Create database tables on startup if needed
    with app.app_context():
        db.create_all()

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health():
        try:
            # Test database connection
            db.session.execute('SELECT 1')
            return jsonify({
                'status': 'ok',
                'message': 'App is running and database is connected'
            }), 200
        except Exception as e:
            logger.error(f"Health check failed: {str(e)}")
            return jsonify({
                'status': 'error',
                'message': f'Database connection failed: {str(e)}'
            }), 500

    # Error handlers
    @app.errorhandler(500)
    def internal_error(error):
        logger.error(f"500 Error: {str(error)}")
        db.session.rollback()
        return jsonify({
            'error': 'Internal server error',
            'message': str(error)
        }), 500

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Endpoint not found'}), 404

    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({'error': 'Bad request'}), 400

    return app

# Create app instance for gunicorn
app = create_app()
