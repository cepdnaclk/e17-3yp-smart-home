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
  String? homeid;
  String? userid;
  String? homeName;
  String? senderName;

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
  List notif_List = [
    // {'name': 'Nishanker invited you to join the\nhouse.', 'age': '12'},
    // {'name': 'Arshad request2', 'age': '13'},
    // {'name': 'Arshad request3', 'age': '14'}
  ];

  //get Notification
  getNotification() async {
    print("1");
    try {
      //print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      print(token);
      print(userid);

      final response = await http.post(
        Uri.parse('http://$publicIP:$PORT/api/users/getNotification'), //4n
        //Uri.parse('http://54.172.161.228:$PORT/api/users/getNotification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM1MDAyNTg3LCJleHAiOjE2MzUwMDk3ODd9.DvY7_vs7ZTQdgpxYS58unLUWKzjsHrbgGbivFv8-fc0"
        },
        body: jsonEncode(<String, String>{
          'receiverId': userid.toString(),
        }),
      );

      print(response.statusCode);
      print(response.body);
      // print("inviteUser");

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        homeid = resp["homeid"]["_id"];
        homeName = resp["home"];
        senderName = resp["senderName"];

        notif_List.add("$senderName  invited you to join the\n$homeName .");

        setState(() {
          page = NotificationPage();
        });
      } else {
        throw Exception('Failed to create.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //accept
  accept() async {
    try {
      print("2\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? senderId = prefs.getString('userid');
      print(homeid);
      print(senderId);
      print(token);

      final response = await http.post(
        Uri.parse('http://192.168.187.195:$PORT/api/user/accept'), //4n
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM1MDAyNTg3LCJleHAiOjE2MzUwMDk3ODd9.DvY7_vs7ZTQdgpxYS58unLUWKzjsHrbgGbivFv8-fc0"
        },
        body: jsonEncode(
            <String, String>{'notificationid': '61764573f95b47f7e5f6f577'}),
      );

      print(response.statusCode);
      print(response.body);
      print("accept");

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        setState(() {
          notif_List = [];
          page = NotificationPage();
        });
      } else {
        throw Exception('Failed to create.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //cancel
  cancel() async {
    try {
      print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? senderId = prefs.getString('userid');
      print(senderId);
      print(token);

      final response = await http.post(
        Uri.parse('http://$publicIP:$PORT/api/users/sendNotification'), //4n
        //Uri.parse('http://54.172.161.228:$PORT/api/user/inviteUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM1MDAyNTg3LCJleHAiOjE2MzUwMDk3ODd9.DvY7_vs7ZTQdgpxYS58unLUWKzjsHrbgGbivFv8-fc0"
        },
        body: jsonEncode(<String, String>{
          // 'senderId': senderId.toString(),
          // 'receiverId': recieverId.toString(),
          // 'homeid': homeId,
        }),
      );

      print(response.statusCode);
      print(response.body);
      print("accept");

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        setState(() {
          notif_List = [];
          page = NotificationPage();
        });
      } else {
        throw Exception('Failed to create.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
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
                itemCount: notif_List.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    ListCard(
                      message: notif_List[index],
                    ),
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
                                print("pressed Accept");
                                accept();
                              },
                              child: const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
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
                                print("pressed cancel");
                                cancel();
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
    getNotification();
  }
}
