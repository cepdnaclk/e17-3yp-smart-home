import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/HomesPage/homes_page.dart';
import 'package:untitled/devices.dart' hide kTextFieldDecoration;
import '../constants.dart';
import 'Settings/settings.dart';
import 'package:http/http.dart' as http;

import 'add_central_device/central_device.dart';
import 'inviteUser/inviteUser.dart';

class HomePage extends StatefulWidget {
  final String homeId;
  const HomePage({Key? key, required this.homeId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(this.homeId);
}

class _HomePageState extends State<HomePage> {
  String homeId;
  _HomePageState(this.homeId);

  TextEditingController roomNameController = TextEditingController();
  bool showPopup = false;
  bool showDelete = false;
  bool delete = false;
  String? tokensend;
  String? userid;
  var selectedInfo;

  @override
  initState() {
    super.initState();
    getData();
    print(showDelete);
  }

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

  //Rooms List
  List data = [];

  //get Data
  void getData() async {
    try {
      print("1\n");
      print(homeId);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      print(token);
      tokensend = token.toString();

      //final queryParameters = {'userid': '$userid'};

      final response = await http.post(
          //Uri.parse('http://54.209.2.221:$PORT/api/home/allrooms'),
          Uri.parse('http://$publicIP:$PORT/api/home/allrooms'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
            // "Authorization":
            //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM0OTE1MzQzLCJleHAiOjE2MzQ5MjI1NDN9.L9XenAuK9qjmsgFWuP-AQzll5EgAaT4YjEAPkYfKbqQ"
          },
          body: jsonEncode(
            <String, String>{
              '_id': homeId,
            },
          ));

      print(response.statusCode);
      print(response.body);
      //print(widget.noOfRooms);

      int NoOfRooms;

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        //print(resp["numberOfhomes"]);
        data = resp["rooms"];
        NoOfRooms = resp["numberOfrooms"];

        print(data);

        //print(NoOfRooms);

        setState(() {
          //print("set");
          //print(NoOfRooms);

          // if (NoOfRooms == 0) {
          //   page = startpage();
          // } else {
          //   page = HomesMainPage(homeList);
          // }
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
      print("exep");
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //Initial cardTile show,
  //& return all other widgets, main data[] all will return
  addTile() {
    List<Widget> widgetList = [];

    widgetList.add(GestureDetector(
      onTap: () async {
        showPopup = true;
        setState(() {});
      },
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.blue[100],
            color: const Color(0xFFF1E6FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: Image.asset(
            'assets/images/addroom.png',
            height: 100,
          )),
        ),
      ),
    ));

    for (var info in data) {
      widgetList.add(GestureDetector(
        onTap: () {},
        onLongPress: () {
          showDelete = true;
          print(showDelete);
          setState(() {});
        },
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            GestureDetector(
              onTap: () {
                //print(info['roomId']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Sample(
                        homeId: info['homeid'],
                        roomId: info['_id'],
                      );
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: 150,
                        child: Image.asset(
                          info['roomType'] == null
                              ? 'assets/images/pin.png'
                              : 'assets/${info['roomType']}',
                        ), //icon
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(info['roomname']), //icon
                    ),
                  ],
                )),
              ),
            ),
            Visibility(
              visible: showDelete,
              child: Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    delete = true;
                    selectedInfo = info;
                    setState(() {});
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ));
    }
    return widgetList;
  }

  saveRoom() async {
    // data.add(({
    //   'roomName': roomNameController.text.trim(),
    //   'icon': selectedIcon,
    // }));

    try {
      //print("1\n");

      String roomName = roomNameController.text.trim().toString();
      String roomType = selectedIcon.toString();

      // print(roomNameController.text.trim().toString());
      // print(selectedIcon.toString());
      print(roomName);
      print(roomType);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      prefs.setString('token', token.toString());
      //print(token);

      final response = await http.post(
          Uri.parse('http://$publicIP:$PORT/api/home/rooms/addroom'),
          //Uri.parse('http://54.209.2.221:$PORT/api/home/rooms/addroom'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
            // "Authorization":
            //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM0OTExMTM0LCJleHAiOjE2MzQ5MTgzMzR9.t-uS6-wPu5xeXtU_vbiNc4XPp1gD-HcA9FdLtwYmV2g"
          },
          body: jsonEncode(
            <String, String>{
              'roomname': roomName,
              'roomType': roomType,
              'homeid': homeId, //print(widget.noOfRooms)
              // 'homeid': '617253c61ff94c782ab8d274'
            },
          ));
      //
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Your Room Successfully added to your home.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);

