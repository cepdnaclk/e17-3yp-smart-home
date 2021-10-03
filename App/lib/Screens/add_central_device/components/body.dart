import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/components/rounded_password_field.dart';
import 'package:untitled/constants.dart';
import '../../home_page.dart';
import 'background.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? deviceId;
  String? password;

  int _selectedIndex = 0;

  get storage => null;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ),
          (route) => false,
        );
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Settings();
            },
          ),
        );
      }
    });
  }

  //add & save Central device request
  addDevice(String deviceId, String password) async {
    try {
      //print("1\n");

      FlutterSecureStorage storage = const FlutterSecureStorage();
      print("token from stored");
      String? token = await storage.read(key: "token");
      print(token);


      final response = await http.post(
        Uri.parse('http://192.168.187.195:5005/api/user/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'deviceId': deviceId,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Entered email or password Incorrect!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Settings();
            },
          ),
          (route) => false,
        );
        //return Album.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        print("throw");
        Fluttertoast.showToast(
            msg: "Entered email or password Incorrect!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        throw Exception('Failed to create album.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.purple,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Add Centerlised Device",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Image(
                height: size.height * 0.35,
                image: const AssetImage(
                  "assets/images/centelised.jpg",
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Central Device Id",
                onChanged: (value) {
                  deviceId = value;
                  setState(() {});
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  password = value;
                  setState(() {});
                },
                hintText: 'Password',
              ),
              RoundedButton(
                color: deviceId != null && password != null
                    ? kPrimaryColor
                    : Colors.grey,
                text: "ADD DEVICE",
                press: () {
                  if (deviceId == null || password == null) {
                    Fluttertoast.showToast(
                        msg: "Enter all fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  }
                  if (deviceId != null && password != null) {
                    addDevice(deviceId!, password!);
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
