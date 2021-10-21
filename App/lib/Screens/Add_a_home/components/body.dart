import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:untitled/components/rounded_button.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/constants.dart';
import '../../../background.dart';
import '../../home_page.dart';
import 'package:http/http.dart' as http;

//Add a Home body
class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? homeNickname;
  String? address;

  int _selectedIndex = 0;

  //Bottam nav bar
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

  //Add a new Home request
  addHome(String homeNickname, String address) async {
    try {
      //print("1\n");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userid = prefs.getString('userid');
      print(token);
      print(userid);
//616dae8edad0e97516bf053c
      final response = await http.post(
        Uri.parse('http://192.168.187.195:5001/api/home/addhome'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNmRhZThlZGFkMGU5NzUxNmJmMDUzYyIsIm5hbWUiOiJuaXNoYW4iLCJtYWlsIjoibmlzaGFubmlzaGFua2FyQGdtYWlsLmNvbSIsInBhc3N3b3JkIjoiJDJiJDEwJGZNVFhlYVFwbDRtc3YvVExOLjVVMk9NVzUweVNIV0VYcnliMjJCT3ZMbDF0YXVrN2JVWkN5IiwiaG9tZXMiOltdLCJfX3YiOjB9LCJpYXQiOjE2MzQ3MzEzNzIsImV4cCI6MTYzNDczODU3Mn0.nRJjZwwR7Ig4wUyI3-iWN7Y119PGN9DCApt9UEvTawY"
        },
        body: jsonEncode(<String, String>{
          'homename': homeNickname,
          'address': address,
          'userid': '$userid',
          //'userid': '616dae8edad0e97516bf053c'
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Auterization Failed. Please log in again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

      if (response.statusCode == 200) {
        print("sussessful");
        // Navigator.push(
        //   context,
        // MaterialPageRoute(
        //   builder: (context) {
        //     return ();
        //   },
        // ),
        // );
        //return Album.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        print("throw");
        Fluttertoast.showToast(
            msg: "Requested Failed. Please try Again!",
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
              SizedBox(height: size.height * 0.08),
              const Text(
                "Name your home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Choose a nickname for this home to help identify it later",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 19.5,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              RoundedInputField(
                hintText: "Home nickname",
                onChanged: (value) {
                  homeNickname = value;
                  setState(() {});
                },
                icon: Icons.add_business_rounded,
              ),
              RoundedInputField(
                hintText: "Home address",
                onChanged: (value) {
                  address = value;
                  setState(() {});
                },
                icon: Icons.add_location,
              ),
              RoundedButton(
                color: homeNickname != null ? kPrimaryColor : Colors.grey,
                text: "SAVE",
                press: () {
                  if (homeNickname == null) {
                    Fluttertoast.showToast(
                        msg: "Enter the home name",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  }
                  if (homeNickname != null) {
                    addHome(homeNickname!, address!);
                  }
                },
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
