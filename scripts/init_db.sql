-- Script de criação manual caso não use SQLAlchemy create_all()
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(80) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL,
    role VARCHAR(20) DEFAULT 'user'
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(200),
    price FLOAT NOT NULL,
    user_id INTEGER REFERENCES users(id) NOT NULL
);
