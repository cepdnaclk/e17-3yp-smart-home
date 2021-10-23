import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

//Add device

class Sample extends StatefulWidget {
  const Sample({Key? key}) : super(key: key);

  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  TextEditingController roomNameController = TextEditingController();
  bool showPopup = false;
  bool showDelete = false;
  bool delete = false;

  String? selectedIcon;
  String? selectedDevice;
  String? selectedPort;

  var selectedInfo;
  //var dataNo;

  @override
  initState() {
    super.initState();
    //getData();
    print(showDelete);
  }

  //User? loggedInUser = FirebaseAuth.instance.currentUser;

  List data = [];

  List allData = [];

  retunAlist(int n) {
    List newList = [];
    allData.add(newList);
    return allData;
  }

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

  //Initial cardTile add,
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
            color: Color(0xFFF1E6FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: Image.asset(
            'assets/images/adddevice.png',
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
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Column(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 150,
                      child: Image.asset(info['icon'] == null
                          ? 'assets/images/pin.png'
                          : 'assets/${info['icon']}'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(info['deviceName']),
                  )
                ],
              )),
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
                  child: CircleAvatar(
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
    data.add({
      'deviceName': roomNameController.text.trim(),
      'icon': selectedIcon,
      'type': selectedDevice,
      'port': selectedPort
    });
    // await FirebaseFirestore.instance
    //     .collection("Devices")
    //     .doc(loggedInUser == null ? "abc" : loggedInUser!.uid)
    //     .set({'devices': data});
  }

  List iconList = [
    'images/fan.png',
    'images/bulb.png',
    'images/curtain.png',
    'images/plug.png',
    'images/smartbulb.png'
  ];

  List deviceType = [
    'Smart Plug',
    'White Light',
    'RGB Light',
  ];

  List portNo = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15'
  ];

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
          Divider(
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

  DropdownButton dropDownDevice(List dropList, String type) {
    List<DropdownMenuItem> dropdownList = [];
    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 30,
            width: 115,
            child: Center(child: Text('$listItem')),
          ),
          Divider(
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
      value: selectedDevice,
      items: dropdownList,
      onChanged: (value) {
        selectedDevice = value;
        print(selectedDevice);
        setState(() {});
      },
    );
  }

  DropdownButton dropDownPort(List dropList, String type) {
    List<DropdownMenuItem> dropdownList = [];
    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 30,
            width: 115,
            child: Center(child: Text('$listItem')),
            // child: Image.asset(
            //   'assets/$listItem',
            //   width: 50,
            //   scale: 0.5,
            //   height: 50,
            // ),
          ),
          Divider(
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
      value: selectedPort,
      items: dropdownList,
      onChanged: (value) {
        selectedPort = value;
        print(selectedPort);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (showPopup == true) {
          showPopup = false;
          selectedIcon = null;
          selectedDevice = null;
          selectedPort = null;
          roomNameController.clear();
          setState(() {});
        } else {
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            //welcome
            Container(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(top: 30, left: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Text(
                    'Welcome To\nYour Room',
                    style: TextStyle(
                      fontFamily: 'Circular Std',
                      fontSize: 30,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              color: Color(0xFF6F35A5),
            ),
            //devices
            Column(children: [
              SizedBox(
                height: 150,
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 30, top: 20, bottom: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Devices',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[800]),
                              ),
                            ),
                            Spacer(),
                            Visibility(
                              visible: showDelete,
                              child: Container(
                                padding: EdgeInsets.only(
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
                                                      .length ==
                                                  0
                                              ? Colors.blueGrey
                                              : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
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
                        Flexible(
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(20),
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
            Visibility(
              visible: showPopup,
              child: GestureDetector(
                onTap: () {
                  showPopup = false;
                  selectedIcon = null;
                  roomNameController.clear();
                  selectedDevice = null;
                  selectedPort = null;
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
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 25, 0, 10),
                                child: Text(
                                  'Add Device',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Enter your Device Name :',
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
                                style: TextStyle(color: Colors.black),
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter Your Device Name',
                                  hintStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    child: Text('select Icon : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black))),
                                dropDown(iconList, 'icon'),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Device Type: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black))),

                                dropDownDevice(deviceType, 'device')
                                //dropDown(deviceType, 'icon'),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Port No: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black))),

                                dropDownPort(portNo, 'selectedPort')
                                //dropDown(deviceType, 'icon'),
                              ],
                            ),
                            Container(
                              child: Center(
                                  child: GestureDetector(
                                onTap: () {
                                  if (roomNameController.text.trim().length !=
                                      0) {
                                    saveRoom();
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
                                                    .trim()
                                                    .length ==
                                                0
                                            ? Colors.blueGrey
                                            : Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 17),
                                    child: Text(
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
            Visibility(
              visible: delete,
              child: deleteAlert(selectedInfo, data),
            )
          ],
        ),
      ),
    );
  }

  deleteAlert(info, List n) {
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
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Do You Want delete this Device entry?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          data.remove(info);
                          delete = false;
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: Text(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: Text(
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

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your password',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
