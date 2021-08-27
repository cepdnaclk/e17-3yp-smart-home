import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:sample/Screens/Login/login_screen.dart';
import 'package:sample/Screens/Signup/components/background.dart';
import 'package:sample/Screens/Signup/components/or_divider.dart';
import 'package:sample/Screens/Signup/components/social_icon.dart';
import 'package:sample/Screens/verification/verification_screen.dart';
import 'package:sample/components/already_have_an_account_acheck.dart';
import 'package:sample/components/rounded_button.dart';
import 'package:sample/components/rounded_input_field.dart';
import 'package:sample/components/rounded_password_field.dart';
import 'package:sample/constants.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  String? errorMessage = '';

  signUp(email, password) async {
      try {
        print(email);
        var user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email,
            password: password);
        User? loggedInUser = FirebaseAuth.instance.currentUser;
        loggedInUser!.sendEmailVerification();
        print('test');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerificationScreen(email: email, userName: '',)));
        /*FirebaseFirestore.instance
            .collection('User')
            .doc(loggedInUser!.uid)
            .set({
          'email': _emailController.text.trim(),
          'name': _nameController.text.trim(),
          'userName':
          _usernameController.text.trim().toLowerCase(),
          'userType': type,
        });
        loggedInUser
            .updateDisplayName(_nameController.text.trim());
        loggedInUser.updatePhotoURL(type);
        DataManagement.saveLoggedIn(true);
        DataManagement.saveUserInfo(kUserTypeKey, type);
        DataManagement.saveUserInfo(
            kEmailKey, _emailController.text.trim());
        DataManagement.saveUserInfo(
            kNameKey, _nameController.text.trim());
        DataManagement.saveUserInfo(kUserNameKey,
            _usernameController.text.trim().toLowerCase());*/

      } on Exception catch (e) {
        print(e);
        errorMessage = e.toString().split(']')[1];
        setState(() {});
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
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
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
              color: email != null && password != null && password!.length > 5 ? kPrimaryLightColor :Colors.grey,
              text: "SIGNUP",
              press: () {
                if(email != null && password != null && password!.length > 5) {
                  print('hello');
                  signUp(email, password);
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
    );
  }
}
