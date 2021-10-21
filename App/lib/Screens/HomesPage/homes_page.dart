import 'package:flutter/material.dart';
import 'components/body.dart';

class HomesPage extends StatelessWidget {
  final int noOfRooms;
  HomesPage({required this.noOfRooms});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(noOfRooms: noOfRooms),
    );
  }
}










// class Body extends StatefulWidget {
//   const Body({Key? key}) : super(key: key);

//   @override
//   _BodyState createState() => _BodyState();
// }

// class _BodyState extends State<Body> {

  

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       width: double.infinity,
//       height: size.height,
//       child: Stack(children: <Widget>[
//         Positioned(
//           top: 0,
//           left: 0,
//           child: Image.asset(
//             "assets/images/main_top.png",
//             width: size.width * 0.35,
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: Image.asset(
//             "assets/images/login_bottom.png",
//             width: size.width * 0.4,
//           ),
//         ),
//         Scaffold(
//           bottomNavigationBar: BottomNavigationBar(
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings),
//                 label: 'Settings',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             unselectedItemColor: Colors.purple,
//             selectedItemColor: Colors.purple,
//             onTap: _onItemTapped,
//           ),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               child: Stack(children: [
//                 Column(
//                   children: <Widget>[
//                     SizedBox(height: size.height * 0.02),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: size.width * 0.05,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             print("1");
//                           },
//                           child: const CircleAvatar(
//                             backgroundColor: kPrimaryColor,
//                             child: Icon(Icons.add),
//                           ),
//                         ),
//                         SizedBox(
//                           width: size.width * 0.7,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             print("2");
//                           },
//                           child: const CircleAvatar(
//                             backgroundColor: Colors.amberAccent,
//                             child: Text('A'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: size.height * 0.02),
//                     const Text(
//                       "Welcome To Your homes",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 28.0,
//                       ),
//                     ),
//                     SizedBox(height: size.height * 0.01),
//                     Image(
//                       height: size.height * 0.33,
//                       image: const AssetImage(
//                         "assets/images/home.jpg",
//                       ),
//                     ),
//                     Column(children: <Widget>[
//                       ListTile(
//                         leading: const Icon(Icons.person_rounded),
//                         title: GestureDetector(
//                           onTap: () {
//                             print("1");
//                           },
//                           child: const Text(
//                             'Update Profile',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.person_rounded),
//                         title: GestureDetector(
//                           onTap: () {
//                             print("1");
//                           },
//                           child: const Text(
//                             'Update Profile',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         subtitle: const Text(
//                           'arshad',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ]),
//                     //SizedBox(height: size.height * 0.25),
//                   ],
//                 ),
//               ]),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

  
// }