        getData();
        setState(() {
          // if (NoOfRooms == 0) {
          //   page = startpage();
          // } else {
          //   page = HomesMainPage(homeList);
          // }
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

  List iconList = [
    'images/kitchen.png',
    'images/livingroom.png',
    'images/bathroom.png',
    'images/outdoor.png',
    'images/bedroom.png'
  ];

  String? selectedIcon; //nullable

  DropdownButton dropDown(List dropList, String type) {
    List<DropdownMenuItem> dropdownList = [];

    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Column(children: [
          Container(
            height: 32,
            width: 50,
            child: Image.asset(
              'assets/$listItem',
              width: 50,
              scale: 0.5,
              height: 50,
            ),
          ),
          const Divider(
            thickness: 1,
          )
        ]),
        value: listItem,
      );
      dropdownList.add(newItem);
    }
    return DropdownButton(
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.grey,
      value: selectedIcon,
      items: dropdownList,
      onChanged: (value) {
        selectedIcon = value;
        print(selectedIcon);
        setState(() {});
      },
    );
  }

  //navigation bar select
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Settings();
            },
          ),
        );
      } else if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomesPage();
            },
          ),
        );
      }
    });
  }

//widget overide
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (showPopup == true) {
          showPopup = false;
          selectedIcon = null;
          //selectedIcon = '';
          roomNameController.clear();
          setState(() {});
        } else {
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
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
        body: Stack(
          children: [
            //welcom to your Home
            Container(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'My Home',
                        style: TextStyle(
                          fontFamily: 'Circular Std',
                          fontSize: 38,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 90,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              color: Colors.amber,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CentralDevice(
                                          homeId, tokensend.toString());
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Add C Dev",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              color: Colors.amber,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return InviteUser(homeId);
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Invite User",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              color: const Color(0xFF6F35A5),
              //color: Colors.indigo
            ),

            Column(children: [
              const SizedBox(
                height: 160,
              ),
              Expanded(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(children: [
                        //Rooms
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 30,
                                top: 20,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Rooms',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[800]),
                              ),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: showDelete,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showDelete = false;
                                    setState(() {});
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: roomNameController.text
                                                  .trim()
                                                  .isEmpty
                                              ? Colors.blueGrey
                                              : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Add Tile
                        Flexible(
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            crossAxisCount: 2,
                            children: addTile(),
                          ),
                        ),
                      ])),
                ),
              ),
            ]),
            //show pop up and save the room or cancel
            Visibility(
              visible: showPopup,
              child: GestureDetector(
                onTap: () {
                  showPopup = false;
                  selectedIcon = null;
                  //selectedIcon = '';
                  roomNameController.clear();
                  setState(() {});
                },
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Material(
                      elevation: 15,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: const Text(
                                  'Add Room',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text('Enter your room Name :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 300,
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() {});
                                },
                                controller: roomNameController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black),
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter Your Room Name',
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50),
                                    child: const Text('select Icon : ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black))),
                                dropDown(iconList, 'icon'),
                              ],
                            ),
                            Container(
                              child: Center(
                                  child: GestureDetector(
                                onTap: () {
                                  if (roomNameController.text
                                      .trim()
                                      .isNotEmpty) {
                                    saveRoom(); //save the room in the main list
                                    showPopup = false;
                                    selectedIcon = null;
                                    //selectedIcon = '';
                                    roomNameController.clear();
                                    setState(() {});
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: roomNameController.text
                                                .trim()
                                                .isEmpty
                                            ? Colors.blueGrey
                                            : Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 17),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //show popup and delete the room or cancel
            Visibility(
              visible: delete,
              child: deleteAlert(selectedInfo),
            )
          ],
        ),
      ),
    );
  }

  deleteAlert(info) {
    return GestureDetector(
      onTap: () {
        delete = false;
        setState(() {});
      },
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Material(
            elevation: 15,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text('Do You Want delete this room entry?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          data.remove(info);
                          delete = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: const Text(
                            'Ok',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          delete = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
