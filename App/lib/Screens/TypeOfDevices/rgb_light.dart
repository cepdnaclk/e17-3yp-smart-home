import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:intl/intl.dart';

class RGB_light extends StatefulWidget {
  final String homeId;
  final String roomId;
  final String deviceid;
  final String port;
  const RGB_light({
    Key? key,
    required this.homeId,
    required this.roomId,
    required this.deviceid,
    required this.port,
  }) : super(key: key);

  @override
  _RGB_lightState createState() =>
      _RGB_lightState(homeId, roomId, deviceid, port);
}

class _RGB_lightState extends State<RGB_light> {
  String homeId;
  String roomId;
  String deviceid;
  String port;
  _RGB_lightState(this.homeId, this.roomId, this.deviceid, this.port);

  String _lightName = 'RGB Light';
  String _roomName = 'Bed Room  ';
  bool _lightIsOn = false;
  bool _scheduleIsOn = false;
  String? userid;
  String? tokensend;
  int r = 0;
  int g = 0;
  int b = 0;

  TimeOfDay _time = TimeOfDay(hour: 13, minute: 00);
  TimeOfDay _endTime = TimeOfDay(hour: 13, minute: 15);
  //TimeOfDay _startTime = TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));

  double _rating = 100;

  @override
  initState() {
    print("port");
    print(port);
    super.initState();
    getData();
    print("deviceid");
    print(deviceid);
  }

  List data = [];

  void getData() async {
    try {
      print("1\n");
      print(homeId);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      tokensend = token.toString();

      final response = await http.post(
          Uri.parse('http://$publicIP:$PORT/api/devices/status'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
            {
              'deviceid': deviceid,
            },
          ));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        print(resp["device"]);
        print(resp["device"]["status"]);

        r = resp["device"]['r'];
        g = resp["device"]['g'];
        b = resp["device"]['b'];
        _rating = resp["device"]["brightness"].toDouble();
        //_lightIsOn = resp["device"]["status"] == 0 ? false : true;
        _lightIsOn = resp["device"]["status"];
        print(r);
        print(g);

        setState(() {});
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

  void sendData() async {
    try {
      print("1\n");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      tokensend = token.toString();

      final response =
          await http.post(Uri.parse('http://$publicIP:$PORT/api/devices/rgb'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                "Authorization": "Bearer $token"
              },
              body: jsonEncode(
                {
                  'state': _lightIsOn.toString(),
                  'deviceType': 'rgb',
                  'port': port,
                  //color
                  'r': r,
                  'g': g,
                  'b': b,
                  'brightness': _rating.toInt(),
                  'deviceid': deviceid,
                },
              ));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        setState(() {});
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

  //schedule
  void sheduleData() async {
    try {
      print("shedule\n");
      print(_time.format(context));

      DateTime startTime = DateFormat.jm().parse(_time.format(context));
      DateTime endTime = DateFormat.jm().parse(_endTime.format(context));
      print(startTime);
      print(endTime);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      //print(token);
      tokensend = token.toString();

      final response = await http.post(
          Uri.parse('http://$publicIP:$PORT/api/devices/schedule'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
            {
              'port': port,
              'deviceid': deviceid,
              'StartTime': startTime.toString(),
              'EndTime': endTime.toString(),
              'schedulestate': _scheduleIsOn.toString(),
              'd_t': 1,
            },
          ));

      print(deviceid);
      print(_time);
      print(_scheduleIsOn.toString());
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        setState(() {});
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

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        print(_time);
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
      });
    }
  }

  String _selectedColor = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          '$_roomName',
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF6F35A5),
            child: Container(
              padding: EdgeInsets.only(top: 0, left: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Text(
                  _lightName,
                  style: const TextStyle(
                    fontFamily: 'Circular Std',
                    fontSize: 30,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Expanded(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          //icon
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: _lightIsOn
                                  ? Colors.yellow.shade600
                                  : Colors.black,
                              size: 60,
                            ),
                          ),
                          //turn light on
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                _lightIsOn = !_lightIsOn;
                                r = 255;
                                g = 255;
                                b = 255;
                                sendData();
                              });
                            },
                            child: Container(
                              color: _lightIsOn
                                  ? Colors.yellow.shade600
                                  : Colors.black12,
                              padding: const EdgeInsets.all(8),
                              // Change button text when light changes state.
                              child: Text(_lightIsOn
                                  ? 'TURN LIGHT OFF'
                                  : 'TURN LIGHT ON'),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 25,
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.fromLTRB(0, 0, 190, 0),
                            child: const Text(
                              'Brightness',
                              style: TextStyle(
                                fontFamily: 'Circular Std',
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            child: Slider(
                              value: _rating,
                              onChanged: (newRating) {
                                setState(
                                  () {
                                    _rating = newRating;
                                    print(_rating);
                                    sendData();
                                  },
                                );
                              },
                              label: _rating.round().toString(),
                              divisions: 5,
                              min: 0,
                              max: 100,
                            ),
                          ),

                          const Divider(
                            color: Colors.black,
                            height: 25,
                          ),

                          //select color
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            //margin: EdgeInsets.fromLTRB(0, 0, 190, 0),
                            child: const Text(
                              'Select Colour',
                              style: TextStyle(
                                fontFamily: 'Circular Std',
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          //color select
                          Row(
                            children: [
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'white';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 255;
                                    b = 255;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'blue';
                                    print('$_selectedColor');
                                    r = 0;
                                    g = 0;
                                    b = 255;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'lightGreen';
                                    print('$_selectedColor');
                                    r = 0;
                                    g = 255;
                                    b = 0;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.lightGreen,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'yellow';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 255;
                                    b = 0;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.yellow,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'orange';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 165;
                                    b = 0;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'purpleAccent';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 0;
                                    b = 255;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.purpleAccent,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'red';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 0;
                                    b = 0;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'pinkAccent';
                                    print('$_selectedColor');
                                    r = 255;
                                    g = 105;
                                    b = 180;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.pinkAccent,
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'blue[900]';
                                    print('$_selectedColor');
                                    r = 0;
                                    g = 0;
                                    b = 128;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue[900],
                                ),
                              ),
                              SizedBox(width: (size.width - 250) / 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = 'cyanAccent';
                                    print('$_selectedColor');
                                    r = 0;
                                    g = 128;
                                    b = 128;
                                    print(r);
                                    sendData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.cyanAccent,
                                ),
                              ),
                            ],
                          ),

                          Divider(
                            color: Colors.black,
                            height: 25,
                          ),

                          Container(
                            //padding: EdgeInsets.fromLTRB(38, 5, 38, 20),
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              'Schedule',
                              style: TextStyle(
                                fontFamily: 'Circular Std',
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                _scheduleIsOn = !_scheduleIsOn;
                                sheduleData();
                              });
                            },
                            child: Container(
                              color: _scheduleIsOn
                                  ? Colors.green.shade300
                                  : Colors.black12,
                              padding: const EdgeInsets.all(8),
                              // Change button text when light changes state.
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(_scheduleIsOn ? 'ON' : 'OFF')),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectTime,
                            child: Text('SELECT START TIME'),
                          ),
                          Text(
                            'Schedule Starts : ${_time.format(context)}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectEndTime,
                            child: Text('SELECT END TIME'),
                          ),
                          Text(
                            'Schedule Ends: ${_endTime.format(context)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
