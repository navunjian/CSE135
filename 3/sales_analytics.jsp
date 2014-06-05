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
				rs = stmt.executeQuery("SELECT name, id FROM categories;");

				while (rs.next()) {
        %>
        <option value="<%=rs.getString("id")%>"><%=rs.getString("name")%></option>
		<%		}%>

        </select>
		
        <input id="submitButton" type="submit" onclick="document.getElementById('rowOffset').value =0;document.getElementById('colOffset').value =0"/>



        <!-- Get Submitted Fields -->
		<table border="1">
		<tr>
        <%
        String rows = request.getParameter("rows");
		if (rows == null) rows = "customers";
		
		%><td><b><%= rows  %></b></td><%
        String category = request.getParameter("category");
        String state = request.getParameter("state");
        Boolean filtered = false;
        String filter="";
		String groupAppend = "";

        if(!state.equals("allstates")){
            filter += " WHERE state='" +state + "' ";
			filtered = true;
        }

        if(!category.equals("allcategories")) {
			filter += ((filtered) ? " AND ":" WHERE ")+"catid = " + category +" ";
			groupAppend += "catid, ";
		}
		if (!filter.isEmpty())
			rs = stmt.executeQuery("select p.name, b.pid, b.sum FROM (select pid, "+groupAppend+"sum(sales) as sum from aggregatesales "+filter+"group by "+groupAppend+"pid ORDER BY sum DESC) as b, products p WHERE p.id = b.pid LIMIT 10");
		else
			rs = stmt.executeQuery("select name, pid, sales as sum from productsales, products p where pid = p.id order by sales DESC LIMIT 10");
			
		int prod_ids[] = new int[10];
		int i = 0;
		while (rs.next()) {
			prod_ids[i++] = rs.getInt("pid");
		%>
			<td><b><%= rs.getString("name")+" ("+rs.getString("sum")+")" %><b></td>
		<%
		}
		%></tr><%
		rs.close();
		String rowfilter = "";
		if (rows.equals("customers")) {
			rs = stmt.executeQuery("SELECT uid as unit, pid, sales FROM aggregatesales"+filter);
			rowfilter = "uid = ";
		} else {
			rs = stmt.executeQuery("SELECT state as unit, sum(sales) as sum FROM aggregatesales "+filter+"GROUP BY state ORDER BY sum DESC LIMIT 20");
			rowfilter = "state = ";
		}
		while (rs.next()) {
		%><tr><td><b><%= rs.getString("unit")+" ("+rs.getString("sum")+")" %>
		<%
			String filt = rowfilter + ((rows.equals("customers")) ? rs.getString("unit") : "'"+rs.getString("unit")+"'");
			pstmt = conn.prepareStatement("SELECT sum(sales) as sum FROM aggregatesales WHERE "+filt+" AND pid = ?");
			for(i = 0; i < 10; ++i) {
				pstmt.setInt(1, prod_ids[i]);
				rs2 = pstmt.executeQuery();
				if (rs2.next()) {
					%><td><%= rs2.getString("sum") %></td><%
				} else {
					%><td><%= 0 %></td><%
				}
			}
		%>
		</tr>	
		<% } %>
		</table>
        <%

}catch(Exception e){throw e;}
		%>
        </form>
            
 
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="js/purl.js"></script>

                
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
               
        <script>
        var storeCategory = $.url().param("category");
        var storeRows = $.url().param("rows");
        var storeState = $.url().param("state");

        </script>
        </body>
        </html>
