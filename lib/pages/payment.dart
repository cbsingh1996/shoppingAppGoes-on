import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/style.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedIndex = -1;
  List items = ['Credit/Debit Card', 'Net Banking', 'Cash on Delivery'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: bgcolor,
        
        title: Text("Payment Page", style: heading(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.sbHeight(20),
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            context.sbHeight(8),

            // UPI method-----------------------------------------------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UPI', style: subheading(context)),
                context.sbHeight(8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.px(16)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: context.radius(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: context.px(20),
                              height: context.pxHeight(20),
                              decoration: selectedIndex == 0
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: btcolor,
                                    )
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 1.5,
                                      ),
                                    ),
                            ),
                            context.sbWidth(12),
                            Text('Add UPI ID', style: style145(context)),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: context.px(16),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),

                context.sbHeight(16),
                Text('More way to pay', style: subheading(context)),
                context.sbHeight(8),

                Container(
                  padding: EdgeInsets.all(context.px(16)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.radius(12),
                  ),
                  child: Column(
                    children: List.generate(items.length, (index) {
                      int itemIndex = index + 1;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = itemIndex;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: context.px(20),
                                      height: context.pxHeight(20),
                                      decoration: selectedIndex == itemIndex
                                          ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: btcolor,
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.orange,
                                                width: 1.5,
                                              ),
                                            ),
                                    ),
                                    context.sbWidth(12),
                                    Text(
                                      items[index],
                                      style: style145(context),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: context.px(16),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                          context.sbHeight(12),
                          if (index != items.length - 1) Divider(),
                          if (index != items.length - 1) context.sbHeight(12),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
