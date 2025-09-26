import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/coupon_model.dart';
import 'package:shopgoes/style.dart';

class CouponDetailPage extends StatelessWidget {
  final Coupon coupon;
  const CouponDetailPage({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final bool isExpired = !coupon.isActive || coupon.expiryDate.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title:  Text('Details',style: heading(context),
        ),
        backgroundColor:bgcolor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
height: context.pxHeight(600),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: context.radius(16)
              ),
              child:RotatedBox(
                quarterTurns: 1,
                child: couponCardWidget(context: context,isexpire:isExpired, code: coupon.code, discount: "${coupon.discount}", expiry:  coupon.expiryDate.toLocal().toString().split(
                          ' ',
                        )[0], colors:[Colors.amberAccent, Colors.blue],detail: "It's a special welcome bonus for you! Redeem this bonus to enjoy instant discounts on your favorite products. Save more while shopping and unlock exclusive offers."),
              )
            ),
           
            const SizedBox(height: 20),
            if (!isExpired)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, coupon); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Apply Coupon",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


Widget couponCardWidget({
  required bool isexpire,
  required BuildContext context,
  required String code,
  required String discount,
  required String expiry,
  required List<Color> colors,
  required String detail,
  double height = 150,
}) {
  return CustomPaint(
    painter: TicketPainter(colors: colors),
    child: Container(
      height: height,
      width: double.infinity,
      padding:  EdgeInsets.all(context.px(12)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Discount
            RotatedBox(
              quarterTurns: -1,
              child: Container(
              height: context.pxHeight(145),
              
                  padding:  EdgeInsets.all(context.px(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(code,style: TextStyle(
                        fontSize: context.sp(24),fontWeight: FontWeight.bold,color: txtColor
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Status: ',style: style145(context,color:Colors.white).copyWith(fontWeight: FontWeight.bold),),
                    Text(
                      isexpire ? "Expired" : "Active",
                      style:style145(context,
                          color: isexpire? Colors.red : Colors.green,
                      ))
                  ],
                              ),
                    ],
                  ),
                ),
              
            ),
            context.sbWidth(50),
            Expanded(
              child: RotatedBox(
                quarterTurns: -1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      code,
                      style:  TextStyle(
                          fontSize:context.sp(24) , fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text("Expire: $expiry", style: TextStyle(color: Colors.white70,fontSize: context.sp(14),fontWeight: FontWeight.bold)),
                    Text(detail,  style: TextStyle(color: Colors.white,fontSize: context.sp(14),fontWeight: FontWeight.w500),maxLines: 10,),
                
                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class TicketPainter extends CustomPainter {
  final List<Color> colors;
  TicketPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double cutRadius = 15;

    final path = Path();
    path.moveTo(16, 0);
    path.lineTo(size.width * 3 / 10 - cutRadius, 0);
    path.arcToPoint(Offset(size.width * 3 / 10 + cutRadius, 0),
        radius: Radius.circular(cutRadius), clockwise: false);
    path.lineTo(size.width - 16, 0);
    path.arcToPoint(Offset(size.width, 16), radius: Radius.circular(cutRadius));
    path.lineTo(size.width, size.height - 16);
    path.arcToPoint(Offset(size.width - 16, size.height), radius: Radius.circular(cutRadius));
    path.lineTo(size.width * 3 / 10 + cutRadius, size.height);
    path.arcToPoint(Offset(size.width * 3 / 10 - cutRadius, size.height),
        radius: Radius.circular(cutRadius), clockwise: false);
    path.lineTo(16, size.height);
    path.arcToPoint(Offset(0, size.height - 16), radius: Radius.circular(cutRadius));
    path.lineTo(0, 16);
    path.arcToPoint(Offset(16, 0), radius: Radius.circular(cutRadius));
    path.close();

    // Shadow / Elevation
    canvas.drawShadow(path, Colors.black.withAlpha(160), 8, true);

    // Gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, fillPaint);

    // Dotted line
    final dashPaint = Paint()..color = Colors.white..strokeWidth = 2;
    double dashHeight = 6, dashSpace = 4, startY = cutRadius;
    double centerX = size.width * 0.3;
    while (startY < size.height - cutRadius-4) {
      canvas.drawLine(Offset(centerX, startY), Offset(centerX, startY + dashHeight), dashPaint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}