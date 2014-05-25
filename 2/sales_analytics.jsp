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
        <option value="unselected">All States</option>
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
                    "jdbc:postgresql://127.0.0.1:5432/cse135?" +
                    "user=postgres&password=postgres");

				Statement stmt = conn.createStatement();
				rs = stmt.executeQuery("SELECT name FROM categories;");

				while (rs.next()) {
        %>
        <option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option>
<%}
}catch(Exception e){}
		%>

        </select>

        <select name="ages">
        <option value="allages">All Ages</option>
        <option value="12-18">12-18</option>
        <option value="18-45">18-45</option>
        <option value="45-65">45-65</option>
        <option value="65-">65-</option>
        </select>
        <input type="submit"/>
        </form>

        <div id="results-container">


        </div>


        <!-- Get Submitted Fields -->

        <%
        String rows = request.getParameter("rows");
        String category = request.getParameter("category");
        String state = request.getParameter("state");
        String ages = request.getParameter("ages");
        %>



        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
        </body>
        </html>
