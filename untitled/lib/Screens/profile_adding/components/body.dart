import 'dart:async';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/Screens/Login/login_screen.dart';
import 'package:untitled/Screens/Signup/components/background.dart';
import 'package:untitled/Screens/Signup/components/or_divider.dart';
import 'package:untitled/Screens/Signup/components/social_icon.dart';
import 'package:untitled/Screens/home_page.dart';
import 'package:untitled/components/already_have_an_account_acheck.dart';
import 'package:untitled/components/card_widget.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/components/rounded_password_field.dart';
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
  String? email;
  String? password;
  String? errorMessage = '';
  Timer? timer;
  bool canShowUploadButton = false;

  @override
  void initState() {
    super.initState();
  }

  late String uploadButtonText;
  File? selectedImage;

  // uploadImage() async {
  //   setState(() {
  //     uploadButtonText = 'Uploading ...';
  //   });
  //
  //   User? loggedInUser = FirebaseAuth.instance.currentUser;
  //   loggedInUser!.updateDisplayName(widget.userName);
  //
  //   if (selectedImage != null) {
  //     final Reference _storageRef = FirebaseStorage.instance.ref().child(
  //         'User files/${loggedInUser.uid}/Profile Picture/${loggedInUser.uid}');
  //     File image = selectedImage!;
  //     await _storageRef.putFile(image).whenComplete(() async {
  //       await _storageRef.getDownloadURL().then((value) {
  //         loggedInUser.updatePhotoURL(value);
  //         FirebaseFirestore.instance
  //             .collection('User')
  //             .doc(loggedInUser.uid)
  //             .set({
  //           'email': widget.email,
  //           'userName': widget.userName,
  //           'uid': loggedInUser.uid,
  //           'photoURL': value,
  //         });
  //       });
  //     });
  //   } else {
  //     await FirebaseFirestore.instance
  //         .collection('User')
  //         .doc(loggedInUser.uid)
  //         .set({
  //       'userName': widget.userName,
  //       'email': widget.email,
  //       'uid': loggedInUser.uid,
  //       'photoURL': null,
  //     });
  //   }
  //   uploadButtonText = 'upload';
  //   canShowUploadButton = false;
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
            GestureDetector(
              onTap: () async {
                XFile? img =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                selectedImage = File(img!.path);

                if (selectedImage != null) {
                  canShowUploadButton = true;
                  uploadButtonText = 'Upload';
                  setState(() {});
                }
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  decoration: BoxDecoration(
                    color: Color(0xff6F35A5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text(
                        'Add Profile Image',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  // onTap: () async {
                  //   await uploadImage();
                  //   User? loggedInUser = FirebaseAuth.instance.currentUser;
                  //   /*LocalUserData.saveLoggedInKey(true);
                  //     LocalUserData.saveUserNameKey(widget.userName);
                  //     LocalUserData.saveUserUidKey(loggedInUser!.uid);*/
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (context) => HomePage()));
                  // },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[900],
                    ),
                    child: Center(
                        child: Text(
                      canShowUploadButton ? uploadButtonText : 'Skip',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
