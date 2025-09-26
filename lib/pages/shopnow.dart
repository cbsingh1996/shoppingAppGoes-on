// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/address_model.dart';
import 'package:shopgoes/model/coupon_model.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/address.dart';
import 'package:shopgoes/pages/congrats.dart';
import 'package:shopgoes/pages/coupondetail.dart';
import 'package:shopgoes/services/address_service.dart';
import 'package:shopgoes/services/history_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/services/sharedservice.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custombt.dart';
import 'package:hive/hive.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ShopNowPage extends StatefulWidget {
  final double price;
  final List<Product> list;
  const ShopNowPage({super.key, required this.price, required this.list});

  @override
  State<ShopNowPage> createState() => _ShopNowPageState();
}

class _ShopNowPageState extends State<ShopNowPage> {
  Coupon? coup;

  int selectedIndex = -1;
  final TextEditingController _couponController = TextEditingController();
  List items = ['Credit/Debit Card', 'Net Banking', 'Cash on Delivery'];
  bool isoffer = false;
  Address? selectedAddress;
  // ignore: non_constant_identifier_names
  late Box<Coupon> CouponList;

  @override
  void initState() {
    super.initState();
    _checkdefault();
    CouponList = Hive.box<Coupon>('Coupons');
  }



  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _checkdefault() async {
    final prefs = await SharedPreferences.getInstance();
    final addressId = prefs.getInt("default_address");

    if (addressId == null || addressId == 0) {
      final address = null;
      setState(() {
        selectedAddress = address;
      });
    } else {
      final address = AddressService.getAddressById(addressId);
      setState(() {
        selectedAddress = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.px(16)),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL', style: style145(context)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Items : ${widget.list.length}", style: subheading(context)),
            Text(
              "Total pay without coupon :- ${widget.price}",
              style: subheading(context),
            ),
            Material(
              elevation: 0,
              borderRadius: context.radius(12),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(context.px(16)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedAddress != null
                          ? 'Delivering to ${selectedAddress!.fullName}'
                          : 'Delivering to -',
                      style: subheading(context),
                    ),

                    SizedBox(height: context.px(6)),
                    if (selectedAddress == null) ...{
                      Text(
                        "No default address found",
                        style: planetxt(context),
                      ),
                    } else ...{
                      Text(
                        "${selectedAddress!.fullName}, "
                        "${selectedAddress!.houseNumber}, ${selectedAddress!.landmark}, "
                        "${selectedAddress!.town}, ${selectedAddress!.city}, "
                        "${selectedAddress!.state} - ${selectedAddress!.pincode}, "
                        "Mobile: ${selectedAddress!.mobileNumber}",
                        style: planetxt(context),
                        maxLines: 3,
                      ),
                    },

                    context.sbHeight(16),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressPage(),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {});
                            _checkdefault();
                          }
                        });
                      },
                      child: Text(
                        'Change delivery address',
                        style: planetxt(context, color: Colors.blue),
                      ),
                    ),
                    context.sbHeight(4),
                  ],
                ),
              ),
            ),
            context.sbHeight(12),
            // --------------------------------------------------------Continue button--------------------------------------------------------------
            Custombt(text: 'Continue', ontap: _handleContinue),

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

            context.sbHeight(24),
            // Coupon code-----------------------------------------------------------------
            GestureDetector(
              onTap: _showCouponBottomSheet,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.px(12),
                  vertical: context.px(14),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _couponController.text.isNotEmpty
                            ? _couponController.text
                            : "Select coupon",
                        style: TextStyle(
                          fontSize: context.sp(14),
                          color: _couponController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.black54,
                      size: context.px(32),
                    ),
                  ],
                ),
              ),
            ),

            context.sbHeight(24),

            // --------------------------------------------------------Continue button--------------------------------------------------------------
            Custombt(text: 'Continue', ontap: _handleContinue),

            context.sbHeight(40),
          ],
        ),
      ),
    );
  }

  int calculatePoints(double amount) {
    if (amount <= 500) {
      return (amount * 0.02).round();
    } else {
      return (amount * 0.03).round(); 
    }
  }

  String getPaymentMethod(int index) {
    List<String> paymentMethods = [
      'upi',
      'Credit/Debit Card',
      'Net Banking',
      'Cash on Delivery',
    ];

    if (index >= 0 && index < paymentMethods.length) {
      return paymentMethods[index];
    } else {
      return "No payment detail";
    }
  }
  // ------------------------------------------------------------------------------------------------------------------------------
void _handleContinue() async {
  if (selectedIndex >= 0 && selectedAddress != null) {
    // 🔹 Loader dialog show karo
    showDialog(
      context: context,
      barrierDismissible: false, // user back press se close na kar sake
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // 🔹 2 second delay
    await Future.delayed(const Duration(seconds: 2));

    // 🔹 Order place karna
    await OrderService.addOrder(
      products: widget.list,
      totalAmount: widget.price - (coup?.discount ?? 0),
      paymentMode: getPaymentMethod(selectedIndex),
      orderDate: DateTime.now(),
      deliveryAddress: selectedAddress!,
    );
final pt=calculatePoints(widget.price - (coup?.discount ?? 0));
    // 🔹 Points add karo
    await SharedService.setInt(
      'points',
      SharedService.getInt('points') +pt
          ,
    );

    // 🔹 Bag se products remove karo (ProductService + MybagService)
    await ProductService.clearBoughtProducts(widget.list);

    // 🔹 Loader band karo
    if (mounted) Navigator.pop(context);

    // 🔹 Congrats page pr le jao
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratsPage(points:pt)),
      );
    }
  } else if (selectedAddress == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a delivery address')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Select payment mode')),
    );
  }
}


// await ProductService.clearBoughtProducts(widget.list);
  void _showCouponBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final now = DateTime.now();
        final validCoupons = CouponList.values
            .where((coupon) => coupon.expiryDate.isAfter(now))
            .toList();

        return Container(
          height: context.pxHeight(300),
          width: double.infinity,
          padding: EdgeInsets.all(context.px(20)),
          child: validCoupons.isEmpty
              ? Center(
                  child: Text(
                    "No valid coupons available",
                    style: planetxt(context, color: Colors.red),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(validCoupons.length, (index) {
                    Coupon coupon = validCoupons[index];

                    return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          setState(() {
                            _couponController.text = coupon.code;
                            coup = coupon;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          coupon.code,
                          style: planetxt(context, color: Colors.black),
                        ),
                      ),
                      subtitle: GestureDetector(
                        onTap: () {
                          setState(() {
                            _couponController.text = coupon.code;
                            coup = coupon;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Expires on: ${coupon.expiryDate.toString().substring(0, 10)}",
                          style: planetxt(context, color: Colors.grey),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          final appliedCoupon = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CouponDetailPage(coupon: coupon),
                            ),
                          );

                          if (appliedCoupon != null &&
                              appliedCoupon is Coupon) {
                            setState(() {
                              _couponController.text = appliedCoupon.code;
                              coup = appliedCoupon;
                            });
                          }

                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: context.px(26),
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
        );
      },
    );
  }
}
