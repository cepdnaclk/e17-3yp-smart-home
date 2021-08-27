import 'package:flutter/material.dart';
import 'package:sample/Screens/profile_adding/components/body.dart';

class ProfileAddingScreen extends StatelessWidget {
  final email;
  final userName;
  ProfileAddingScreen({required this.email, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email, userName: userName ),
    );
  }
}
