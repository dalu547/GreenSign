import 'dart:convert';

import 'package:GreenSign/project/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:GreenSign/project/constants/app_constants.dart';


class UserRepository {
  Future<User> getUser() async {
    // Fetch user data from a remote API or a database
    return User(name: "Dalayya Kalla", email: "dalu547@gmail.com");
  }

  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Function to fetch data from the API
  Future fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
}