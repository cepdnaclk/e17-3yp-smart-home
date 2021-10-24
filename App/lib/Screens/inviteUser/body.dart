import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/rounded_input_field.dart';
import 'package:untitled/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'background.dart';

class Body extends StatefulWidget {
  final String homeId;
  const Body({Key? key, required this.homeId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(this.homeId);
}

//Invite Body

class _BodyState extends State<Body> {
  String homeId;
  _BodyState(this.homeId);
  String? recieverId;
  String? userName;
  Widget page = const SizedBox(
    height: 10,
  );
  final storage = const FlutterSecureStorage();

  postUser(String userName) async {
    try {
      print("1\n");
      print(userName);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);
      final response = await http.post(
        Uri.parse('http://192.168.187.195:5001/api/user/inviteUser'), //4n
        //Uri.parse('http://54.172.161.228:5001/api/user/inviteUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM1MDAyNTg3LCJleHAiOjE2MzUwMDk3ODd9.DvY7_vs7ZTQdgpxYS58unLUWKzjsHrbgGbivFv8-fc0"
        },
        body: jsonEncode(<String, String>{'username': userName}),
      );

      print(response.statusCode);
      print(response.body);
      print("inviteUser");

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        String user = resp["username"];
        recieverId = resp["userid"];

        setState(() {
          page = Container(
              child: Material(
            child: Column(
              children: [
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    user,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    print("pe");
                    sendReq();
                  },
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          ));
        });
      } else if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "User not found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        page = const SizedBox(
          height: 10,
        );
      } else {
        throw Exception('Failed to create.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //send Notification
  sendReq() async {
    try {
      print("1\n");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? senderId = prefs.getString('userid');
      print(senderId);
      print(token);
      print("---------");
      print(senderId.toString());
      print(recieverId.toString());
      print(homeId);
      print("---------");
      final response = await http.post(
        Uri.parse(
            'http://192.168.187.195:5001/api/users/sendNotification'), //4n
        //Uri.parse('http://54.172.161.228:5001/api/user/inviteUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
          // "Authorization":
          //     "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYxNzI0NGQwYjhjMDY3NDY5ZDQ1NWFiZSIsIm5hbWUiOiJhcnNoYWQxMjMiLCJtYWlsIjoibW9tYXJkOThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMTAkTVdiMGpzSGhRLzFVL001WjBjN2xqLjAxN3RKZTgxZTIySDJsNjlBMTVjZU9hRkhqMTFFSm0iLCJob21lcyI6WyI2MTcyNTNjNjFmZjk0Yzc4MmFiOGQyNzQiLCI2MTcyNmM2MDEzZDBkZTFjNDUyNTE1NzUiLCI2MTcyNzI4ZjEzZDBkZTFjNDUyNTE1ODgiXSwiX192IjowfSwiaWF0IjoxNjM1MDAyNTg3LCJleHAiOjE2MzUwMDk3ODd9.DvY7_vs7ZTQdgpxYS58unLUWKzjsHrbgGbivFv8-fc0"
        },
        body: jsonEncode(<String, String>{
          'senderId': senderId.toString(),
          'receiverId': recieverId.toString(),
          'homeid': homeId,
        }),
      );

      print(response.statusCode);
      print(response.body);
      print("inviteUser");

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);

        setState(() {
          page = const SizedBox(
            height: 10,
          );
        });
      } else {
        throw Exception('Failed to create.');
      }
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Invite User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  hintText: "Enter the username",
                  onChanged: (value) {
                    userName = value;
                    setState(() {});
                  },
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FlatButton(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    color: kPrimaryColor,
                    onPressed: () {
                      print("pressed ");
                      postUser(userName.toString());
                    },
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                page,
                const SizedBox(
                  height: 550,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
