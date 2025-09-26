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

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  void openProductDetail(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: const CustomAppBar(),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<Product>(ProductService.productBoxName).listenable(),
        builder: (context, value, child) {
          final allProducts = ProductService.getProducts();
          final allGroceryProducts =
              allProducts.where((element) => element.code == 4).toList();

          if (allGroceryProducts.isEmpty) {
            return const Center(
              child: Text(
                "No Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.px(16)),
            child: Column(
              children: [
                Text('Groceries',style: heading(context),),
                Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    itemCount: allGroceryProducts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: context.px(12),
                    mainAxisSpacing: context.pxHeight(12),
                    itemBuilder: (context, index) {
                      final product = allGroceryProducts[index];
                      return GestureDetector(
                        onTap: () => openProductDetail(product),
                        child: CustomProduct(product: product),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
