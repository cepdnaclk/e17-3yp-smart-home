import 'package:flutter/material.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/Screens/Login/login_screen.dart';
import 'package:untitled/Screens/Notification/notification.dart';
import 'package:untitled/Screens/Settings%20In/central%20devices/central_devices.dart';
import 'package:untitled/Screens/Settings%20In/central%20devices/connected%20central%20dev/connected_cen_devs.dart';
import 'background.dart';

//settings body

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
              SizedBox(height: size.height * 0.01),
              const Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Image(
                height: size.height * 0.25,
                image: const AssetImage(
                  "assets/images/settings.png",
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.person_rounded),
                    title: GestureDetector(
                      onTap: () {
                        print("1");
                      },
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Connected_CentDev();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Connected Users',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CentralDevicePage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Central Devices',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Notifications();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: GestureDetector(
                      onTap: () {
                        print("5");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomesPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'About this App',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Log Out',
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
