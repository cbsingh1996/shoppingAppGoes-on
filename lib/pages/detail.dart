// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/shopnow.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/services/myfavorite_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';
import 'package:shopgoes/widgets/custombt.dart';
import 'package:shopgoes/widgets/zoomeffect.dart';



class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Product> relatedProducts = [];
  bool isviewall = false;
  bool forreview = false;

  @override
  void initState() {
    super.initState();
    loadRelatedProducts();
  }

  void loadRelatedProducts() {
    final allProducts = ProductService.getProducts();
    relatedProducts =
        allProducts.where((p) => p.code == widget.product.code).toList();
  }

  void openProductDetail(Product product) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(product: product)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box<Product>(ProductService.productBoxName);

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: const CustomAppBar(),
      body: ValueListenableBuilder(
        valueListenable: productBox.listenable(),
        builder: (context, Box<Product> box, _) {
          final product = widget.product;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name & Rating
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: heading(context)
                            .copyWith(fontSize: context.sp(25), color: Colors.black),
                      ),
                      context.sbHeight(10),
                      Row(
                        children: [
                          const Text('Rating:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: List.generate(
                              product.averageRating.round(),
                              (index) => Icon(
                                Icons.star,
                                color: btcolor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Image Carousel + Offer + Favorite + Out of Stock Overlay
                SizedBox(
                  height: context.pxHeight(300),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: context.radius(12),
                        child: ImageCarouselZoom(images: product.images),
                      ),
                      if (product.offer != 0)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(context.px(8)),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${product.offer} %',
                                    style: TextStyle(
                                        fontSize: context.sp(8),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text('Off',
                                    style: TextStyle(
                                        fontSize: context.sp(8),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        right: context.px(8),
                        top: context.pxHeight(8),
                        child: GestureDetector(
                          onTap: () async {
                            product.isFavorite = !product.isFavorite;
                            await product.save();

                            if (product.isFavorite) {
                              await FavoriteService.addToFavorites(product.id);
                            } else {
                              await FavoriteService.removeFromFavorites(product.id);
                            }
                          },
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: btcolor,
                            size: 40,
                          ),
                        ),
                      ),
                      if (product.quantity == 0)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: context.radius(12),
                              color: Colors.white70,
                            ),
                            child: Center(
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Price, Stock & Add to Bag
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                  child: Column(
                    children: [
                      SizedBox(height: context.pxHeight(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price :", style: style145(context)),
                              if (product.offer == 0)
                                Text('₹ ${product.price}',
                                    style: planetxt(context)
                                        .copyWith(fontWeight: FontWeight.bold))
                              else
                                Row(
                                  children: [
                                    Text(
                                      '₹ ${product.price.toStringAsFixed(2)}',
                                      style: planetxt(context, color: Colors.grey)
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                    ),
                                    context.sbWidth(8),
                                    Text(
                                      '₹ ${(product.price * (100 - product.offer) / 100).toStringAsFixed(2)}',
                                      style: planetxt(context)
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              Text(
                                product.quantity > 0 ? "In stock" : "Out of stock",
                                style: planetxt(
                                    context,
                                    color: product.quantity > 0
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!product.inBag) {
                                product.inBag = true;
                                await product.save();
                                await MybagService.addToBag(product.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Added in bag")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Already added in bag")));
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: btcolor,
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      context.sbHeight(15),
                      Custombt(
                        text: 'Buy Now',
                        ontap: product.quantity == 0
                            ? () {}
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShopNowPage(
                                      price: (product.price *
                                          (100 - product.offer) /
                                          100),
                                      list: [product],
                                    ),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),

                // Related Products
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You may also like',
                        style: style145(context).copyWith(fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isviewall = !isviewall;
                          });
                        },
                        child: Text(
                          isviewall ? 'View less' : 'View all',
                          style: style1(context).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                context.sbHeight(15),
                relatedProducts.isEmpty
                    ? const Center(child: Text('No Products'))
                    : MasonryGridView.count(
                        padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: context.px(12),
                        mainAxisSpacing: context.pxHeight(12),
                        crossAxisCount: 2,
                        itemCount: isviewall
                            ? relatedProducts.length
                            : (relatedProducts.length > 2 ? 2 : relatedProducts.length),
                        itemBuilder: (context, index) {
                          final prod = relatedProducts[index];
                          return GestureDetector(
                            onTap: () => openProductDetail(prod),
                            child: Stack(
                              children: [
                                CustomProduct(product: prod),
                                if (prod.quantity == 0)
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
                  ),
            context.sbHeight(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.px(16)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    forreview = !forreview;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reviews & Ratings',
                      style: subheading(context, color: Colors.blue),
                    ),
                    Icon(
                      forreview ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            ),
            if (!forreview) context.sbHeight(40),

            if (forreview && widget.product.reviews.isNotEmpty)
              ...widget.product.reviews.map((review) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.px(16),
                    vertical: context.px(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Row
                      Row(
                        children: [
                          Container(
                            width: context.px(40),
                            height: context.pxHeight(40),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                          context.sbWidth(8),
                          Expanded(
                            child: Text(
                              review.userId,
                              style: style145(context),
                            ),
                          ),
                        ],
                      ),

                      // Stars
                      Row(
                        children: List.generate(
                          review.rating.round(),
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 16,
                          ),
                        ),
                      ),

                      context.sbHeight(6),

                      // Comment
                      Text(
                        review.comment,
                        style: planetxt(context),
                        softWrap: true,
                        maxLines: 25,
                      ),

                      Divider(thickness: 0.8, color: Colors.grey[300]),
                    ],
                  ),
                );
              })
            else if (forreview)
              Padding(
                padding: EdgeInsets.all(context.px(16)),
                child: Column(
                  children: [
                    Text(
                      "No reviews yet!",
                      style: planetxt(context, color: Colors.black54),
                    ),
                    context.sbHeight(40),
                  ],
                ),
              ),
          ],
        )
          );
        }
      )
    );
  }
}
