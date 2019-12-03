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

  Account({
    this.usernum,
    this.username,
    this.first_name,
    this.last_name,
    this.email,
    this.job,
    this.company
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
    );
  }
}