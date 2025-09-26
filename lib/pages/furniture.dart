// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';


class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  List<Product> products = [];
 

  void loadProducts() {
    var allproducts = ProductService.getProducts();
    products = allproducts.where((element) => element.code == 3).toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:bgcolor,
           appBar: const CustomAppBar(),

      body: products.isEmpty
              ? Center(child: Text("No Products"))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                    child: Text("Furniture",style: heading(context),),
                  ),
                  Expanded(
                    child: MasonryGridView.count(
                        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                        physics: const AlwaysScrollableScrollPhysics(),
                        crossAxisSpacing: context.px(12),
                        mainAxisSpacing: context.pxHeight(12),
                        crossAxisCount: 2,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                    
                          if (product.quantity > 0) {
                            return GestureDetector(
                              onTap: () => openProductDetail(product),
                              child: CustomProduct(product: product),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () => openProductDetail(product),
                              child: Stack(
                                children: [
                                  CustomProduct(product: product),
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
                          }
                        },
                      ),
                  ),
                ],
              ),
    );
  }



  void openProductDetail(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }
}
