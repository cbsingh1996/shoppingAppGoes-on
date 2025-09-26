import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/bottomnav.dart';
import 'package:shopgoes/widgets/custombt.dart';

class CongratsPage extends StatefulWidget {
  final int points;
  const CongratsPage({super.key, required this.points});

  @override
  State<CongratsPage> createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,

      body: Padding(
        padding: EdgeInsets.all(context.px(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/coplogo.jpg',
              height: context.pxHeight(90),
              width: context.px(90),
              fit: BoxFit.contain,
            ),
            Text('Congrats!', style: subheading(context)),
            Text(
              'thanku for your purchesing. Your order',
              style: style1(context),
              maxLines: 2,
            ),
            Text(
              'will be shipped in 2-4 working days',
              style: style1(context),
              maxLines: 2,
            ),
            Text("Earn Points", style: heading(context)),
            Container(
              padding: EdgeInsets.all(context.px(20)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: txtColor,
              ),
              child: Text(
                "${widget.points}",
                style: subheading(context, color: btcolor),
              ),
            ),
            context.sbHeight(190),
            GestureDetector(
              child: Custombt(
                text: 'Start shopping',
                ontap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Bottomnav()),
                    (route) => false,
                  );
                },
              ),
            ),
            context.sbHeight(100),
          ],
        ),
      ),
    );
  }
}
