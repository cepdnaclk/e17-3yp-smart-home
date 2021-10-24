import 'package:untitled/Screens/Login/login_testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EMAIL VALIDATION TESTS', () {
    test('Empty Email Test', () {
      var result = FieldValidator.validateEmail('');
      expect(result, 'Email is not provided');
    });
    test('Invalid Email Test', () {
      var result = FieldValidator.validateEmail('3yp2021.com');
      expect(result, 'Your email is not valid!!');
    });

    test('Valid Email Test', () {
      var result = FieldValidator.validateEmail('varnaraj28@gmail.com');
      expect(result, null);
    });
  });
  group('PASSWORD VALIDATION TESTS', () {
    test('Empty Password Test', () {
      var result = FieldValidator.validatePassword('');
      expect(result, 'Password is not provided');
    });

    test('Invalid Password Test', () {
      var result = FieldValidator.validatePassword('abc');
      expect(result, "Password should be longer than 8 charectors");
    });

    test('Valid Password Test', () {
      var result = FieldValidator.validatePassword('abcd1234');
      expect(result, null);
    });
  });
  group('LOGIN VALIDATION TESTS', () {
    test('Invalid email and password test', () {
      var result1 = FieldValidator.loginValidation("", "");
      expect(result1, "Enter valid Email & Password");
    });

    test('invalid password and valid email test ', () {
      var result2 =
          FieldValidator.loginValidation("varnaraj28@gmail.com", "abc");
      expect(result2, "Enter a Valid Password");
    });

    test('invalid email and valid password test  ', () {
      var result3 = FieldValidator.loginValidation("3yp2021.com", "abcd1234");
      expect(result3, "Enter valid Email");
    });

    test('Valid email and password test', () {
      var result4 =
          FieldValidator.loginValidation("varnaraj28@gmail.com", "abcd1234");
      expect(result4, null);
    });
  });
}
