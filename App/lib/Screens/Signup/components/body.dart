import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/Screens/Login/login_screen.dart';
import 'package:untitled/Screens/Signup/components/background.dart';
import 'package:untitled/Screens/Signup/components/or_divider.dart';
import 'package:untitled/Screens/Signup/components/social_icon.dart';
//import 'package:untitled/Screens/verification/verification_screen.dart';
import 'package:untitled/components/already_have_an_account_acheck.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/components/rounded_password_field.dart';
import 'package:untitled/constants.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  //final String token;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? username;
  String? email;
  String? password;
  String? check_password;
  String? errorMessage = '';

  //http
  signUp(String name, String password, String mail, String confpassword) async {
    try {
      //print("1\n");
      final response = await http.post(
        Uri.parse('http://$publicIP:$PORT/api/user/signup'),
        //Uri.parse('http://54.172.161.228:$PORT/api/user/signup'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'password': password,
          'confpassword': confpassword,
          'mail': mail,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "This Mail Already Conected with an account!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Varification mail sent to your Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
        //return Album.fromJson(jsonDecode(response.body));
      } else {
        print("throw");
        throw Exception('Failed to create album.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              const Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: size.height * 0.01),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.30,
              ),
              RoundedInputField(
                hintText: "Your User Name",
                onChanged: (value) {
                  username = value;
                  setState(() {});
                },
              ),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  email = value;
                  setState(() {});
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  password = value;
                  setState(() {});
                },
                hintText: 'Password',
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  check_password = value;
                  setState(() {});
                },
                hintText: 'Confirm Password',
              ),
              RoundedButton(
                color: username != null &&
                        email != null &&
                        password != null &&
                        check_password != null &&
                        password!.length > 5
                    ? kPrimaryColor
                    : Colors.grey,
                text: "SIGNUP",
                press: () {
                  if (username == null ||
                      email == null ||
                      password == null ||
                      check_password == null) {
                    Fluttertoast.showToast(
                        msg: "Enter all fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  } else if (password != check_password) {
                    print("password not matched");
                    Fluttertoast.showToast(
                        msg: "Password not matched",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  } else if (password!.length < 5) {
                    Fluttertoast.showToast(
                        msg: "Password must be longer than 7 characters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  } else if (username != null &&
                      email != null &&
                      password != null &&
                      password!.length > 5) {
                    print('hello');
                    signUp(username!, password!, email!, check_password!);
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
