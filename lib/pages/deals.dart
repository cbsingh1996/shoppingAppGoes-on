import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  List<Product> products = [];
  void loadProducts() async {
    setState(() {});
    products = ProductService.getProducts();
    products.sort((a, b) => b.offer.compareTo(a.offer));
    setState(() {});
  }

  void openProductDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );

    loadProducts();
  }

  @override
  initState() {
    super.initState();
    loadProducts();
  }

  final searchController = TextEditingController();
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: const CustomAppBar(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.px(16)),
            child: Text("Best deals", style: heading(context)),
          ),
          context.sbHeight(12),
          Expanded(
            child: MasonryGridView.count(
              padding: EdgeInsets.symmetric(horizontal: context.px(16)),
              crossAxisCount: 2,
              mainAxisSpacing: context.pxHeight(12),
              crossAxisSpacing: context.px(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                if (products.isEmpty) {
                  return Center(child: Text('No Products'));
                } else {
                  if (product.quantity == 0) {
                    return GestureDetector(
                      onTap: () => openProductDetail(product),
                      child: Stack(
                        children: [
                          CustomProduct(product: product),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: context.radius(12),
                                gradient: LinearGradient(
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
                  } else {
                    return GestureDetector(
                      onTap: () => openProductDetail(product),
                      child: CustomProduct(product: product),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
