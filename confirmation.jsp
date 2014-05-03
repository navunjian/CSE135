    <!DOCTYPE html>
        <html>
        <head>
        <title>Cart</title>
        </head>
        <body>
        <%@ page import="java.sql.*"%>

        <jsp:include page="./header.jsp" />


        <%
        if (request.getParameter("creditcard") != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

			int show = -3;
			int catID = -1;



            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/CSE135?" +
                    "user=postgres&password=postgres");

				conn.setAutoCommit(false);
			String deleteStr = "DELETE FROM cart WHERE USERID IN (SELECT ID FROM users WHERE NAME ='" +  (String)session.getAttribute("user") + "');";



						pstmt = conn.prepareStatement(deleteStr);

						pstmt.executeUpdate();
						conn.commit();


				}
				catch(Exception e){}
				%>        Congrats! You just bought a bunch of stuff!
        <%}else{%>
        Bad request<%}%>
        </body>
        </html>