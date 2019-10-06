<?php
include('login.php'); // Includes Login Script
if(isset($_SESSION['login_user'])){
header("location: "); // Redirecting To Profile Page
}
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="http://localhost/Profile%20GG/css/style.css">

</head>
<body>
    <div class="login-dark">
        <form method="post" action="">
            <h2 class="sr-only">Login Form</h2>
            <div class="illustration"><i class="icon ion-ios-locked-outline"></i></div>
            <div class="form-group"><input class="form-control" required type="username" name="username" placeholder="username"></div>
            <div class="form-group"><input class="form-control" required type="password" name="password" placeholder="Password"></div>
            <div class="form-group"><button class="btn btn-primary btn-block" name="submit" type="submit">Log In</button></div><a href="#" class="forgot">Forgot your email or password?
            </a><br> <a href="#"  class="forgot"><p style="text-align:center">Didnt register?</p> </a><button id="register" type="button"  class=" btn-reg" >Sign up</button>
            <button type="button" class="cancelbtn" id="back">Back to Homepage</button>
                </form>
             
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
</body>
<script type="text/javascript">
    document.getElementById("register").onclick = function () {
        window.location.href = "";
    };

    document.getElementById("back").onclick = function () {
        window.location.href = "";
    };
    
</script>
</html>
