import 'package:flutter/material.dart';

class RGB_light extends StatefulWidget {
  const RGB_light({Key? key}) : super(key: key);

  @override
  _RGB_lightState createState() => _RGB_lightState();
}

class _RGB_lightState extends State<RGB_light> {
  @override
  String _lightName = 'RGB Light';
  String _roomName = 'Bed Room  ';
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
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
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
