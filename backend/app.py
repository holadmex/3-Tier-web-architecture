import os
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import bcrypt
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)
CORS(app)

# Load configuration from environment variables
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URI')
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
db = SQLAlchemy(app)

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)

# Product model
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200))
    price = db.Column(db.Float, nullable=False)

# Initialize products
def initialize_products():
    if not Product.query.first():
        products = [
            Product(name='Product 1', description='Description of product 1', price=19.99),
            Product(name='Product 2', description='Description of product 2', price=29.99),
            Product(name='Product 3', description='Description of product 3', price=39.99)
        ]
        db.session.add_all(products)
        db.session.commit()

# API Routes
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    new_user = User(username=data['username'], email=data['email'], password_hash=hashed_password)
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'User registered successfully!'})

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
    if not user or not bcrypt.checkpw(data['password'].encode('utf-8'), user.password_hash.encode('utf-8')):
        return jsonify({'message': 'Invalid email or password!'}), 401
    return jsonify({'message': f'Welcome, {user.username}!'})

@app.route('/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    products_list = [{'name': product.name, 'description': product.description, 'price': product.price} for product in products]
    return jsonify(products_list)

# Entry point
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        initialize_products()
    app.run(host='0.0.0.0', port=5000, debug=True)
