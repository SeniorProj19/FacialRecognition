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
  final String username;
  final String fullname;
  final String email;
  final String company;

  Account({
    this.username,
    this.fullname,
    this.email,
    this.company
  }) ;

  factory Account.fromJson(Map<String, dynamic> json){
    return new Account(
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'],
      company: json['company'],
    );
  }
}