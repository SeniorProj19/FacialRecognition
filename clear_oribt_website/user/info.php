<?php
require('session.php');
if(!isset($_SESSION['login_user'])){
header("location: index.php"); // Redirecting To Home Page
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
			<b>Your information : <i><?php echo $login_session; ?></i></b>
			<?php
$user=$_SESSION['login_user'];
$q1 = "SELECT * from login where username='$user'";
$s1 = mysqli_query($db,$q1);
$ow1 = mysqli_fetch_array($s1);
$id=$ow1["id"];
$m = "SELECT * from profile where user_id=$id";
$query=mysqli_query($db,$m);
$rowcount=mysqli_num_rows($query);
?>

<table border="1">
<tr>
<td>firstName</td>
<td>lastName</td>
</tr>

<?php
for($i=1;$i<=$rowcount;$i++) {
    $row=mysqli_fetch_array($query);
    

?>
<tr>
<td><?php echo $row["firstName"] ?></td>
<td><?php echo $row["lastName"] ?></td>
</tr>
<?php
}
?>
</table>
            <button type="button" class="cancelbtn" id="logout"><a href="logout.php">Log Out</a></button>
			<button id="back" type="button"  class=" btn-reg" >Go back</button>
                </form>
</div>
<script type="text/javascript">
	 document.getElementById("back").onclick = function () {
        window.location.href = "";
    };
    
</script>
</html>