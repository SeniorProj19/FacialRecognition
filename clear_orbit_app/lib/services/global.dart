import 'package:clear_orbit_app/models/account.dart';

/*Contains global variables for the app*/

bool signedin = true;
Account account_signedin = Account(
    name_first:"Andrew",
    name_last:"Weatherby",
    company:"Veracity Engineering",
    title: "Intern",
    account_email: "weatherba0@students.rowan.edu",
    account_linkedin: "andrew-weatherby"
);
Account account_viewing = account_signedin;