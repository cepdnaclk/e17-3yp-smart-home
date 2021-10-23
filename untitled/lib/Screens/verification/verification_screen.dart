import 'package:flutter/material.dart';
import 'package:untitled/Screens/verification/components/body.dart';

class VerificationScreen extends StatelessWidget {
  final email = 'ard@gmail.com';
  final userName = 'ard';
  //VerificationScreen({required this.email, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        email: email,
        userName: userName,
      ),
    );
  }
}
