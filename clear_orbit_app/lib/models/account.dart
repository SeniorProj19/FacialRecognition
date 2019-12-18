class Account {
  String name_first;
  String name_last;
  String company;
  String title;
  String account_linkedin;
  String account_email;

  Account(
      {this.name_first, this.name_last, this.company, this.title, this.account_email, this.account_linkedin});

  String getInitials(){
    return name_first.substring(0,1)+name_last.substring(0,1);
  }
}
