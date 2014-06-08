<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body >
<%
if(session.getAttribute("name")!=null)
{
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String  name=null, price_str=null, quantity_str=null, pid_str=null;
	int pid=0, quantity=0;
	float price=0;
	try { 
			name =	request.getParameter("name"); 
			price_str		  =	request.getParameter("price"); 
			quantity_str  =	request.getParameter("quantity"); 
			pid_str =	request.getParameter("id"); 
			 price    = Float.parseFloat(price_str);
			 pid=Integer.parseInt(pid_str);
			
	}
	catch(Exception e) 
	{ 
		 name=null; price_str=null; quantity_str=null; pid_str=null;
	      pid=0; quantity=0; price=0;
	
	}

	 {
			 quantity=Integer.parseInt(quantity_str);
			if(quantity>0)
			{
				 Connection conn=null;
				Statement stmt;

				{
					
					
				
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://127.0.0.1:5432/cse135";
					String user="postgres";
					String password="postgres";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					String  SQL="INSERT INTO carts (uid, pid, quantity,price) VALUES("+userID+", "+pid+", "+quantity+" , "+price+");";
					
					{
						conn.setAutoCommit(false);
						stmt.execute(SQL);
						conn.commit();
						conn.setAutoCommit(true);
						response.sendRedirect("buyShoppingCart.jsp");
					}

					 
				}

			} 
			else
			{
			out.println("Fail! Only a postive integer is allowed for  <font color='#ff0000'>quantity</font><br> Please <a href=\"product_order.jsp?id="+pid+"\" target=\"_self\">buy it</a> again.");
			}
		}

}
%>

</body>
</html>