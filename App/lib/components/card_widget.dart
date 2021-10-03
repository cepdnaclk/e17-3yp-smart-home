import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final onTap;
  final child;
  final color;
  final elevation;
  final radius;
  CardWidget({this.onTap, this.child, this.color, this.elevation, this.radius});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Material(
        elevation: elevation ?? 5,
        borderRadius: BorderRadius.circular(radius ?? 15),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.blue[200],
            borderRadius: BorderRadius.circular(radius ?? 15),
          ),
          child: child ?? SizedBox(),
        ),
      ),
    );
  }
}
