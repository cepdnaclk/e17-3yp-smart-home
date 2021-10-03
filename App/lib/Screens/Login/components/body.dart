
//import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/Screens/Signup/signup_screen.dart';
import 'package:untitled/components/already_have_an_account_acheck.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/components/rounded_password_field.dart';
import 'package:untitled/constants.dart';
import '../../home_page.dart';
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

class _BodyState extends State<Body> {
  String? email;
  String? password;
  final storage = const FlutterSecureStorage();

  logIn(String password, String mail) async {

    try {
      //print("1\n");
      final response = await http.post(
        Uri.parse('http://192.168.187.195:5005/api/user/login'),
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
        //print("200");

        Map<String, dynamic> output = json.decode(response.body);
        //print(output["token"]);

        await storage.write(key: "token", value: output["token"]);
        String? tok = await storage.read(key: "token");
        print("token from stored");
        print(tok);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
          (route) => false,
        );
        //return Album.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
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
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
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
            RoundedButton(
              color: email != null && password != null && password!.length > 5
                  ? kPrimaryColor
                  : Colors.grey,
              text: "LOGIN",
              press: () {
                if (email == null || password == null) {
                  Fluttertoast.showToast(
                      msg: "Enter all fields",
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
    );
  }
}
