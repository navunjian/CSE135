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
        <select name="rows" id="rows">
        <option value="customer">Customer</option>
        <option value="state">State</option>
        </select>


        <select id="state" name="state">
        <option value="allstates">All States</option>
        <option value="Alabama">Alabama</option>
        <option value="Alaska">Alaska</option>
        <option value="Arizona">Arizona</option>
        <option value="Arkansas">Arkansas</option>
        <option value="California">California</option>
        <option value="Colorado">Colorado</option>
        <option value="Connecticut">Connecticut</option>
        <option value="Delaware">Delaware</option>
        <option value="District Of Columbia">District Of Columbia</option>
        <option value="Florida">Florida</option>
        <option value="Georgia">Georgia</option>
        <option value="Hawaii">Hawaii</option>
        <option value="Idaho">Idaho</option>
        <option value="Illinois">Illinois</option>
        <option value="Indiana">Indiana</option>
        <option value="Iowa">Iowa</option>
        <option value="Kansas">Kansas</option>
        <option value="Kentucky">Kentucky</option>
        <option value="Louisiana">Louisiana</option>
        <option value="Maine">Maine</option>
        <option value="Maryland">Maryland</option>
        <option value="Massachusetts">Massachusetts</option>
        <option value="Michigan">Michigan</option>
        <option value="Minnesota">Minnesota</option>
        <option value="Mississippi">Mississippi</option>
        <option value="Missouri">Missouri</option>
        <option value="Montana">Montana</option>
        <option value="Nebraska">Nebraska</option>
        <option value="Nevada">Nevada</option>
        <option value="New Hampshire">New Hampshire</option>
        <option value="New Jersey">New Jersey</option>
        <option value="New Mexico">New Mexico</option>
        <option value="New York">New York</option>
        <option value="North Carolina">North Carolina</option>
        <option value="North Dakota">North Dakota</option>
        <option value="Ohio">Ohio</option>
        <option value="Oklahoma">Oklahoma</option>
        <option value="Oregon">Oregon</option>
        <option value="Pennsylvania">Pennsylvania</option>
        <option value="Rhode Island">Rhode Island</option>
        <option value="South Carolina<">South Carolina</option>
        <option value="South Dakota">South Dakota</option>
        <option value="Tennessee">Tennessee</option>
        <option value="Texas">Texas</option>
        <option value="Utah">Utah</option>
        <option value="Vermont">Vermont</option>
        <option value="Virginia">Virginia</option>
        <option value="Washington">Washington</option>
        <option value="West Virginia">West Virginia</option>
        <option value="Wisconsin">Wisconsin</option>
        <option value="Wyoming">Wyoming</option>
        </select>

        <select name="category" id="category">
        <option value="allcategories">All Categories</option>
