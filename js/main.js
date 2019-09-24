<script src = "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>


var attempt = 5; // Variable to count number of attempts.
//Executes on click of login button.
$( "#submit" ).on( "click", function() {
var username = document.getElementById("username").value;
var password = document.getElementById("password").value;
if ( username == "a" && password == "b"){
alert ("Login successfully");
 $('.profileForm').toggle(); //Show user Profile and hide the other forms
 $('.loginform').hide();
 $('.registerform').hide();
}
else{
attempt --;// Decrementing by one.
alert("You have left "+attempt+" attempt;");
// Disabling fields after 5 attempts.
if( attempt == 0){
document.getElementById("username").disabled = true;
document.getElementById("password").disabled = true;
document.getElementById("submit").disabled = true;
return false;
}
}
});

//show form again
$( ".close" ).on( "click", function() {
  $('.loginform').show();
  $('.registerform').show();
});

$( ".cancelbtn" ).on( "click", function() {
  $('.loginform').show();
  $('.registerform').show();
});

//switch function for registration and login
$('.register').each(function(i){
  $(this).click(function(){
  $('.registerform').addClass('registerform-active');
  $('.login').css('background-color','#A9E2F3');
  $('.register').css('color','#A9E2F3');
  });
});
$('.login').each(function(i){
  $(this).click(function(){
  $('.registerform').removeClass('registerform-active');
   $('.register').css('background-color','#0B4C5F');
  });
});

//uploading picture function
function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            $('#imagePreview').css('background-image', 'url('+e.target.result +')');
            $('#imagePreview').fadeIn(650);
        }
        reader.readAsDataURL(input.files[0]);
    }
}
$("#imageUpload").change(function() {
    readURL(this);
});
