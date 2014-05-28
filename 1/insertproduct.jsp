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
				<td><textarea name="inname" style="resize: none;" rows="1" cols="15" placeholder="Name" /></textarea></td>
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
			
			} catch (SQLException e) {
			
			}
		%>
	</body>
</html>