<html>
  <head>
    <title>Signup</title>
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
			String result = "";
			
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
				Statement insertUser = conn.createStatement();
				
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
				name = request.getParameter("name");
				String role = request.getParameter("role");
				String age = request.getParameter("age");
				String state = request.getParameter("state");
				if (age.isEmpty() || state.equals("unselected") || role.equals("unselected") || name.isEmpty())
					throw new SQLException("Unfilled form.");
					
				statement.setString(1,name);
                rs = statement.executeQuery();
				
				if (rs.next()) throw new SQLException("Already exists.");
				
				insertUser.executeUpdate("INSERT INTO users(NAME,ROLE,AGE,STATE) VALUES ('"+name+"', '"+role+"', "+age+", '"+state+"')");
				
				conn.commit();
            %>
			
			<%
			} catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
				result = e.getMessage();
				okay = false;
            }
			%>
			
			<%= (okay) ? "You have successfully signed up, "+name : "Your signup failed." %>
  </body>
</html>
