import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/components/listcard.dart';
import '../../../constants.dart';
import '../../home_page.dart';
import 'background.dart';

//Homes Main Page
class Body extends StatefulWidget {
  Body({required this.noOfRooms});
  final noOfRooms;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //initial page
  Widget page = Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
        ],
      ));

  //variable
  int _selectedIndex = 0;

  //nav bar
  void _onItemTapped(int index) {
    setState(() async {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
          (route) => false,
        );
      } else if (_selectedIndex == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Settings();
            },
          ),
          (route) => false,
        );
      }
    });
  }

  //home list
  List homeList = [
    {'name': 'Arshad home1', 'age': '12'},
    {'name': 'Arshad home2', 'age': '13'},
    {'name': 'Arshad home3', 'age': '14'},
    {'name': 'Arshad home4', 'age': '15'},
    {'name': 'Arshad home5', 'age': '16'},
  ];

  //get home
  void getHome() async {
    //print("1\n");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userid = prefs.getString('userid');
    print(token);
    print(userid);

    final queryParameters = {
  'userid': '$userid'
};

    final response = await http.get(
      Uri.parse('http://192.168.187.195:5001/api/user/alluser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(<String, String>{
          'userid': '$userid'
          //'userid': '616dae8edad0e97516bf053c'
        }
      
    );
    print(response.statusCode);
    print(widget.noOfRooms);

    int nOhm = 1;

    if (response.statusCode == 403) {
      setState(() {
        //print("set");
        //print(NoOfRooms);

        if (nOhm == 0) {
          page = startpage();
        } else {
          page = HomesMainPage();
        }
      });
    }
  }

  // start page
  Widget startpage() {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("1");
                    },
                    child: const CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("2");
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      child: Text('A'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              const Text(
                "Create a home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Image(
                height: size.height * 0.33,
                image: const AssetImage(
                  "assets/images/home.jpg",
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Column(
                children: <Widget>[
                  const Text(
                    "You don't have any homes yet. Create your home\n              to control everything in one place.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  const Text(
                    "Get started",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: size.height * 0.17),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Homes main page
  Widget HomesMainPage() {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  print("1");
                },
                child: const CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.add),
                  radius: 25,
                ),
              ),
              SizedBox(
                width: size.width * 0.66,
              ),
              GestureDetector(
                onTap: () {
                  print("2");
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  child: Text('A'),
                  radius: 25,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          const Text(
            "Welcome To Your homes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Image(
            height: size.height * 0.33,
            image: const AssetImage(
              "assets/images/home.jpg",
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: homeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListCard(
                    homeName: homeList[index]['name'],
                  );
                }),
          ),
        ],
      ),
    ));
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
        body: page);
  }

  @override
  void initState() {
    super.initState();
    getHome();
  }
}
