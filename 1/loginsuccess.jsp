<html>
  <head>
    <title>Login</title>
  </head>
  <body>
	
	    <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>

    <%-- -------- Open Connection Code -------- --%>

            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
			boolean okay = true;
            String name = "";
			String debug = "";
			String result = "Successful login.";
			
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/CSE135?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
				conn.setAutoCommit(false);
                PreparedStatement statement = conn.prepareStatement("SELECT * FROM users WHERE name=?");
				
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
				name = request.getParameter("name");
				if (name.isEmpty()) throw new SQLException("Not filled");
					
				statement.setString(1,name);
                rs = statement.executeQuery();
				
				if (!rs.next()) throw new SQLException("The provided name "+name+" does not exist.");
				conn.commit();
				session.setAttribute("user",name);
				session.setAttribute("role",rs.getString("role"));

            %>
			
			<%
			} catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
				result = e.getMessage();
				okay = false;
            }
			%>

    <%-- -------- Include menu HTML code -------- --%>
			<% if (okay) { %>
				<jsp:include page="./header.jsp"/>
			<% } %>
			
			<%= (okay) ? "Hello, "+session.getAttribute("user")+".<br/>" : "" %>
			
			<% if (!okay) {%>
				<jsp:include page="./login.jsp" flush="true" />
			<% } %>
			<%= result %>
			
  </body>
</html>