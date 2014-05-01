CREATE TABLE users(
	ID		SERIAL PRIMARY KEY,
	NAME		TEXT NOT NULL,
	AGE		INTEGER NOT NULL,
	ROLE		TEXT NOT NULL,
	STATE		TEXT NOT NULL
)
CREATE TABLE products(
	ID		SERIAL PRIMARY KEY,
	SKU		INTEGER,
	NAME		TEXT,
	PRICE		MONEY,
	CATEGORY	INTEGER REFERENCES categories (ID) NOT NULL
)
CREATE TABLE categories(
	ID		SERIAL PRIMARY KEY,
	NAME		TEXT,
	DESCRIPTION	TEXT
)	
CREATE TABLE cart(
	USER		INTEGER REFERENCES users (ID) NOT NULL,
	PRODUCT		INTEGER REFERENCES products(ID) NOT NULL
)
	
