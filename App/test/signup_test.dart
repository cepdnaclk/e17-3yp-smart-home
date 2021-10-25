import 'package:untitled/Screens/Signup/signup_testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('USERNAME VALIDATION TESTS', () {
    test('Empty User name Test', () {
      var result = FieldValidator.validateUsername('');
      expect(result, 'User Name is not provided');
    });
  });
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
  group('SIGNUP VALIDATION TESTS', () {
    test('invalid email and empty username test ', () {
      var result = FieldValidator.signupValidation(
          "", "varnaraj28.com", "abcd1234", "abcd1234");
      expect(result, "Enter your user name and a valid email address");
    });
    test('Empty Username test', () {
      var result = FieldValidator.signupValidation(
          "", "varnaraj28@gmail.com", "abcd1234", "abcd1234");
      expect(result, "Enter your User Name");
    });

    test('Invalid email test', () {
      var result1 = FieldValidator.signupValidation(
          "varnaa", "varnaraj.com", "abcd1234", "abcd1234");
      expect(result1, "Enter valid Email address");
    });
    test('Invalid password test', () {
      var result1 = FieldValidator.signupValidation(
          "varnaa", "varnaraj28@gmail.com", "12345", "12345");
      expect(result1, "Password should be longer than 8 charectors");
    });
    test('not matched password test', () {
      var result1 = FieldValidator.signupValidation(
          "varnaa", "varnaraj28@gmail.com", "12345678", "12345679");
      expect(result1, "Passwords does not match");
    });
  });
}
