    <!DOCTYPE html>
        <html>
        <head>
        <title>Cart</title>
        </head>
        <body>
        <%@ page import="java.sql.*"%>

        <jsp:include page="./header.jsp" />


            <%

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet rs2 =null;
			boolean okay = true;
			String result = "";
			int show = -3;
			int catID = -1;

			String updateStr = "INSERT INTO cart (USERID, PRODUCT) VALUES ((SELECT ID FROM users WHERE NAME= ?), (SELECT ID FROM products WHERE SKU = ?)) ";


            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/CSE135?" +
                    "user=postgres&password=postgres");

				conn.setAutoCommit(false);

				Statement stmt = conn.createStatement();
				Statement stmt2 = conn.createStatement();

				String action = request.getParameter("action");
				if (action != null) {
					String command = action.substring(0,6);
					result = command;
					String newname = request.getParameter("newname");
					String newsku = request.getParameter("newsku");
					String newprice = request.getParameter("newprice");
					double nprice = -1;
					try{
					    if (!newprice.isEmpty()) nprice = Double.parseDouble(newprice);
					    } catch (Exception e){
					    }
					String newcat = request.getParameter("newcat");
					boolean skucheck = true;
                    if (command.equals("update") && !newname.isEmpty() && skucheck && !newsku.isEmpty() && !(nprice < 0) && !newcat.equals("-1")) {
	                    %>
        <h1>Product:</h1>
	                    <p>Name: <%=newname%></p>
                        <p>SKU: <%=newsku%></p>
                        <p>Price: $<%=newprice%></p>
        <form method="POST" action="shopproducts.jsp">

        <td><textarea  readonly style="resize: none;visibility:hidden;" rows="1" cols="15" name="newname"><%=newname%></textarea></td>
        <td><textarea readonly style="resize: none;visibility:hidden;" rows="1" cols="15" name="newsku"><%=newsku%></textarea></td>
        <td><textarea readonly style="resize: none;visibility:hidden;" rows="1" cols="15" name="newprice"><%=newprice%></textarea></td>
        <td><textarea readonly style="resize: none;visibility:hidden;" rows="1" cols="15" name="newcat"><%=newcat%></textarea></td>
    <p>   <select name="quantity">

        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>

        </select>     <input type="submit" value="Add to Cart" onclick="document.getElementById('<%= "action"%>').value='<%= "update"%>'"/>
        </p>

        <input type="hidden" id=<%= "action" %> name="action" value="" />
        <input type="hidden" name="show" value=-1 />
        </form>

	<%
					}  else okay = false;
				}


%>



        <h1>Your Cart</h1>


        <table border="1">
        <tr>
        <td><b>ID</b></td>
        <td><b>Name</b></td>
        <td><b>SKU</b></td>
        <td><b>Price</b></td>

        </tr>
            <%
				String search = request.getParameter("search");
				if (search == null) {
				String showstr = request.getParameter("show");
				if (showstr != null) show = Integer.parseInt(showstr);

					if (showstr == null|| show == -1)
					{
						rs = stmt.executeQuery("SELECT products.* FROM products, cart WHERE products.ID=cart.PRODUCT AND cart.USERID IN (SELECT ID FROM users WHERE NAME ='" +  (String)session.getAttribute("user") + "');");
						rs2 = stmt2.executeQuery("SELECT SUM(products.price) AS total FROM products, cart WHERE products.ID=cart.PRODUCT AND cart.USERID IN (SELECT ID FROM users WHERE NAME ='" +  (String)session.getAttribute("user") + "');");

					}
					while (rs.next())
					{
						String ID = rs.getString("ID");
		%>
        <tr>
        <form method="GET" action="cart.jsp">
        <td align="center"> <%= ID %></td>
        <td><div style="resize: none;" rows="1" cols="15" name="newname"><%= rs.getString("name") %></div></td>
        <td><div style="resize: none;" rows="1" cols="15" name="newsku"><%= rs.getInt("sku") %></div></td>
        <td><div style="resize: none;" rows="1" cols="15" name="newprice">$<%= rs.getDouble("price") %></div></td>



        <input type="hidden" id=<%= "action"+ID %> name="action" value="" />
        <input type="hidden" name="show" value=<%= show %> />
        </form>
        </tr>
            <%
					}
				}


			} catch (SQLException e) {
				%><%= "There was an error attempting to "+result %><%

			}
			if (!okay) {
		%><%= "There was an attempting to "+result %><%}%>
        </table>
        <input type="hidden" id="param" name="action" value="" />
        <input type="hidden" id="showing" name="showing" value=<%= catID %> />
        </td>
        </tr>
        </table>
        </form>
        <%rs2.next();%>

        <%if (request.getParameter("action") == null) {%>
        Your total: <%= rs2.getString("total") %>
        <form method="POST" action="confirmation.jsp">
            <input type="text" name="creditcard" placeholder="Credit Card Number" required/>
            <input type="submit" value="Buy cart"/>
        </form><%}%>
        </body>
        </html>