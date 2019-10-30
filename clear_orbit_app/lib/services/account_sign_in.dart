import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Post> fetchPost({Map body}) async {
  final response =
  await http.post('http://54.166.243.43:8080/mlogin', body: body);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    String res = response.body;
    print(res);
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String username;
  final String password;
  Post({this.username, this.password});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      password: json['password']
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}