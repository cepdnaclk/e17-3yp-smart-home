import 'package:flutter/material.dart';

class WhiteLight extends StatefulWidget {
  const WhiteLight({Key? key}) : super(key: key);

  @override
  _WhiteLightState createState() => _WhiteLightState();
}

class _WhiteLightState extends State<WhiteLight> {
  String _lightName = 'Bed Room';
  String _roomName = 'Bed Room';
  bool _lightIsOn = false;
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

  RangeValues _currentRangeValues = const RangeValues(40, 80);
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
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
            color: Color(0xFF6F35A5),
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Text(
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            margin: EdgeInsets.fromLTRB(0, 0, 190, 0),
                            child: Text(
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
                              //divisions: 10,
                              min: 0,
                              max: 100,
                            ),
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
                          SizedBox(height: 8),
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
                            style: TextStyle(
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
