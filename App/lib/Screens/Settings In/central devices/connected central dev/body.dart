import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:http/http.dart' as http;
import '../../../../background.dart';

//Get All Connected Users

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedIndex = 0;
  Widget page = const CircularProgressIndicator();
  late List data;

  void _onItemTapped(int index) {
    setState(() {
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

  void gelAllUsers() async {
    try {
      print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print("Stored from sharedPreferense");
      print(token);

      final response = await http.get(
        Uri.parse('http://192.168.187.195:5005/api/user/alluser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);
        data = resBody["allUsers"];
        //print("data list");
        print(data[0]["name"]);
        setState(() {
          page = showUsers();
        });
      } else {
        // If the server did not return a 200 CREATED response,
        // then throw an exception.
        print("throw");
        Fluttertoast.showToast(
            msg: "Requested Time Out!\nPlease log in again...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Settings();
            },
          ),
        );
        throw Exception('Failed to get request.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Widget showUsers() {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.06),
          const Text(
            "Connected Users",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      child: ListTile(
                        title: Text(
                          data[index]["name"],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: page,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    gelAllUsers();
  }
}
