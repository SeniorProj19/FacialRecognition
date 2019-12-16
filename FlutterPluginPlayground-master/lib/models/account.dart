class AccountsList {
  final List<Account> accounts;

  AccountsList({
    this.accounts,
  });

  factory AccountsList.fromJson(List<dynamic> parsedJson) {

    List<Account> accounts = new List<Account>();
    accounts = parsedJson.map((i)=>Account.fromJson(i)).toList();

    return new AccountsList(
      accounts: accounts,
    );
  }
}

class Account{
  final int usernum;
  final String username;
  final String first_name;
  final String last_name;
  final String email;
  final String company;
  final String job;
  final String about;
  final String city;
  final String state;
  final String base64Image;
  final int age;
  final String education;
  bool loaded = false;

  Account({
    this.usernum,
    this.username,
    this.first_name,
    this.last_name,
    this.email,
    this.job,
    this.company,
    this.about,
    this.city,
    this.state,
    this.base64Image,
    this.age,
    this.education

  });

  factory Account.fromJson(Map<String, dynamic> json){
    return new Account(
      usernum: json['usernum'],
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      company: json['curr_company'],
      job: json['job_title'],
      about: json['about_me'],
      city: json['city'],
      age: json['age'],
      state: json['state'],
      education: json['education'],
      base64Image: json['profile_pic'],
    );
  }
}