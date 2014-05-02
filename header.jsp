    <%-- Import the java.sql package --%>

    <div class="header">
        <div class="logo">
            Logo goes here!
        </div>
        <% Object user = session.getAttribute("user");
            if(user == null)
                response.sendRedirect("./logout.jsp");
                else{
        %>

        <p> Logged in as:
            <%= user%>
        </p>
        <% } %>

<p>
            <% if("owner".equals(session.getAttribute("role") )){ %>

        <a href="./logout.jsp">Logout</a>
            <% }
               else if("customer".equals(session.getAttribute("role") )){ %>

               <jsp:include page="./custheader.jsp"/>
        <a href="./logout.jsp">Logout</a>

            <% } else {%>
                <jsp:include page="./nologinheader.jsp"/>
            <% } %>

        </p>

    </div>
