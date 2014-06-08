    <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Sales Analytics</title>

        <!-- Bootstrap -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        </head>



        <body>
        <%@ page import="java.sql.*"%>

            <%

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null, rs2 = null,rs3=null, rs4=null;
			boolean okay = true;
            String name = "";
			String debug = "";
			String result = "";
			int width = 0, height = 0;
			String insertStr = "INSERT INTO categories (NAME, DESCRIPTION) VALUES (?,?);";
			String updateStr = "UPDATE categories SET name=?, description=? WHERE id=?";
			String deleteStr = "DELETE FROM categories WHERE id=?";

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://127.0.0.1:5432/cse135?" +
                    "user=postgres&password=postgres");

				Statement stmt = conn.createStatement();
				stmt.executeUpdate("INSERT INTO uidcid (uid, cid, sum) SELECT s.uid, p.cid, sum(s.price*s.quantity) FROM products p, sales s WHERE p.id = s.pid GROUP BY s.uid, p.cid;");
				//INSERT INTO statepid (state, pid, sum) SELECT u.state, s.pid, sum(s.price*s.quantity) FROM users u, sales s WHERE u.id = s.uid GROUP BY u.state, s.pid;");
				 //CREATE TABLE statepid(id SERIAL PRIMARY KEY,state TEXT NOT NULL,pid INTEGER REFERENCES products(id) ON DELETE CASCADE,sum INTEGER NOT NULL);CREATE TABLE uidcid(id SERIAL PRIMARY KEY,uid INTEGER REFERENCES users(id) ON DELETE CASCADE,cid INTEGER REFERENCES categories(id) ON DELETE CASCADE,sum INTEGER NOT NULL);CREATE TABLE statecid(id SERIAL PRIMARY KEY,state TEXT NOT NULL,cid INTEGER REFERENCES categories(id) ON DELETE CASCADE,sum INTEGER NOT NULL);CREATE TABLE uid(id SERIAL PRIMARY KEY,uid INTEGER REFERENCES users(id) ON DELETE CASCADE,sum INTEGER NOT NULL);CREATE TABLE state(id SERIAL PRIMARY KEY,state TEXT NOT NULL,sum INTEGER NOT NULL);CREATE TABLE pid(id SERIAL PRIMARY KEY,pid INTEGER REFERENCES products(id) ON DELETE CASCADE,sum INTEGER NOT NULL);CREATE TABLE cid(id SERIAL PRIMARY KEY,cid INTEGER REFERENCES categories(id) ON DELETE CASCADE,sum INTEGER NOT NULL);");
		//		"INSERT INTO customersales (uid, pid, sales) SELECT p.uid, p.pid, SUM(p.quantity*p.price) FROM sales p GROUP BY p.uid, p.pid; INSERT INTO statesales (state, pid, sales) SELECT u.state, p.pid, SUM(p.quantity*p.price) FROM sales p, users u WHERE p.uid = u.id GROUP BY u.state, p.pid; INSERT INTO productsales (pid, sales) SELECT p.pid, SUM(p.quantity*p.price) FROM sales p GROUP BY p.pid; INSERT INTO aggregatesales (uid, state, catid, pid, sales) SELECT s.uid, u.state, p.cid, s.pid, sum(s.price*s.quantity) FROM sales s, users u, products p WHERE s.pid = p.id AND s.uid = u.id GROUP BY s.uid, u.state, p.cid, s.pid;");


}catch(Exception e){throw e;}
		%>
        </form>


        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="js/purl.js"></script>


        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>


        </body>
        </html>
