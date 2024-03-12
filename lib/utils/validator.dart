class Validators {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter valid Email/Username.';
    }
    // if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    //   return 'Please enter valid Email.';
    // }
    return "";
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter valid Password.';
    }
    // if (value.length < 8) {
    //   return 'Please enter valid Password.';
    // }
    return "";
  }
}
