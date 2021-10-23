import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:http/http.dart' as http;
import '../../../background.dart';
import '../../../constants.dart';
import 'listcard.dart';

//Homes Main Page
class Body extends StatefulWidget {
  // Body({required this.noOfRooms});
  // final noOfRooms;

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

  //Notification list
  List homeList = [
    {'name': 'Nishanker invited you to join the\nhouse.', 'age': '12'},
    {'name': 'Arshad request2', 'age': '13'},
    {'name': 'Arshad request3', 'age': '14'}
  ];

  //get Notification
  void getHome() async {
    //print("1\n");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userid = prefs.getString('userid');
    print(token);
    print(userid);

    final queryParameters = {'userid': '$userid'};

    final response = await http.get(
      Uri.parse('http://192.168.187.195:5001/api/user/alluser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token"
      },
      //   body: jsonEncode(<String, String>{
      //       'userid': '$userid'
      //       //'userid': '616dae8edad0e97516bf053c'
      //     }
    );

    print(response.statusCode);
    //print(widget.noOfRooms);

    // int nOhm = 1;

    if (response.statusCode == 403) {
      setState(() {
        //print("set");

        // if (nOhm == 0) {
        //   page = startpage();
        // } else {
        //   page = HomesMainPage();
        // }
      });
    }
  }

  //NotificationPage
  Widget NotificationPage() {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.02),
          SizedBox(height: size.height * 0.02),
          const Text(
            "Notifications",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          const Divider(
            thickness: 1,
          ),
          //SizedBox(height: size.height * 0.01),
          Expanded(
            child: ListView.builder(
                itemCount: homeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    ListCard(
                      message: homeList[index]['name'],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("aa"),
                    //     SizedBox(
                    //       width: 30,
                    //     ),
                    //     Text("bb"),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: size.width * 0.30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              color: kPrimaryColor,
                              onPressed: () {
                                print("pressed $index");
                              },
                              child: const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: size.width * 0.30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              color: Colors.amber,
                              onPressed: () {
                                print("pressed $index");
                              },
                              child: const Text(
                                "Cancel",
                                //style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(
                      thickness: 1,
                    ),
                  ]);
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
        //body: page);
        body: NotificationPage());
  }

  @override
  void initState() {
    super.initState();
    getHome();
  }
}
