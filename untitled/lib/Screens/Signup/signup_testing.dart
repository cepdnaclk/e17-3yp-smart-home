import 'package:email_validator/email_validator.dart';

class FieldValidator {
  static String? validateUsername(String value) {
    if (value.isEmpty)
      return 'User Name is not provided';
    else {
      return null;
    }
  }

  static String? validateEmail(String value) {
    if (value.isEmpty)
      return 'Email is not provided';
    else if (!EmailValidator.validate(value))
      return 'Your email is not valid!!';
    else if (!value.isEmpty && EmailValidator.validate(value)) return null;
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty)
      return 'Password is not provided';
    else if (value.length < 8)
      return "Password should be longer than 8 charectors";
    else
      return null;
  }

  static String? validateCPassword(String value) {
    if (value.isEmpty)
      return 'Confirm Your Password';
    else
      return null;
  }

  static String? signupValidation(
      String userName, String email, String password, String c_password) {
    if (validateUsername(userName) == null &&
        validateEmail(email) == null &&
        validatePassword(password) == null &&
        password == c_password) {
      return null;
    } else if (!(validateUsername(userName) == null) &&
        !(validateEmail(email) == null)) {
      return "Enter your user name and a valid email address";
    } else if (!(validateUsername(userName) == null)) {
      return 'Enter your User Name';
    } else if (!(validateEmail(email) == null)) {
      return 'Enter valid Email address';
    } else if (!(validatePassword(password) == null)) {
      return "Password should be longer than 8 charectors";
    } else if (password != c_password) {
      return "Passwords does not match";
    }
    return null;
  }
}
