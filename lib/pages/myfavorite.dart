// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/pages/notification.dart';
import 'package:shopgoes/pages/search.dart';
import 'package:shopgoes/pages/shopnow.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/services/myfavorite_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custom.dart';

class MyfavoritePage extends StatefulWidget {
  const MyfavoritePage({super.key});

  @override
  State<MyfavoritePage> createState() => _MyfavoritePageState();
}

class _MyfavoritePageState extends State<MyfavoritePage> {
  List<Product> products = [];
  List<Product> favoriteproducts = [];

  Future<void> loadfavorite() async {
    final ids = await FavoriteService.getAllFavoriteIds();

    products = ProductService.getProducts();
    setState(() {
      favoriteproducts = ids.reversed
          .map((id) => products.firstWhere((p) => p.id == id))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadfavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor:bgcolor,
      title: Row(
        children: [
          // Search Box
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchPage()),
                );
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Favorite Icon with Count
          ValueListenableBuilder<int>(
            valueListenable: FavoriteService.favoriteCountNotifier,
            builder: (context, count, _) {
              return GestureDetector(
                onTap: ()  {
                 
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 28,
                      color: Colors.black87,
                    ),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
          const SizedBox(width: 8),

          // Notification Icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            child: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 28,
            ),
          ),
        ],
      ),
    ),
      body:favoriteproducts.isEmpty?Center(
        child: Text("no data"),

      ) :Padding(
                    padding:  EdgeInsets.symmetric(horizontal: context.px(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Favorite",style: heading(context),),
            Expanded(
              child: ListView.builder(
                      padding:  EdgeInsets.symmetric(vertical: context.pxHeight(12),horizontal: 0
                      ),
                      itemCount: favoriteproducts.length,
                      itemBuilder: (context, index) {
                        final product = favoriteproducts[index];
                        return Slidable(
                          key: ValueKey(product.key),
              
                          // ✅ Swipe karne par right side se delete button dikhega
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(), // smooth drawer style motion
                            extentRatio: 0.25, // 25% width tak khulega
                            children: [
                              SlidableAction(
                                onPressed: (_) async {
                                  // ✅ Hive update
                                  setState(() {
                                    product.isFavorite = false;
                                    favoriteproducts.removeAt(index);
                                  });
                                  await ProductService.updateProduct(product);
              
                                  await FavoriteService.removeFromFavorites(product.id);
              
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.name} removed from favorites",
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: context.radius(12),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
              
                                label: 'Delete',
                              ),
                            ],
                          ),
              
                          child: Padding(
                            padding: EdgeInsets.all(context.px(0)),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ✅ Product image
                                        SizedBox(
                                          height: context.pxHeight(160),
                                          width: context.px(160),
                                          child: product.images.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailPage(
                                                                product: product,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      child: CustomImageWidget(
                                                        image: product.images[0],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        context.sbWidth(4),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                maxLines: 2,
                                                style: style145(context).copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              context.sbHeight(10),
                                              Text(
                                                'Price',
                                                style: style145(context).copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              product.offer > 0
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          '₹ ${product.price}',
                                                          style:
                                                              planetxt(
                                                                context,
                                                                color: Colors.grey,
                                                              ).copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                              ),
                                                        ),
                                                        context.sbWidth(4),
                                                        Text(
                                                          "₹ ${(product.price - (product.price * product.offer / 100)).toStringAsFixed(2)}",
                                                          style: planetxt(context),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      ' ${product.price}',
                                                      maxLines: 8,
                                                      style: planetxt(context),
                                                    ),
                                              context.sbHeight(50),
                                              GestureDetector(
                                                onTap: () {
                                                  List<Product> listproducts = [
                                                    product,
                                                  ];
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShopNowPage(
                                                            price:
                                                                (product.price -
                                                                (product.price *
                                                                    product.offer /
                                                                    100)),
                                                            list: listproducts,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: context.pxHeight(40),
                                                  decoration: BoxDecoration(
                                                    color: btcolor,
                                                    borderRadius: context.radius(16),
                                                  ),
                                                  child: Text(
                                                    'Buy Now',
                                                    style: style145(
                                                      context,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                        
                                    context.sbHeight(15)
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: context.pxHeight(60),
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        product.inBag = !product.inBag;
                                      });
                                        
                                      await ProductService.updateProduct(product);
                                        
                                      if (product.inBag) {
                                        await MybagService.addToBag(product.id);
                                      } else {
                                        await MybagService.removeFromBag(product.id);
                                      }
                                    },
                                    child: product.inBag
                                        ? Icon(
                                            Icons.shopping_bag,
                                            color: btcolor,
                                            size: context.px(34),
                                          )
                                        : Icon(
                                            Icons.shopping_bag_outlined,
                                            color: btcolor,
                                            size: context.px(34),
                                          ),
                                  ),
                                ),
                                        
                                // ✅ Favorite remove button
                                Positioned(
                                  right: context.px(0),
                                  top: context.pxHeight(28),
                                  child: GestureDetector(
                                    onTap: () async {
                                      // ✅ Hive update
                                      setState(() {
                                        product.isFavorite = false;
                                        favoriteproducts.removeAt(index);
                                      });
                                      await ProductService.updateProduct(product);
                                        
                                      await FavoriteService.removeFromFavorites(
                                        product.id,
                                      );
                                        
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${product.name} removed from favorites",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: btcolor,
                                      size: context.px(30),
                                    ),
                                  ),
                                ),
                                if (product.offer > 0)
                                  Positioned(
                                    left: 0,
                                    top: context.pxHeight(-4),
                                    child: Container(
                                      padding: EdgeInsets.all(context.px(8)),
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
                                          ).copyWith(fontSize: context.sp(8)),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
