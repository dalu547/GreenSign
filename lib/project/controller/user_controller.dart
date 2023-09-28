import 'package:GreenSign/project/model/user.dart';
import 'package:GreenSign/project/model/user_repository.dart';

class UserController {
 late Future<User> _user;
  UserRepository repository = UserRepository();

  // this function will handle the login button press
  Future<User> getUser() async {
    try {

      _user = repository.getUser();

    } catch (error) {
      // if authentication fails, set the error message

    }
    return _user;
  }

}