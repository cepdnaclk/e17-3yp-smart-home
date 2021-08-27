import 'package:flutter/material.dart';
import 'package:sample/Screens/verification/components/body.dart';

class VerificationScreen extends StatelessWidget {
  final email;
  final userName;
  VerificationScreen({required this.email, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, userName: userName,),
    );
  }
}
