import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, route)
        print(message);
      },
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Image(
                image: AssetImage('assets/images/user.png'),
              ),
              // child: SvgPicture.asset(
              //   "assets/icons/chat.svg",
              //   //color: Colors.white,
              //   // height: 37,
              //   // width: 37,
              // ),
            ),
            title: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
