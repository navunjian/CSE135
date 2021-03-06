DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;

CREATE TABLE users(
	ID		SERIAL PRIMARY KEY,
	NAME		TEXT NOT NULL UNIQUE,
	AGE		INTEGER NOT NULL,
	ROLE		TEXT NOT NULL,
	STATE		TEXT NOT NULL
);

CREATE TABLE categories(
	ID		SERIAL PRIMARY KEY,
	NAME		TEXT NOT NULL UNIQUE,
	DESCRIPTION	TEXT
);
CREATE TABLE products(
	ID		SERIAL PRIMARY KEY,
	SKU		INTEGER UNIQUE,
	NAME		TEXT,
	PRICE		MONEY,
	CATEGORY	INTEGER REFERENCES categories (ID) NOT NULL
);	
CREATE TABLE cart(
	USERID		INTEGER REFERENCES users (ID) NOT NULL,
	PRODUCT		INTEGER REFERENCES products(ID) NOT NULL
);
	
