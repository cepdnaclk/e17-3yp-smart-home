import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sample/Screens/Signup/signup_screen.dart';
import 'package:sample/components/already_have_an_account_acheck.dart';
import 'package:sample/components/rounded_button.dart';
import 'package:sample/components/rounded_input_field.dart';
import 'package:sample/components/rounded_password_field.dart';
import 'package:sample/constants.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? email;
  String? password ;
  logIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
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
                setState(() {
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
                setState(() {

                });
              },
            ),
            RoundedButton(
              color: email != null && password != null && password!.length > 5 ? kPrimaryColor :Colors.grey,
              text: "LOGIN",
              press: () {
                if (email != null && password != null && password!.length > 5 ) {
                  logIn();
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
