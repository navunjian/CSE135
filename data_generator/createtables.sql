DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    state  	TEXT NOT NULL
);

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);

CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);

CREATE TABLE customersales (
	id SERIAL PRIMARY KEY,
	uid INTEGER REFERENCES users(id) ON DELETE CASCADE,
	pid INTEGER REFERENCES products(id) ON DELETE CASCADE,
	sales INTEGER NOT NULL
);

CREATE INDEX sales_index ON customersales (sales);

CREATE TABLE statesales (
	id SERIAL PRIMARY KEY,
	state TEXT NOT NULL,
	pid INTEGER REFERENCES products(id) ON DELETE CASCADE,
	sales INTEGER NOT NULL
);
CREATE INDEX state_sales_index ON statesales (sales);

CREATE TABLE productsales (
	id SERIAL PRIMARY KEY,
	pid INTEGER REFERENCES products(id) ON DELETE CASCADE,
	sales INTEGER NOT NULL
);
CREATE INDEX product_sales_index ON productsales (sales);

CREATE TABLE aggregatesales (
	id	SERIAL PRIMARY KEY,
	uid	INTEGER REFERENCES users(id) ON DELETE CASCADE,
	state	TEXT NOT NULL,
	catid	INTEGER REFERENCES categories(id) ON DELETE CASCADE,
	pid	INTEGER REFERENCES products(id) ON DELETE CASCADE,
	sales	INTEGER NOT NULL
);