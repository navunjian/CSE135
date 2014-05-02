<!DOCTYPE html>
<html>
	<head>
		<title>Categories</title>
	</head>
	<body>
    <jsp:include page="./header.jsp"/>
		<a href="./categories.jsp">Refresh</a>
		<%@ page import="java.sql.*"%>

    <h2>
    Product Categories
    </h2>
		<form method="POST" action="./categories.jsp">
		<table border="1">
			<tr>
				<td><b>ID</b></td>
				<td><b>Name</b></td>
				<td><b>Description</b></td>
			</tr>
			<tr>
				<td></td>
				<td><input name="inname" type="text" placeholder="Name" /></td>
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
			String result = "Successful login.";
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
						}
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
						}
					} else if (action.substring(0,6).equals("delete")) {
						Integer id = Integer.parseInt(action.substring("delete".length(),action.length()));
						pstmt = conn.prepareStatement(deleteStr);
						pstmt.setInt(1,id);
						pstmt.executeUpdate();
						conn.commit();
					}
				}
				Statement stmt = conn.createStatement();
				rs = stmt.executeQuery("SELECT * FROM Categories");
				int i = 0;
				while(rs.next())
				{
        %>
		
			<tr>
				<td align="center"> <%= rs.getString("ID") %></td>
				<td><input type="text" name=<%= "name"+i %> value=<%= rs.getString("name") %> /></td>
				<td><textarea rows="2" name=<%= "desc"+i %> cols="30"><%= rs.getString("description") %></textarea></td>
				<td><input type="submit" value="Update" onclick="document.getElementById('param').value='<%= "update"+rs.getString("ID")+"_"+i %>'"/></td>
				<td><input type="submit" value="Delete" onclick="document.getElementById('param').value='<%= "delete"+rs.getString("ID") %>'"/></td>
			</tr>
			
		<%
				i++;
				}
			} catch (SQLException e) {
				%><%= "There was an error: "+e.getMessage() %><%
			}
		%>
		</table>
		<input type="hidden" id="param" name="action" value="" />
		</form>
	</body>
</html>