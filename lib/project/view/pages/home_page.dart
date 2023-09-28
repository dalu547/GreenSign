import 'package:GreenSign/project/constants/app_constants.dart';
import 'package:GreenSign/project/controller/user_controller.dart';
import 'package:GreenSign/project/model/user.dart';
import 'package:GreenSign/project/model/user_repository.dart';
import 'package:GreenSign/project/view/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   UserController _controller = UserController();
   UserRepository _repository = UserRepository();
   late User _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();

    _fetchData();


  }

  void _fetchUser() async {
   User user = await _controller.getUser();
   print(user);

    setState(() {
      _user = user;
    });
  }


   void _fetchData() async {
     final data = await _repository.fetchData();
     print(data);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: _user == null
            ? CircularProgressIndicator()
            : UserCard(user: _user),
      ),
    );
  }
}