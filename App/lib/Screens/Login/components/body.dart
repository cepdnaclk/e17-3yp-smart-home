import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/Screens/Signup/signup_screen.dart';
import 'package:untitled/components/already_have_an_account_acheck.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/components/rounded_password_field.dart';
import 'package:untitled/constants.dart';
import 'background.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

//LogIn Body

class _BodyState extends State<Body> {
  String? email;
  String? password;
  final storage = const FlutterSecureStorage();

  logIn(String password, String mail) async {
    try {
      print("1\n");
      final response = await http.post(
        //Uri.parse('http://192.168.187.195:$PORT/api/user/login'), //4n
        Uri.parse('http://$publicIP:$PORT/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'mail': mail,
        }),
      );

      print(response.statusCode);
      print(response.body);
      print("Login");

      if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Entered email or password Incorrect!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

      if (response.statusCode == 200) {
        //int noOfHomes;

        //print("200");

        Map<String, dynamic> resp = json.decode(response.body);
        //print(output["token"]);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', resp["token"]);
        prefs.setString('userid', resp["userid"]);

        // SharedPreferences prefs1 = await SharedPreferences.getInstance();
        String? tokenValue = prefs.getString('token');
        String? userid = prefs.getString('userid');

        print(tokenValue);
        print(userid);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomesPage();
            },
          ),
          (route) => false,
        );
      } else {
        throw Exception('Failed to create.');
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
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
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
              GestureDetector(
                onTap: () {
                  print("1");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: RichText(
                      text: TextSpan(
                    text: "Forgot Your Password ?",
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    recognizer: TapGestureRecognizer(),
                  )),
                ),
              ),
              RoundedButton(
                color: email != null && password != null && password!.length > 5
                    ? kPrimaryColor
                    : Colors.grey,
                text: "LOGIN",
                press: () {
                  if (email == null || password == null) {
                    Fluttertoast.showToast(
                        msg: "Enter all fields!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  } else if (email != null &&
                      password != null &&
                      password!.length > 5) {
                    logIn(password!, email!);
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
