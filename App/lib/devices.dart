import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/TypeOfDevices/rgb_light.dart';
import 'Screens/TypeOfDevices/smart_plug.dart';
import 'Screens/TypeOfDevices/white_light.dart';

//Add device
class Sample extends StatefulWidget {
  final String homeId;
  final String roomId;
  const Sample({Key? key, required this.homeId, required this.roomId})
      : super(key: key);

  @override
  _SampleState createState() => _SampleState(this.homeId, this.roomId);
}

class _SampleState extends State<Sample> {
  String homeId;
  String roomId;
  _SampleState(this.homeId, this.roomId);
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
    getData();
    print(showDelete);
  }

  List data = [];

  void getData() async {
    try {
      //print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);
      //tokensend = token.toString();

      //final queryParameters = {'userid': '$userid'};

      final response = await http.post(
          Uri.parse('http://192.168.187.195:5001/api/devices/getallDevices'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
            // "Authorization":
            //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM0OTc2MDA4LCJleHAiOjE2MzQ5ODMyMDh9.ZhtMPZfQi9zRZx5GZ46HMNo8tGUqY_eBue4hs9JnLy8"
          },
          body: jsonEncode(
            <String, String>{
              //roomId
              'roomid': roomId,
              //'roomid': ''
            },
          ));

      print(response.statusCode);
      print(response.body);
      //print(widget.noOfRooms);

      int NoOfRooms;

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        //print(resp["numberOfhomes"]);
        data = resp["devices"];

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
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

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
        onTap: () {
          if (info['deviceType'] == "images/smartbulb.png") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RGB_light();
                },
              ),
            );
          } else if (info['deviceType'] == "images/bulb.png") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WhiteLight();
                },
              ),
            );
          } else if (info['deviceType'] == "images/plug.png") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SmartPlug();
                },
              ),
            );
          }
        },
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
                color: Colors.white10,
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
                        info['deviceType'] == null
                            ? 'assets/images/pin.png'
                            : 'assets/${info['deviceType']}',
                        width: 100,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      info['devicename'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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

  saveDevice() async {
    // data.add(({
    //   'roomName': roomNameController.text.trim(),
    //   'icon': selectedIcon,
    // }));

    try {
      //print("1\n");

      String deviceName = roomNameController.text.trim().toString();
      String deviceType = selectedIcon.toString();
      String port = selectedPort.toString();

      print(deviceName);
      print(deviceType);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      prefs.setString('token', token.toString());
      //print(token);

      final response = await http.post(
          Uri.parse('http://192.168.187.195:5001/api/devices/adddevice'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
            // "Authorization":
            //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM0OTc2MDA4LCJleHAiOjE2MzQ5ODMyMDh9.ZhtMPZfQi9zRZx5GZ46HMNo8tGUqY_eBue4hs9JnLy8"
          },
          body: jsonEncode(
            <String, String>{
              'homeid': homeId,
              'roomid': roomId,
              'deviceType': deviceType,
              'devicename': deviceName,
              'cdeviceid': 'A12345',
              'port': port,
              //print(widget.noOfRooms)
            },
          ));
      //
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Your Device Successfully added.",
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
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  List iconList = [
    'images/smartbulb.png',
    'images/plug.png',
    'images/bulb.png',
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

  DropdownButton dropDownDevice(List dropList, String type) {
    List<DropdownMenuItem> dropdownList = [];
    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 30,
            width: 115,
            child: Center(child: Text('$listItem')),
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
        appBar: AppBar(
          title: Text(
            '                My Villa',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.purple,
        ),
        body: Stack(
          children: [
            //welcome
            Container(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(top: 15, left: 20),
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
                height: 100,
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
                          height: 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 30, top: 20),
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
                                    const EdgeInsets.fromLTRB(0, 25, 0, 10),
                                child: const Text(
                                  'Add Device',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text('Enter your Device Name :',
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
                                  hintText: 'Enter Your Device Name',
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    child: const Text('select Device Type:',
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: const Text('Port No:    ',
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
                                  if (roomNameController.text
                                      .trim()
                                      .isNotEmpty) {
                                    saveDevice();
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
                    child: const Text('Do You Want delete this Device entry?',
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
