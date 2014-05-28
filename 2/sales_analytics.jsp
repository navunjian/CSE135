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




        <form method="GET" action="./sales_analytics.jsp">
        <select name="rows">
        <option value="customer">Customer</option>
        <option value="state">State</option>

        </select>


        <select id="state" name="state">
        <option value="allstates">All States</option>
        <option value="AL">Alabama</option>
        <option value="AK">Alaska</option>
        <option value="AZ">Arizona</option>
        <option value="AR">Arkansas</option>
        <option value="CA">California</option>
        <option value="CO">Colorado</option>
        <option value="CT">Connecticut</option>
        <option value="DE">Delaware</option>
        <option value="DC">District Of Columbia</option>
        <option value="FL">Florida</option>
        <option value="GA">Georgia</option>
        <option value="HI">Hawaii</option>
        <option value="ID">Idaho</option>
        <option value="IL">Illinois</option>
        <option value="IN">Indiana</option>
        <option value="IA">Iowa</option>
        <option value="KS">Kansas</option>
        <option value="KY">Kentucky</option>
        <option value="LA">Louisiana</option>
        <option value="ME">Maine</option>
        <option value="MD">Maryland</option>
        <option value="MA">Massachusetts</option>
        <option value="MI">Michigan</option>
        <option value="MN">Minnesota</option>
        <option value="MS">Mississippi</option>
        <option value="MO">Missouri</option>
        <option value="MT">Montana</option>
        <option value="NE">Nebraska</option>
        <option value="NV">Nevada</option>
        <option value="NH">New Hampshire</option>
        <option value="NJ">New Jersey</option>
        <option value="NM">New Mexico</option>
        <option value="NY">New York</option>
        <option value="NC">North Carolina</option>
        <option value="ND">North Dakota</option>
        <option value="OH">Ohio</option>
        <option value="OK">Oklahoma</option>
        <option value="OR">Oregon</option>
        <option value="PA">Pennsylvania</option>
        <option value="RI">Rhode Island</option>
        <option value="SC">South Carolina</option>
        <option value="SD">South Dakota</option>
        <option value="TN">Tennessee</option>
        <option value="TX">Texas</option>
        <option value="UT">Utah</option>
        <option value="VT">Vermont</option>
        <option value="VA">Virginia</option>
        <option value="WA">Washington</option>
        <option value="WV">West Virginia</option>
        <option value="WI">Wisconsin</option>
        <option value="WY">Wyoming</option>
        </select>

        <select name="category">
        <option value="allcategories">All Categories</option>
<!--Insert jsp shit for catergories here :D -->
            <%

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null, rs2 = null;
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
				rs = stmt.executeQuery("SELECT name FROM categories;");

				while (rs.next()) {
        %>
        <option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option>
		<%		}%>

        </select>

        <select name="ages">
        <option value="allages">All Ages</option>
        <option value="12-18">12-18</option>
        <option value="18-45">18-45</option>
        <option value="45-65">45-65</option>
        <option value="65-">65-</option>
        </select>
        <input type="submit" onclick="document.getElementById('rowOffset').value =0;document.getElementById('colOffset').value =0"/>


        <div id="results-container">


        </div>


        <!-- Get Submitted Fields -->
		<table border="1">
		<tr>
        <%
        String rows = request.getParameter("rows");
		%><td><b><%= rows  %></b></td><%
        String category = request.getParameter("category");
        String state = request.getParameter("state");
        String ages = request.getParameter("ages");
		String rowOffset = request.getParameter("rowOffset");
		String colOffset = request.getParameter("colOffset");
		int rO, cO;
		rO = (rowOffset == null) ? 0 : Integer.parseInt(rowOffset);
		cO = (colOffset == null) ? 0 : Integer.parseInt(colOffset);
		
		rs = stmt.executeQuery("SELECT COUNT(*) as count FROM products LIMIT 10 OFFSET 0");
		int prod_ids[];
		double prod_prices[];
		rs.next();
		prod_ids = new int[rs.getInt("count")];
		prod_prices = new double[rs.getInt("count")];
		rs = stmt.executeQuery("SELECT name, id, price FROM products ORDER BY name LIMIT 10 OFFSET " + cO);
		int i = 0;
		while (rs.next()) {
			prod_ids[i] = rs.getInt("id");
			prod_prices[i++] = rs.getDouble("price");
		%>
		<td><b><%= rs.getString("name") %></b></td>
		<% }
		
		if (rows.equals("customer")) {
			rs = stmt.executeQuery("SELECT p.name as header, p.price FROM (SELECT u.name, sum(s.price) as price FROM users u, sales s WHERE u.id=s.uid GROUP BY u.name) as p ORDER BY name LIMIT 20 OFFSET "+rO);
		} else if (rows.equals("state")) {
			rs = stmt.executeQuery("SELECT p.state as header, p.price FROM (SELECT u.state, sum(s.price) as price FROM users u, sales s WHERE u.id=s.uid GROUP BY u.state) as p ORDER BY state LIMIT 20 OFFSET "+rO);
		}
		while (rs.next()) {
        %>
		<tr><td><b><%= rs.getString("header") %></b></td>
		<%
			for (int j = 0; j < prod_ids.length &&j<10; j++) {
			Statement stmt2 = conn.createStatement();
			//rs2 = stmt2.executeQuery("SELECT p.name, sum(s.quantity*p.price) as sum FROM sales s, users u, (select * from products ORDER BY name) as p WHERE s.uid=u.id AND u.name='"+rs.getString("header")+"' AND s.pid=p.id GROUP BY p.name ORDER BY p.name;");
			
			if (rows.equals("customer")) {
				rs2 = stmt2.executeQuery("SELECT sum(s.quantity) as sum FROM sales s, users u WHERE s.uid=u.id AND u.name='"+rs.getString("header")+"' AND s.pid="+prod_ids[j]);
			} else if (rows.equals("state")) {
				rs2 = stmt2.executeQuery("SELECT sum(s.quantity) as sum FROM sales s, users u WHERE s.uid=u.id AND u.state='"+rs.getString("header")+"' AND s.pid="+prod_ids[j]);
			}
			rs2.next();
		%>
			<td><%= rs2.getInt("sum")*prod_prices[j] %></td>
		<%
			rs2.close();
			stmt2.close();
			}
		}
		%>

		</table>

		<button type="submit" onclick="document.getElementById('rowOffset').value =parseInt(document.getElementById('rowOffset').value)- 20 ">Previous 20 <%= rows %>s</button>
		<button type="submit" onclick="document.getElementById('rowOffset').value =parseInt(document.getElementById('rowOffset').value)+ 20 ">Next 20 <%= rows %>s</button>
		<button type="submit" onclick="document.getElementById('colOffset').value =parseInt(document.getElementById('colOffset').value)- 10 ">Previous 10 products</button>
		<button type="submit" onclick="document.getElementById('colOffset').value =parseInt(document.getElementById('colOffset').value)+ 10 ">Next 10 products</button>
		<input type="hidden" name="rowOffset" id="rowOffset" value=<%= rO %>></hidden>
        <input type="hidden" name="colOffset" id="colOffset" value=<%= cO %>></hidden>

        <%
}catch(Exception e){throw e;}
		%>
        </form>

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
        </body>
        </html>
