//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/Screens/Welcome/welcome_screen.dart';

import 'package:untitled/Screens/home_page.dart';
import 'package:untitled/Screens/Signup/signup_screen.dart';
import 'package:untitled/Screens/Login/login_screen.dart';

import 'package:untitled/Screens/profile_adding/ProfileAdding.dart';
import 'package:untitled/Screens/verification/verification_screen.dart';
import 'package:untitled/devices.dart';
import 'package:untitled/Screens/TypeOfDevices/white_light.dart';
import 'package:untitled/Screens/TypeOfDevices/rgb_light.dart';
import 'package:untitled/Screens/TypeOfDevices/smart_plug.dart';

import 'package:untitled/Screens/device_check.dart';
import 'Screens/Add_a_home/addHome.dart';
import 'Screens/HomesPage/homes_page.dart';
import 'Screens/Notification/notification.dart';
import 'Screens/Settings In/central devices/central_devices.dart';
import 'Screens/Settings In/central devices/connected central dev/connected_cen_devs.dart';
import 'Screens/Settings/settings.dart';
import 'Screens/add_central_device/central_device.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Hut',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
      //home: SignUpScreen(),
      //home: LoginScreen(),

      //home: HomesPage(),
      //home: AddHome(),

      //home: HomePage(),

      //home: Sample(), //add device , room
      //home: WhiteLight(),
      //home: RGB_light(),
      //home: SmartPlug(),
      //home: ProfileAddingScreen(email: 'abcdefg@gmail.com', userName: 'arshad'),
      //home: VerificationScreen(),

      //home: DeviceCheck(),

      //home: Settings(),
      //home: CentralDevicePage(),  //settings->CentralDevices
      //home: CentralDevice(),      //settings->CentralDevices->Add Central Device
      //home: Connected_CentDev(),

      //home: Notifications(),
    );
  }
}
