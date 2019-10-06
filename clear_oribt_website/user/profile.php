<?php
require('session.php');
if(!isset($_SESSION['login_user'])){
header("Location: index.php"); // Redirecting To Home Page
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
    <link rel="stylesheet" href="http://localhost/Profile%20GG/css/style.css">

</head>
<body>
    <div class="login-dark">
        <form action="" method="post">
            <h2 class="sr-only">Profile Form</h2>
			<b id="welcome">Welcome : <i><?php echo $login_session; ?></i></b>
            <div class="illustration"><i class="icon ion-ios-locked-outline"></i></div>
            <div class="form-group"><input class="form-control" required type="text" name="firstName" placeholder="first name"></div>
            <div class="form-group"><input class="form-control" required type="text" name="lastName" placeholder="last name"></div>
            <div class="form-group"><button class = "btn btn-primary btn-block" input type = "submit" name="submit">Submit</button></div>
			</a><button id="register" type="button"  class=" btn-reg" >Sign up</button>
			 </a><br> <a href="#"  class="forgot"><p style="text-align:center">Your Submission</p> </a><button id="post" type="button"  class=" btn-reg" >View Post</button>
            <button type="button" class="cancelbtn" id="logout"><a href="logout.php">Log Out</a></button>
                </form>

<?php
/*//checks connection to server
if(!$db){
    echo'db not connected to server';
}*/
//fetches the id that will be used for further implementation in putting content
$user=$_SESSION['login_user'];
$q = "SELECT * from login where username='$user'";
$s = mysqli_query($db,$q);
$ow = mysqli_fetch_array($s);
$id=$ow["id"];
if(isset($_POST['submit'])) {
    /*if(!mysqli_select_db($db, 'profile')) {
        echo'Database not selected';
    }
    else {
        echo'db selected';
    }*/
    $firstName=$_POST['firstName'];
    $lastName=$_POST['lastName'];
    $sql = "INSERT INTO profile (firstName,lastName,user_id) VALUES ('$firstName', '$lastName', '$id')";
//checks to see if the user has successfully entered user information.
if(!mysqli_query($db,$sql)) {
    echo  mysqli_error($db);
}
else {
    echo '<script type="text/javascript">';
echo ' alert("information submitted succesfully")';  //not showing an alert box.
echo '</script>';
}

header("refresh:2; url=profile.php");
}
mysqli_close($db);
?>
</div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/js/bootstrap.bundle.min.js"></script>
</body>
<script type="text/javascript">
	 document.getElementById("post").onclick = function () {
        window.location.href = "";
    };
    
</script>
</html>
