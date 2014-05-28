<!DOCTYPE html>
<html>
	<head>
		<title>Products</title>
	</head>
	<body>
		<%!
			String selectCat(String catDrop, String id) {
				return catDrop.substring(0,catDrop.indexOf(id)+id.length())
						+ " selected "
						+ catDrop.substring(catDrop.indexOf(id)+id.length());
			}
		%>
		<%@ page import="java.sql.*"%>
		<jsp:include page="./header.jsp" />
		<h1>Products</h1>
		<form method="GET" action="./products.jsp">
		<table>
			<tr>
				<td><h3>Categories</h3></td>
				<td align="right"><input type="text" name="search" placeholder="Search"/></td>
		</form>
			</tr>
			<tr>
				<td valign="top"><a href="./products.jsp?show=-2">Insert Product</a><br/>
				<a href="./products.jsp?show=-1">All Products</a><br/>
        <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
			boolean okay = true;
			String result = "";
			int show = -3;
			int catID = -1;
			String insertStr = "INSERT INTO products (NAME,SKU,PRICE,CATEGORY) VALUES (?,?,?::numeric::money,?);";
			String updateStr = "UPDATE products SET name=?, sku=?, price=?::numeric::money, category=? WHERE id=?";
			String deleteStr = "DELETE FROM products WHERE id=?";
			
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/CSE135?" +
                    "user=postgres&password=postgres");
				
				conn.setAutoCommit(false);
				
				Statement stmt = conn.createStatement();
				
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
					if (!newsku.isEmpty()) {
						if (command.equals("insert"))
							rs = stmt.executeQuery("SELECT * FROM Products WHERE SKU="+newsku+";");
						else
							rs = stmt.executeQuery("SELECT * FROM Products WHERE SKU="+newsku+" AND id<>"+action.substring(6)+";");
						skucheck = !rs.next();
					}
					if (command.equals("insert") && !newname.isEmpty() && skucheck && !newsku.isEmpty() && !(nprice < 0) && !newcat.equals("-1")) {
						pstmt = conn.prepareStatement(insertStr);
						pstmt.setString(1,newname);
						pstmt.setInt(2, Integer.parseInt(newsku));
						pstmt.setDouble(3,nprice);
						pstmt.setInt(4,Integer.parseInt(newcat));
						pstmt.executeUpdate();
						conn.commit();
					} else if (command.equals("update") && !newname.isEmpty() && skucheck && !newsku.isEmpty() && !(nprice < 0) && !newcat.equals("-1")) {
						pstmt = conn.prepareStatement(updateStr);
						pstmt.setString(1,newname);
						pstmt.setInt(2, Integer.parseInt(newsku));
						pstmt.setDouble(3,nprice);
						pstmt.setInt(4,Integer.parseInt(newcat));
						pstmt.setInt(5,Integer.parseInt(action.substring(6)));
						pstmt.executeUpdate();
						conn.commit();
					} else if (command.equals("delete")) {
						pstmt = conn.prepareStatement(deleteStr);
						pstmt.setInt(1,Integer.parseInt(action.substring(6)));
						pstmt.executeUpdate();
						conn.commit();
					} else okay = false;
				}
				rs = stmt.executeQuery("SELECT * FROM Categories;");
				String catDrop = "";
				while (rs.next())
				{
					catDrop += "<option value="+rs.getInt("id")+">"+rs.getString("name")+"</option>";
		%>
					<a href="./products.jsp?show=<%= rs.getString("id") %>"><%= rs.getString("name") %></a><br/>
		<%
				}
		%>
			</td>
			<td>
		<table border="1">
			<tr>
				<td><b>ID</b></td>
				<td><b>Name</b></td>
				<td><b>SKU</b></td>
				<td><b>Price</b></td>
				<td><b>Category</b></td>
			</tr>
		<%
				String search = request.getParameter("search");
				if (search == null) {
				String showstr = request.getParameter("show");
				if (showstr != null) show = Integer.parseInt(showstr);
				if (showstr == null || show == -2) {
		%>
			<tr>
				<form method="GET" action="./products.jsp">
				<td></td>
				<td><textarea name="newname" style="resize: none;" rows="1" cols="15" placeholder="Name" ></textarea></td>
				<td><textarea name="newsku" style="resize: none;" rows="1" cols="15" placeholder="SKU" ></textarea></td>
				<td><textarea name="newprice" style="resize: none;" rows="1" cols="15" placeholder="Price" ></textarea></td>
				<td><select name="newcat">
					<option value="-1">Select Category</option>
					<%= catDrop %>
				</select></td>
				<td><input type="submit"value="Insert" onclick="document.getElementById('param').value='insert'"/></td>
				<input type="hidden" name="action" value="insert" />
				</form>
			<tr>
		<%
				} else if (showstr != null) {
					if (show == -1)
					{
						rs = stmt.executeQuery("SELECT * FROM Products ORDER BY category;");
					} else {
						rs = stmt.executeQuery("SELECT * FROM Categories WHERE id="+show+";");
						if (!rs.next()) response.sendRedirect("./products.jsp");
						catID = show;
						rs = stmt.executeQuery("SELECT * FROM Products WHERE category="+show+";");
					}
					while (rs.next())
					{
						String ID = rs.getString("ID");
		%>
			<tr>
				<form method="GET" action="products.jsp">
				<td align="center"> <%= ID %></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newname"><%= rs.getString("name") %></textarea></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newsku"><%= rs.getInt("sku") %></textarea></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newprice"><%= rs.getDouble("price") %></textarea></td>
				<td><select name="newcat">
					<option value="-1">Select Category</option>
					<%= selectCat(catDrop,rs.getString("category")) %>
				</select></td>
				<td><input type="submit" value="Update" onclick="document.getElementById('<%= "action"+ID %>').value='<%= "update"+ID %>'"/></td>
				<td><input type="submit" value="Delete" onclick="document.getElementById('<%= "action"+ID %>').value='<%= "delete"+ID %>'"/></td>
				<input type="hidden" id=<%= "action"+ID %> name="action" value="" />
				<input type="hidden" name="show" value=<%= show %> />
				</form>
			</tr>
		<%
					}
				}
				}
				else {
					int scope = Integer.parseInt(request.getParameter("showing"));
					catID = scope;
					if (scope==-1) {
						rs = stmt.executeQuery("SELECT * FROM Products WHERE name LIKE '%"+search+"%';");
					
					} else {
						rs = stmt.executeQuery("SELECT p.* FROM Products p WHERE p.category="+scope+" and p.name LIKE '%"+search+"%';");
					
					}
					while (rs.next())
					{
						String ID = rs.getString("ID");
		%>
			<tr>
				<form method="GET" action="./products.jsp">
				<td align="center"> <%= ID %></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newname"><%= rs.getString("name") %></textarea></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newsku"><%= rs.getInt("sku") %></textarea></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name="newprice"><%= rs.getDouble("price") %></textarea></td>
				<td><select name="newcat">
					<option value="-1">Select Category</option>
					<%= selectCat(catDrop,ID) %>
				</select></td>
				<td><input type="submit" value="Update" onclick="document.getElementById('<%= "action"+ID %>').value='<%= "update"+ID %>'"/></td>
				<td><input type="submit" value="Delete" onclick="document.getElementById('<%= "action"+ID %>').value='<%= "delete"+ID %>'"/></td>
				<input type="hidden" id=<%= "action"+ID %> name="action" value="" />
				<input type="hidden" name="show" value=<%= scope %> />
				</form>
			</tr>
		<%
					}
				}
			} catch (SQLException e) {
				%><%= "There was an error attempting to "+result %><%

			}
			if (!okay) {
		%><%= "There was an error attempting to "+result %><%}%>
		</table>
		<input type="hidden" id="param" name="action" value="" />
		<input type="hidden" id="showing" name="showing" value=<%= catID %> />
		</td>
		</tr>
		</table>
		</form>
	</body>
</html>