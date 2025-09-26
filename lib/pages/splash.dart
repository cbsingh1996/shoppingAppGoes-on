// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shopgoes/auth/wapper.dart';
import 'package:shopgoes/context.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  void _goNext() async {
    await Future.delayed(const Duration(seconds: 2));


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WrapperClass()),
      );
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: context.pxHeight(200),
          width: context.px(200),
          decoration: BoxDecoration(
          ),
          child: ClipRRect(
            borderRadius: context.radius(16),
            child: Image.asset('assets/images/coplogo.jpg')),
        ),
      ),
    );
  }
}
