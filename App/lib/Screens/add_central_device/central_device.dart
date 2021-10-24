import 'package:flutter/material.dart';
import 'package:untitled/Screens/add_central_device/components/body.dart';

//settings->CentralDevices->Add Central Device
class CentralDevice extends StatelessWidget {
  String homeId;
  String token;
  CentralDevice(this.homeId, this.token);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        homeId: this.homeId,
        token: this.token,
      ),
    );
  }
}
