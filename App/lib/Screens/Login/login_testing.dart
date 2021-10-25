import 'package:email_validator/email_validator.dart';

class FieldValidator {
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

  static String? loginValidation(String email, String password) {
    if (validateEmail(email) == null && validatePassword(password) == null) {
      return null;
    } else if (!(validateEmail(email) == null) &&
        !(validatePassword(password) == null)) {
      return "Enter valid Email & Password";
    } else if (!(validatePassword(password) == null)) {
      return "Enter a Valid Password";
    } else if (!(validateEmail(email) == null)) {
      return "Enter valid Email";
    }
    return null;
  }
}
