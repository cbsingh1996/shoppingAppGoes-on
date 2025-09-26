import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/pages/furniture.dart';
import 'package:shopgoes/pages/grocery.dart';
import 'package:shopgoes/pages/kidproduct.dart';
import 'package:shopgoes/pages/manproduct.dart';
import 'package:shopgoes/pages/womenproducts.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/appbar.dart';
import 'package:shopgoes/widgets/custom.dart';

class HomescreenPage extends StatefulWidget {
  const HomescreenPage({super.key});

  @override
  State<HomescreenPage> createState() => _HomescreenPageState();
}

class _HomescreenPageState extends State<HomescreenPage> {
  bool proview = false;
  bool proview2 = false;

  final List _pages = [
    ManProduct(),
    WomenproductsPage(),
    Kidproduct(),
  FurniturePage(),
    GroceryPage(),
  ];

  List types = ["Man", "Women", "Kid", "Furniture", "Grocery"];
  List color = [
    Colors.white,
    const Color.fromARGB(255, 244, 89, 140),
    btcolor,
    const Color.fromARGB(255, 239, 105, 105),
    const Color.fromARGB(255, 138, 158, 213),
  ];
  List images = [
    'assets/images/sman.png',
    'assets/images/swomen.png',
    'assets/images/skid.png',
    'assets/images/sf.png',
    'assets/images/gro.jpg',
    
  ];

  int currentPage = 0;
  late PageController _pageController;
  Timer? _timer;
  final user = FirebaseAuth.instance.currentUser;

  List<Product> products = [];

  final searchController = TextEditingController();
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
    _pageController = PageController(viewportFraction: 1);

    // Auto-scroll carousel
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentPage < images.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void loadProducts() {
    products = ProductService.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:bgcolor,
      appBar:const CustomAppBar(),

      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.px(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.sbHeight(8),
            Text(
              "Goes'On",
              style: heading(context)
            ),
            context.sbHeight(12),
            _buildCarousel(),
            context.sbHeight(12),
            _buildIndicatorDots(),
            context.sbHeight(12),
            _buildTypeList(),

            context.sbHeight(12),
            _buildProductSection('Related Products', products, proview2, () {
              setState(() {
                proview2 = !proview2;
              });
            }, isGrid: true),
          ],
        ),
      ),
    )
    );
  }




  Widget _buildCarousel() {
    return SizedBox(
      height: context.pxHeight(180),
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) => setState(() => currentPage = index),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _pages[index]),
            ).then((_) => loadProducts());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: context.radius(12),
              color: color[index],
            ),
            child: ClipRRect(
              borderRadius: context.radius(12),
              child: Image.asset(images[index], fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        images.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.pink : Colors.grey,
            borderRadius: context.radius(10),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeList() {
    return SizedBox(
      height: context.pxHeight(32),
      child: Row(
        children: [
          Icon(Icons.category_sharp,color: txtColor,),
          context.sbWidth(12),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                types.length,
                (index) => Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => _pages[index]),
                        ).then((_) => loadProducts());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: context.px(20)),
                        decoration: BoxDecoration(
                          color: color[index],
                          borderRadius: context.radius(30),
                        ),
                        child: Center(
                          child: Text(types[index], style: style145(context)),
                        ),
                      ),
                    ),
                    context.sbWidth(12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(
    String title,
    List<Product> items,
    bool showAll,
    VoidCallback toggleView, {
    bool isGrid = false,
  }) {
    int displayCount = showAll
        ? items.length
        : (items.length >= 3 ? 3 : items.length);

    return ValueListenableBuilder(
valueListenable: Hive.box<Product>(ProductService.productBoxName).listenable(),      
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: subheading(context),
                ),
                GestureDetector(
                  onTap: toggleView,
                  child: Text(
                    showAll ? 'View less' : 'View All',
                    style: subheading(context,color: Colors.grey),
                    
                  ),
                ),
              ],
            ),
            context.sbHeight(12),
            isGrid
                ? MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: context.pxHeight(12),
                    crossAxisSpacing: context.px(12),
                    itemCount: showAll ? items.length : 2,
                    itemBuilder: (context, index) =>
                        _buildProductItem(items[index]),
                  )
                : SizedBox(
                    height: context.pxHeight(180),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        displayCount,
                        (index) => _buildProductItem(items[index]),
                      ),
                    ),
                  ),
          ],
        );
      }
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () => openProductDetail(product),
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
  }

  void openProductDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );
    loadProducts();
  }
}
