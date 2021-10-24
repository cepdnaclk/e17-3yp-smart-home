import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Add_a_home/addHome.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/components/listcard.dart';
import '../../../constants.dart';
import '../../home_page.dart';
import '../homes_page.dart';
import 'background.dart';

//Homes Main Page
class Body extends StatefulWidget {
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
              return HomesPage();
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
  late List homeList;

  //get home
  void getHome() async {
    try {
      //print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userid = prefs.getString('userid');
      print(token);
      print(userid);

      //final queryParameters = {'userid': '$userid'};

      final response = await http.post(
          Uri.parse('http://192.168.8.100:5001/api/home/allhomes/byuserId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
            // "Authorization":
            //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiXSwiX192IjowfSwiaWF0IjoxNjM0ODg4MDU1LCJleHAiOjE2MzQ4OTUyNTV9.n_K5Lak9tU2xc7IRKr6XdclItslruQGHt561v-c9ZrU"
          },
          body: jsonEncode(
            <String, String>{
              'userid': '$userid'
              //'userid': '617244d0b8c067469d455abe'
            },
          ));

      print(response.statusCode);
      print(response.body);
      //print(widget.noOfRooms);

      int NoOfHomes;

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        //print(resp["numberOfhomes"]);
        homeList = resp["homes"];
        NoOfHomes = resp["numberOfhomes"];

        //print(NoOfHomes);

        setState(() {
          //print("set");
          //print(_NoOfHomes);

          if (NoOfHomes == 0) {
            page = startpage();
          } else {
            page = HomesMainPage(homeList);
          }
        });
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
            msg: "Requested time out. Please log in again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Requested time out. Please log in again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddHome();
                          },
                        ),
                      );
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddHome();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Get started",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.blueAccent,
                      ),
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
  Widget HomesMainPage(homeList) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddHome();
                      },
                    ),
                  );
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
            height: size.height * 0.20,
            image: const AssetImage(
              "assets/images/house.jpg",
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          const Divider(
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: homeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListCard(
                    homeName: homeList[index]['homename'],
                    homeId: homeList[index]['_id'],
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
