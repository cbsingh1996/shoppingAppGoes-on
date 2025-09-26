import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';

class Kidproduct extends StatelessWidget {
  const Kidproduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kid's Product", style: heading(context)),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Product>(
                  ProductService.productBoxName,
                ).listenable(),
                builder: (context, _, __) {
                  // sirf code == 2 wale products
                  final products = ProductService.getProducts()
                      .where((element) => element.code == 2)
                      .toList();

                  if (products.isEmpty) {
                    return const Center(child: Text("No Products"));
                  }

                  return MasonryGridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    crossAxisSpacing: context.px(12),
                    mainAxisSpacing: context.pxHeight(12),
                    crossAxisCount: 2,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () => openProductDetail(context, product),
                        child: Stack(
                          children: [
                            CustomProduct(product: product),
                            if (product.quantity == 0)
                              Positioned.fill(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: context.radius(12),
                                    gradient: const LinearGradient(
                                      colors: [Colors.white70, Colors.white54],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(context.px(8)),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: context.radius(12),
                                    ),
                                    child: Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                        color: btcolor,
                                        fontSize: context.sp(16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openProductDetail(BuildContext context, Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );

    if (result == true) {
      // koi setState ki zarurat nahi, ValueListenableBuilder handle karega
    }
  }
}
