import 'package:flutter/material.dart';
import 'body.dart';

class InviteUser extends StatelessWidget {
  String homeId;
  InviteUser(this.homeId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        homeId: homeId,
      ),
    );
  }
}