<!--Insert jsp shit for catergories here :D -->
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
				rs = stmt.executeQuery("SELECT name FROM categories;");

				while (rs.next()) {
        %>
        <option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option>
		<%		}%>

        </select>

        <select name="ages" id="ages">
        <option value="allages">All Ages</option>
        <option value="12-18">12-18</option>
        <option value="18-45">18-45</option>
        <option value="45-65">45-65</option>
        <option value="65-">65-</option>
        </select>
        <input id="submitButton" type="submit" onclick="document.getElementById('rowOffset').value =0;document.getElementById('colOffset').value =0"/>



        <!-- Get Submitted Fields -->
		<table border="1">
		<tr>
        <%
        String rows = request.getParameter("rows");
        if(rows !=null){
		%><td><b><%= rows  %></b></td><%
        String category = request.getParameter("category");
        String state = request.getParameter("state");
        String ages = request.getParameter("ages");
        Boolean filtered = false;
        String filter="";

        if(!state.equals("allstates")){
            filter += " AND u.state='" +state + "' ";
        }

        if(!ages.equals("allages") && ages.equals("12-18")) filter += " AND u.age >=12 AND u.age <=18 "; if(!ages.equals("allages") && ages.equals("18-45")) filter += " AND u.age > 18 AND u.age <=45 "; if(!ages.equals("allages") && ages.equals("45-65")) filter += " AND u.age > 45 AND u.age <=65 "; if(!ages.equals("allages") && ages.equals( "65-")) filter += " AND u.age > 65 ";

        if(!category.equals("allcategories")) filter += " AND c.name='" + category +"' ";

		String rowOffset = request.getParameter("rowOffset");
		String colOffset = request.getParameter("colOffset");
		int rO, cO;
		rO = (rowOffset == null) ? 0 : Integer.parseInt(rowOffset);
		cO = (colOffset == null) ? 0 : Integer.parseInt(colOffset);
		
		rs = stmt.executeQuery("SELECT COUNT(*) as count FROM products");
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
						Statement stmt4 = conn.createStatement();

		rs4 = stmt4.executeQuery("SELECT sum(sum) as sum FROM (SELECT p.name, sum(s.quantity*p.price) as sum FROM sales s, users u, (select * from products ORDER BY name) as p, categories c WHERE s.uid=u.id  AND p.cid = c.id AND p.name='"+rs.getString("name") + "' "+ filter + " AND s.pid=p.id GROUP BY p.name ORDER BY p.name) as a");
        rs4.next();
        String res = rs4.getString("sum");
        if(res == null) res = "0";
		%>
		<td><b><%= rs.getString("name") + " ($" + res + ")"%></b></td>
		<% }
		        rs4.close();
		if ( rows.equals("customer")) {
			rs = stmt.executeQuery("SELECT p.name as header, p.price FROM (SELECT u.name, sum(s.price) as price FROM users u, sales s, products p, categories c  WHERE u.id=s.uid AND s.pid = p.id AND p.cid = c.id "  + filter+"  GROUP BY u.name) as p ORDER BY name LIMIT 20 OFFSET "+rO);
		} else if (rows.equals("state")) {
			rs = stmt.executeQuery("SELECT p.state as header, p.price FROM (SELECT u.state, sum(s.price) as price FROM users u, sales s, products p, categories c WHERE u.id=s.uid AND s.pid = p.id  AND p.cid = c.id " + filter + " GROUP BY u.state) as p ORDER BY state LIMIT 20 OFFSET "+rO);
		}
		int x=0;
		while (rs.next()) {
		x++;
			Statement stmt3 = conn.createStatement();
		if ( rows.equals("customer")) {
		rs3 = stmt3.executeQuery("SELECT sum(sum) as sum FROM (SELECT p.name, sum(s.quantity*p.price) as sum FROM sales s, users u, (select * from products ORDER BY name) as p, categories c WHERE s.uid=u.id  AND p.cid = c.id AND u.name='"+rs.getString("header")+"' "+ filter + " AND s.pid=p.id GROUP BY p.name ORDER BY p.name) as a");
		} else if (rows.equals("state")) {
		rs3 = stmt3.executeQuery("SELECT sum(sum) as sum FROM (SELECT p.name, sum(s.quantity*p.price) as sum FROM sales s, users u, (select * from products ORDER BY name) as p, categories c WHERE s.uid=u.id  AND p.cid = c.id AND u.state='"+rs.getString("header")+"' "+ filter + " AND s.pid=p.id GROUP BY p.name ORDER BY p.name) as a");
        }

        rs3.next();
        String resu = rs3.getString("sum");
        if(resu == null) resu = "0";
        %>
		<tr><td><b><%= rs.getString("header") + " ($" + resu + ")" %></b></td>
        <%
        rs3.close();
        						stmt3.close();

			for (int j = 0; j < prod_ids.length &&j<10; j++) {
			Statement stmt2 = conn.createStatement();

			if (rows.equals("customer")) {
				rs2 = stmt2.executeQuery("SELECT sum(s.quantity) as sum FROM sales s, users u, products p, categories c  WHERE s.uid=u.id AND s.pid = p.id AND p.cid = c.id AND u.name='"+rs.getString("header")+"' AND s.pid="+prod_ids[j] + filter);
			} else if (rows.equals("state")) {
				rs2 = stmt2.executeQuery("SELECT sum(s.quantity) as sum FROM sales s, users u, products p, categories c WHERE s.uid=u.id AND s.pid = p.id AND p.cid = c.id  AND u.state='"+rs.getString("header")+"' AND s.pid="+prod_ids[j] + filter);
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

		<button id="rowButton" type="submit" onclick="document.getElementById('rowOffset').value =parseInt(document.getElementById('rowOffset').value)- 20 ">Previous 20 <%= rows %>s</button>
		<button id="rowButtonNext" type="submit" onclick="document.getElementById('rowOffset').value =parseInt(document.getElementById('rowOffset').value)+ 20 ">Next 20 <%= rows %>s</button>
		<button id="colButton" type="submit" onclick="document.getElementById('colOffset').value =parseInt(document.getElementById('colOffset').value)- 10 ">Previous 10 products</button>
		<button id="colButtonNext" type="submit" onclick="document.getElementById('colOffset').value =parseInt(document.getElementById('colOffset').value)+ 10 ">Next 10 products</button>
		<input type="hidden" name="rowOffset" id="rowOffset" value=<%= rO %>></hidden>
        <input type="hidden" name="colOffset" id="colOffset" value=<%= cO %>></hidden>
        <br><br>
        <a href="sales_analytics.jsp"><button style ="margin-left:200px" hidden="hidden" id="backButton" type="button" >Back to Start</button>          </a>
        <span id="i" style="display:none"><%=i%></span>
        <span id="j" style="display:none"><%=x%></span>
        <%

}}catch(Exception e){throw e;}
		%>
        </form>
            
 
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="js/purl.js"></script>

                
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
               
        <script>
        var storeAge = $.url().param("ages");
        var storeCategory = $.url().param("category");
        var storeRows = $.url().param("rows");
        var storeState = $.url().param("state");
        if(storeAge != null) {
            $('#state').val(storeState);
            $('#ages').val(storeAge);
            $('#category').val(storeCategory);
            $('#rows').val(storeRows);
        }
        var col = $.url().param("colOffset");
        var row = $.url().param("rowOffset");

        if(col == null || col<=0)
            $("#colButton").attr("disabled",true);
        else {
        $('#state').hide();
        $('#ages').hide();
        $('#category').hide();
        $('#rows').hide(); 
        $('#submitButton').hide();
        $('#backButton').show();
        }
            
        if(row == null || row <=0)
            $("#rowButton").attr("disabled",true);
        else {
        $('#state').hide();
        $('#ages').hide();
        $('#category').hide();
        $('#rows').hide(); 
        $('#submitButton').hide();
        $('#backButton').show();
        }
            
        if($("#i").text() <10) $("#colButtonNext").attr("disabled",true);
        if($("#j").text() <20) $("#rowButtonNext").attr("disabled",true);

        </script>
        </body>
        </html>
