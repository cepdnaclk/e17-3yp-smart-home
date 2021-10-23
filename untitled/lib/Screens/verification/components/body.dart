import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/Screens/Signup/components/background.dart';
import 'package:untitled/Screens/profile_adding/ProfileAdding.dart';
import 'package:untitled/constants.dart';

class Body extends StatefulWidget {
  final email;
  final userName;
  Body({required this.email, required this.userName});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(seconds: 2), (timer) async {
    //   User? loggedInUser = FirebaseAuth.instance.currentUser;
    //   await loggedInUser!.reload();
    //   print('hiii');
    //   print(loggedInUser.emailVerified);
    //   if (loggedInUser.emailVerified) {
    //     print('verified');
    //     timer.cancel();
    //     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAddingScreen(email: widget.email, userName: widget.userName,)));
    //   }
    // });
  }

  @override
  // void dispose() async {
  //   User? loggedInUser = _auth.currentUser;
  //   await loggedInUser!.reload();
  //   print(loggedInUser.emailVerified);
  //   loggedInUser.emailVerified ? null : loggedInUser.delete();
  //   timer!.isActive ? timer!.cancel() : null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Text(
                kVerificationText,
                style: TextStyle(fontSize: 17, color: Colors.purple),
              ),
            )
          ],
        ),
      ),
    );
  }
}
