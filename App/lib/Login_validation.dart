import 'package:email_validator/email_validator.dart';

class FieldValidator {
  static String validateEmail(String value) {
    if (value.isEmpty)
      return 'Enter Email';
    else if (!EmailValidator.validate(value))
      return 'Enter Valid Email!';
    else if (!value.isEmpty && EmailValidator.validate(value))
      return "Email is valid";
    return null;
  }
static String validatePassword(String value) {
    if (value.isEmpty)
      return 'Enter Password';
    else if (value.length < 4)
      return "Enter a password with more than 4 characters";
    else
      return null;
  }

  static String loginValidation(String email, String password) {
    if (validateEmail(email) == "Email is valid" &&
        validatePassword(password) == null) {
      return "email and password is valid";
    } else if (!(validateEmail(email) == "Email is valid") &&
        !(validatePassword(password) == null)) {
      return "email and password is not valid";
    } else if (!(validatePassword(password) == null)) {
      return "password is not valid";
    } else if (!(validateEmail(email) == "Email is valid")) {
      return "Email is not valid";
    }
    return null;
  }
}
