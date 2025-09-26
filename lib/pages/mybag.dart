// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/pages/shopnow.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';
import 'package:shopgoes/widgets/custombt.dart';

class MybagPage extends StatefulWidget {
  const MybagPage({super.key});

  @override
  State<MybagPage> createState() => _MybagPageState();
}

class _MybagPageState extends State<MybagPage> {
  List<Product> products = [];
  List<Product> bagProducts = [];
  late List<int> quantities;

  Future<void> loadBag() async {
    final ids = await MybagService.getAllProductIds();
    products = ProductService.getProducts();
    setState(() {
      bagProducts = ids.reversed
          .map((id) => products.firstWhere((p) => p.id == id))
          .toList();
    });
    quantities = List.filled(bagProducts.length, 1);
  }

  @override
  void initState() {
    super.initState();
    loadBag();
  }

  final searchController = TextEditingController();
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
           appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Bag', style: heading(context)),

            // 🛍 Agar list empty hai
            if (bagProducts.isEmpty) ...[
              SizedBox(
                width: double.infinity,
                height: context.pxHeight(500),
                child: Center(
                  child: Text(
                    "No items in the bag",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ] else ...[
              // ✅ Items list
              ...List.generate(bagProducts.length, (index) {
                final product = bagProducts[index];

                return Column(
                  children: [
                    context.sbHeight(15),
                    SizedBox(
                      width: double.infinity,
                      child: Slidable(
                        key: ValueKey(product.key),

                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.35,
                          children: [
                            SlidableAction(
                              spacing: context.px(6),
                              onPressed: (_) async {
                                product.inBag = false;
                                await product.save();

                                setState(() {
                                  bagProducts.removeAt(index);
                                });

                                await MybagService.removeFromBag(product.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${product.name} removed from bag",
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,

                              label: 'Delete',
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPage(product: product),
                                  ),
                                );
                              },
                              // Image------------------------------------------------------------------------------------
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: context.radius(16),
                                    child: CustomImageWidget(
                                      image: product.images[0],
                                    ),
                                  ),
                                  if (product.offer > 0)
                                    Positioned(
                                      right: 0,
                                      top: -3,
                                      child: Container(
                                        padding: EdgeInsets.all(context.px(6)),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${product.offer}%\nOFF',
                                            style: style1(
                                              context,
                                              color: Colors.white,
                                            ).copyWith(fontSize: context.sp(6)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (product.quantity == 0)
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: -3,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: context.radius(10),
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            context.sbWidth(15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              DetailPage(product: product),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      product.name,
                                      style: subheading(context),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              DetailPage(product: product),
                                        ),
                                      );
                                    },
                                    child: product.quantity != 0
                                        ? product.offer == 0
                                              ? Text(
                                                  '₹ ${product.price.toStringAsFixed(2)}',
                                                  style: subheading(context)
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      '₹ ${product.price.toStringAsFixed(2)}',
                                                      style:
                                                          subheading(
                                                            context,
                                                            color:
                                                                Colors.black54,
                                                          ).copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                    ),
                                                    context.sbWidth(4),
                                                    Text(
                                                      // ignore: unnecessary_string_interpolations
                                                      '${(product.price - (product.price * product.offer / 100)).toStringAsFixed(2)}',
                                                      style: subheading(context)
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                        : Text(
                                            '₹ ${product.price.toStringAsFixed(2)}',
                                            style: subheading(context).copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                  ),
                                  context.sbHeight(10),

                                  // ➕➖ Buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (product.quantity != 0)
                                        Text(
                                          "Qty:${quantities[index]}",
                                          style: style1(context),
                                        )
                                      else
                                        Text(
                                          "Out of stock",
                                          style:
                                              style1(
                                                context,
                                                color: Colors.red,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      if (product.quantity != 0)
                                        Row(
                                          children: [
                                            // remove
                                            GestureDetector(
                                              onTap: product.quantity == 0
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (quantities[index] >
                                                            0) {
                                                          quantities[index]=quantities[index]-1;
                                                        }
                                                      });
                                                    },
                                              child: quantities[index] > 0
                                                  ? CircleAvatar(
                                                      radius: 18,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 28,
                                                        color: Colors.black38,
                                                      ),
                                                    )
                                                  : Container(),
                                            ),
                                            context.sbWidth(15),

                                            if (product.quantity != 0)
                                              Text(
                                                "${quantities[index]}",
                                                style: subheading(context),
                                              ),
                                            context.sbWidth(15),

                                            // add
                                            GestureDetector(
                                              onTap: product.quantity == 0
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (quantities[index] <
                                                            product.quantity) {
                                                          quantities[index]++;
                                                        }
                                                      });
                                                    },
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 28,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    context.sbHeight(15),
                    Divider(thickness: 1, color: Colors.black26),
                  ],
                );
              }),

              // ✅ Total amount dynamically calculate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: style1(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_calculateTotal(bagProducts).toStringAsFixed(2)}',
                    style: subheading(context),
                  ),
                ],
              ),

              context.sbHeight(50),

              Custombt(
                text: 'Check out',
                ontap: () {
                    List<Product> fornextpage = [];
                
                  for (int i = 0; i < bagProducts.length; i++) {
                    // print(object)
                    if (quantities[i] > 0 && bagProducts[i].quantity>0) {
                      fornextpage.add(bagProducts[i]);
                    }
                  }

               if(_calculateTotal(bagProducts)>0){  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopNowPage(
                        price: _calculateTotal(bagProducts),
                        list: fornextpage, 
                      ),
                    ),
                  );}
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select Product')));
                  }
                },
              ),

              context.sbHeight(60),
            ],
          ],
        ),
      ),
    );
  }

  double _calculateTotal(List<Product> items) {
    double total = 0.0;

    for (int i = 0; i < items.length && i < quantities.length; i++) {
      final product = items[i];

      if (product.quantity > 0) {
        double effectivePrice = product.offer > 0
            ? product.price - (product.price * product.offer / 100)
            : product.price;

        total += effectivePrice * quantities[i];
      }
    }

    return total;
  }
}
