import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../../constants.dart';

class WhiteLight extends StatefulWidget {
  final String homeId;
  final String roomId;
  final String deviceid;
  final String port;
  const WhiteLight({
    Key? key,
    required this.homeId,
    required this.roomId,
    required this.deviceid,
    required this.port,
  }) : super(key: key);

  @override
  _WhiteLightState createState() =>
      _WhiteLightState(homeId, roomId, deviceid, port);
}

class _WhiteLightState extends State<WhiteLight> {
  String homeId;
  String roomId;
  String deviceid;
  String port;
  _WhiteLightState(this.homeId, this.roomId, this.deviceid, this.port);

  String _lightName = 'Bed Room';
  String _roomName = 'Bed Room';
  bool _lightIsOn = false;
  bool _scheduleIsOn = false;
  String? userid;
  String? tokensend;

  TimeOfDay _time = TimeOfDay(hour: 13, minute: 00);
  TimeOfDay _endTime = TimeOfDay(hour: 13, minute: 15);

  @override
  initState() {
    super.initState();
    getData();
  }

  //send Data
  void sendData() async {
    try {
      print(deviceid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      //print(token);
      tokensend = token.toString();

      //print
      print(_lightIsOn);
      print(port);

      final response = await http.post(
          Uri.parse('http://$publicIP:$PORT/api/devices/turnOn'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
            {
              'state': _lightIsOn.toString(),
              'port': port,
              'deviceid': deviceid
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

//get data
  void getData() async {
    try {
      print("1\n");
      print(deviceid);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      userid = prefs.getString('userid');
      print(token);
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

        //_lightIsOn = resp["device"]["status"] == 0 ? false : true;
        _lightIsOn = resp["device"]["status"];

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
              'd_t': 2,
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

  double _rating = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          _roomName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF6F35A5),
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Text(
                  'Front Light',
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Toggle light when tapped.
                                _lightIsOn = !_lightIsOn;
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
                          Container(
                            //padding: EdgeInsets.fromLTRB(38, 5, 38, 20),
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: const Text(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(_scheduleIsOn ? 'ON' : 'OFF')),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectTime,
                            child: const Text('SELECT START TIME'),
                          ),
                          Text(
                            'Schedule Starts : ${_time.format(context)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectEndTime,
                            child: const Text('SELECT END TIME'),
                          ),
                          Text(
                            'Schedule Ends: ${_endTime.format(context)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
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
