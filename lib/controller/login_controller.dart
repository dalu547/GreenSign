import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';


import '../model/album.dart';
import '../model/login.dart';

class LoginController {
  var isLoading = false.obs;

  // Future<User> getUser() async {
  //   // Fetch user data from a remote API or a database
  //   return User(name: "Kalla Dalayya", email: "dalu547@gmail.com");
  // }

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

   Future login(String username,String password) async {

    try{
      isLoading(true);
      final response = await http.post(
        Uri.parse('http://10.80.13.29:8000/login'),
        body: jsonEncode({'email_address': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          // Successful login
          // You can handle the response here (e.g., store tokens, navigate to the next screen)
          print('Login successful');
          print(response.body);
          return Login.fromJson(jsonDecode(response.body));
        } else {
          // Handle invalid or empty JSON response
          print('Invalid JSON response');
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // Failed login
        // Handle error here (e.g., show an error message)
        print('Login failed');
      }
    }catch(error){
     // Handle network or other errors here
     print('Error: $error');
    }finally{
      isLoading(false);
    }
  }

}