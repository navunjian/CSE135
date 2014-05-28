<!DOCTYPE html>
<html>
<head>
<title>Login Page</title>
<script type="text/javascript"></script>
</head>
<body>
    <jsp:include page="./header.jsp"/>

    <h1>Login</h1>
<form id="signup_form" method="GET" action="loginsuccess.jsp">
<input type="text" name="name" placeholder="Name" /><br/>
<input type="submit" value="Login"/>
    </form>
</body>
</html>