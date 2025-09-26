import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/style.dart';


typedef CallbackAction = void Function();

class Custombt extends StatefulWidget {
  final String text;
  final CallbackAction ontap;

  const Custombt({super.key, required this.text, required this.ontap,});

  @override
  State<Custombt> createState() => _CustombtState();
}

class _CustombtState extends State<Custombt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap, 
      child: Container(
        width: double.infinity,
        height: context.pxHeight(50),
        decoration: BoxDecoration(
          borderRadius: context.radius(12),
          color: btcolor,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: style145(context),
          ),
        ),
      ),
    );
  }
}
