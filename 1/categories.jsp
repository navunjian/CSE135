<!DOCTYPE html>
<html>
	<head>
		<title>Categories</title>
	</head>
	<body>
		<a href="./categories.jsp">Refresh</a>
		<%@ page import="java.sql.*"%>
		<%!
			boolean usedCategory( String db, String id ) {
				if (db.indexOf("_"+id+"_") > -1)
					return true;
				else return false;
			}
		%>
		<jsp:include page="./header.jsp" />
		<h1>Categories</h1>
		<form method="GET" action="./categories.jsp">
		<table border="1">
			<tr>
				<td><b>ID</b></td>
				<td><b>Name</b></td>
				<td><b>Description</b></td>
			</tr>
			<tr>
				<td></td>
				<td><textarea name="inname" style="resize: none;" rows="1" cols="15" placeholder="Name" ></textarea></td>
				<td><textarea name="indesc" rows="2" cols="30" placeholder="Description"></textarea></td>
				<td><input type="submit" value="Insert" onclick="document.getElementById('param').value='insert'"/></td>
			<tr>
	
        <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
			boolean okay = true;
            String name = "";
			String debug = "";
			String result = "";
			String insertStr = "INSERT INTO categories (NAME, DESCRIPTION) VALUES (?,?);";
			String updateStr = "UPDATE categories SET name=?, description=? WHERE id=?";
			String deleteStr = "DELETE FROM categories WHERE id=?";
			
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/CSE135?" +
                    "user=postgres&password=postgres");
				
				Statement stmt = conn.createStatement();
				rs = stmt.executeQuery("SELECT DISTINCT CATEGORY FROM products;");
				String usedCats = "_";
				while (rs.next()) usedCats += ""+rs.getInt("category")+"_";
				
				conn.setAutoCommit(false);
				String action = request.getParameter("action");
				if (action != null) {
					if (action.equals("insert")) {
						String inname = request.getParameter("inname");
						String indesc = request.getParameter("indesc");
						if (!inname.isEmpty() && !indesc.isEmpty()) {
							pstmt = conn.prepareStatement(insertStr);
							pstmt.setString(1,inname);
							pstmt.setString(2,indesc);
							pstmt.executeUpdate();
							conn.commit();
						} else result = "The requested data modification failed.";
					} else if (action.substring(0,6).equals("update")) {
						String row[] = action.substring("update".length(),action.length()).split("_");
						String inname = request.getParameter("name"+row[1]);
						String indesc = request.getParameter("desc"+row[1]);
						if (!inname.isEmpty() && !indesc.isEmpty()) {
							pstmt = conn.prepareStatement(updateStr);
							pstmt.setString(1,inname);
							pstmt.setString(2,indesc);
							pstmt.setInt(3,Integer.parseInt(row[0]));
							pstmt.executeUpdate();
							conn.commit();
						} else result = "The requested data modification failed.";
					} else if (action.substring(0,6).equals("delete")) {
						Integer id = Integer.parseInt(action.substring("delete".length(),action.length()));
						
						rs = stmt.executeQuery("SELECT * FROM products WHERE category="+id+";");
						if (!rs.next()) {
							pstmt = conn.prepareStatement(deleteStr);
							pstmt.setInt(1,id);
							pstmt.executeUpdate();
							conn.commit();
						} else throw new SQLException("Category can't be deleted yet.");
					}
				}
				rs = stmt.executeQuery("SELECT * FROM Categories");
				int i = 0;
				while(rs.next())
				{
        %>
		
			<tr>
				<td align="center"> <%= rs.getString("ID") %></td>
				<td><textarea style="resize: none;" rows="1" cols="15" name=<%= "name"+i %>><%= rs.getString("name") %></textarea></td>
				<td><textarea rows="2" name=<%= "desc"+i %> cols="30"><%= rs.getString("description") %></textarea></td>
				<td><input type="submit" value="Update" onclick="document.getElementById('param').value='<%= "update"+rs.getString("ID")+"_"+i %>'"/></td>
		<%
					if (!usedCategory(usedCats,rs.getString("ID"))) {
				%><td><input type="submit" value="Delete" onclick="document.getElementById('param').value='<%= "delete"+rs.getString("ID") %>'"/></td><%
					}
		%>
			</tr>
		<%
					i++;
				}
				
				if (!result.isEmpty())
					%><%= result %><%
			} catch (SQLException e) {
				%><%= "The requested data modification failed." %><%
				throw new RuntimeException(e);
			}
		%>
		</table>
		<input type="hidden" id="param" name="action" value="" />
		</form>
	</body>
</html>