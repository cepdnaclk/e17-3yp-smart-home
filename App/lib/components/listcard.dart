import 'package:flutter/material.dart';
import 'package:untitled/Screens/home_page.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key, required this.homeName, required this.homeId})
      : super(key: key);
  final String homeName;
  final String homeId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(homeName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(
                homeId: homeId,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey[400],
              radius: 30,
              child: const Image(
                image: AssetImage('assets/images/home.jpg'),
              ),
              //  SvgPicture.asset(
              //   "assets/chat.svg",
              //   color: Colors.white,
              //   height: 37,
              //   width: 37,
              // ),
            ),
            title: Text(
              homeName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Text(
              "Act",
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
