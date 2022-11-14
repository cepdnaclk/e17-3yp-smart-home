import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/Screens/Welcome/welcome_screen.dart';

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

      // home: Sample(
      //   homeId: '617253c61ff94c782ab8d274',
      //   roomId: '6172791713d0de1c452515a1',
      // ), //add device , room
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
      //home: InviteUser('617253c61ff94c782ab8d274'),   //617253c61ff94c782ab8d274
    );
  }
}
