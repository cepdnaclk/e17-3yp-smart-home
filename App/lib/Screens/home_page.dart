//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:untitled/devices.dart';
import 'Settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController roomNameController = TextEditingController();
  bool showPopup = false;
  bool showDelete = false;
  bool delete = false;
  var selectedInfo;
  int roomId = 1;

  @override
  initState() {
    super.initState();
    //getData();
    print(showDelete);
  }

  //User? loggedInUser = FirebaseAuth.instance.currentUser;

  List data = [];

  // getData() async {
  //   await FirebaseFirestore.instance
  //       .collection("Devices")
  //       .doc(loggedInUser == null ? "abc" : loggedInUser!.uid)
  //       .get()
  //       .then((value) {
  //     data = value['devices'];
  //   }).catchError((e) {});
  //   setState(() {});
  // }

  //Initial cardTile show,
  //& return all other widgets, main data[i] all will return
  addTile() {
    List<Widget> widgetList = [];

    widgetList.add(GestureDetector(
      onTap: () {
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
                print(info['roomId']);
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
                        child: Image.asset(info['icon'] == null
                            ? 'assets/images/pin.png'
                            : 'assets/${info['icon']}'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(info['roomName']),
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
    data.add(({
      'roomName': roomNameController.text.trim(),
      'icon': selectedIcon,
      'roomId': roomId,
    }));
    print(roomId);
    roomId++;
    // await FirebaseFirestore.instance
    //     .collection("Devices")
    //     .doc(loggedInUser == null ? "abc" : loggedInUser!.uid)
    //     .set({'devices': data});
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (showPopup == true) {
          showPopup = false;
          selectedIcon = null;
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
                  padding: const EdgeInsets.only(top: 28.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Text(
                    'Welcome To\nYour Home',
                    style: TextStyle(
                      fontFamily: 'Circular Std',
                      fontSize: 30,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              color: const Color(0xFF6F35A5),
            ),

            Column(children: [
              const SizedBox(
                height: 130,
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
                        const SizedBox(
                          height: 20,
                        ),
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
                                                      .trim().isEmpty
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
                                padding: const EdgeInsets.symmetric(vertical: 30),
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
                                  hintStyle: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 50),
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
                                  if (roomNameController.text.trim().isNotEmpty) {
                                    saveRoom(); //save the room in the main list
                                    showPopup = false;
                                    selectedIcon = null;
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
                                                    .trim().isEmpty
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
