import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmartPlug extends StatefulWidget {
  const SmartPlug({Key? key}) : super(key: key);

  @override
  _SmartPlugState createState() => _SmartPlugState();
}

class _SmartPlugState extends State<SmartPlug> {
  String _plugName = 'Plug 1';
  String _roomName = 'Bed Room';
  bool _switchIsIsOn = false;
  bool _scheduleIsOn = false;

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  TimeOfDay _endTime = TimeOfDay(hour: 7, minute: 15);

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '$_roomName',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF6F35A5),
            child: Container(
              padding: EdgeInsets.only(top: 0, left: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Text(
                  '$_plugName',
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
              SizedBox(
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
                              Icons.power_settings_new,
                              color: _switchIsIsOn
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
                                _switchIsIsOn = !_switchIsIsOn;
                              });
                            },
                            child: Container(
                              color: _switchIsIsOn
                                  ? Colors.yellow.shade600
                                  : Colors.black12,
                              padding: const EdgeInsets.all(8),
                              // Change button text when light changes state.
                              child: Text(_switchIsIsOn
                                  ? 'TURN SWITCH OFF'
                                  : 'TURN SWITCH ON'),
                            ),
                          ),

                          Divider(
                            color: Colors.black,
                            height: 25,
                          ),

                          Container(
                            //padding: EdgeInsets.fromLTRB(38, 5, 38, 20),
                            child: Text(
                              'Schedule',
                              style: TextStyle(
                                fontFamily: 'Circular Std',
                                fontSize: 25,
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
                              });
                            },
                            child: Container(
                              color: _scheduleIsOn
                                  ? Colors.green.shade300
                                  : Colors.black12,
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              // Change button text when light changes state.
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(_scheduleIsOn ? 'ON' : 'OFF')),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectTime,
                            child: Text('SELECT START TIME'),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Schedule Starts : ${_time.format(context)}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 18),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF1E6FF), // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: _selectEndTime,
                            child: Text('SELECT END TIME'),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Schedule Ends: ${_endTime.format(context)}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 25,
                          ),
                          Container(
                            //margin: EdgeInsets.only(right: 100),
                            child: Text(
                              'Energy Consuming',
                              style: TextStyle(
                                fontFamily: 'Circular Std',
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                              child: Row(
                            children: [
                              // SocalIcon(
                              //   iconSrc: "assets/icons/google-plus.svg",
                              //   press: () {},
                              // ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width / 3.6,
                                    0,
                                    0,
                                    0),
                                child: SvgPicture.asset(
                                  "assets/icons/Green_Power_Button_clip_art.svg",
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    '70 kJ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Text(
                            'Today',
                          )
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
