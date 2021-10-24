import 'package:flutter/material.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/Screens/Settings/settings.dart';
import 'package:untitled/Screens/add_central_device/central_device.dart';
import 'background.dart';

//Central devices page

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedIndex = 0;

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
                "Central Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
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
              Column(
                children: <Widget>[
                  // ListTile(
                  //   leading: const Icon(Icons.device_hub),
                  //   title: GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return CentralDevice();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //     child: const Text(
                  //       'Add Device',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    leading: const Icon(Icons.connected_tv),
                    title: GestureDetector(
                      onTap: () {
                        print("2");
                      },
                      child: const Text(
                        'Connected devices',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wb_iridescent),
                    title: GestureDetector(
                      onTap: () {
                        print("3");
                      },
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
