import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/coupon_model.dart';
import 'package:shopgoes/pages/coupondetail.dart';
import 'package:shopgoes/services/coupon_service.dart';
import 'package:shopgoes/style.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  List<Coupon> coupons = [];

  @override
  void initState() {
    super.initState();
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    await CouponService.seedCoupons();
    setState(() {
      coupons = CouponService.getCoupons();
    });
  }

  final gradients = [
    [Colors.redAccent,Colors.blue],
    [Colors.amberAccent,Colors.blue],
    [Colors.pinkAccent,Colors.blue],
    [Colors.greenAccent,Colors.blue],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text("Coupons", style: heading(context)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: coupons.isEmpty
          ? const Center(
              child: Text(
                "No coupons available",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];

                return Column(
                  children: [
                    context.sbHeight(20),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CouponDetailPage(coupon: coupon),
                          ),
                        );
                      },

                      child: CouponCard(
                        discount: "${coupon.discount}",
                        code: coupon.code,
                        expiry: coupon.expiryDate.toLocal().toString().split(
                          ' ',
                        )[0],
                        colors: gradients[index % gradients.length],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
class CouponCard extends StatelessWidget {
  final String code;
  final String discount;
  final String expiry;
  final List<Color> colors;
  final String detail;
  final double height;

  const CouponCard({
    super.key,
    required this.code,
    required this.discount,
    required this.expiry,
    required this.colors,
    this.detail='',
    this.height=150
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketPainter(colors: colors),
      child: Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Discount", style: style145(context, color: Colors.white)),
                    Text(discount, style: style145(context, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(code,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text("Expire: $expiry", style: const TextStyle(color: Colors.white70)),
                    if(detail.isNotEmpty)...[
                       Text("Details: ",style: style145(context,color: txtColor) ,),
                Container(
                  padding: EdgeInsets.all(8),
                  width: height,
                  child: Text(" Don’t miss out on these exciting rewards—use your bonus today and experience a smarter, more rewarding way to shop and save!",
                      style: const TextStyle(fontSize: 16),
                      maxLines: 10,),
                ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

    // Draw shadow
    canvas.drawShadow(path, Colors.black.withAlpha(100), 6, true);

    // Fill gradient
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
    while (startY < size.height - cutRadius) {
      canvas.drawLine(Offset(centerX, startY), Offset(centerX, startY + dashHeight), dashPaint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
