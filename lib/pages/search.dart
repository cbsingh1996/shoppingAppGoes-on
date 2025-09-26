import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/pages/detail.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';
import 'package:shopgoes/widgets/custom.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<Product> searchResults = [];
  List<String> recentSearches = [];
  bool isLoading = false;
  String str = '';

  late Box<String> recentBox;

  @override
  void initState() {
    super.initState();
    initHive();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    recentBox = await Hive.openBox<String>('recentSearchBox');
    loadRecentSearches();
  }

  void loadRecentSearches() {
    setState(() {
      recentSearches = recentBox.values.toList().reversed.take(5).toList();
    });
  }

  Future<void> performSearch(String query) async {
    setState(() {
      isLoading = true;
      searchResults.clear();
    });

    await Future.delayed(const Duration(milliseconds: 300)); // simulate delay

    final allProducts = ProductService.getProducts();
    final results = allProducts.where((product) {
      return product.keywords.any(
        (k) => k.toLowerCase().contains(query.toLowerCase()),
      );
    }).toList();

    // Store recent search with max limit (20 entries)
    if (query.trim().isNotEmpty) {
      if (!recentBox.values.contains(query.trim())) {
        await recentBox.add(query.trim());

        if (recentBox.length > 20) {
          await recentBox.deleteAt(0); // oldest delete
        }

        loadRecentSearches();
      }
    }

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 1,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: TextField(
              onSubmitted: (_) {
                setState(() {
                  str = searchController.text;
                });
                if (searchController.text.trim().isNotEmpty) {
                  performSearch(searchController.text.trim());
                }
              },
              autofocus: true,
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      str = searchController.text;
                    });
                    if (searchController.text.trim().isNotEmpty) {
                      performSearch(searchController.text.trim());
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : searchController.text.trim().isEmpty
            ? Container(
              color: bgcolor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                  "Are you sure you want to clear all recent searches?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
              
                            if (confirm == true) {
                              await recentBox.clear();
                              setState(() {
                                recentSearches.clear();
                              });
                            }
                          },
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: recentSearches
                          .map(
                            (text) => ActionChip(
                              label: Text(text),
                              onPressed: () {
                                searchController.text = text;
                                performSearch(text);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
            )
            : searchResults.isEmpty
            ? const Center(child: Text('No products found'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Search Result',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: MasonryGridView.count(
                      padding: EdgeInsets.symmetric(horizontal: context.px(16)),
                      crossAxisCount: 2,
                      mainAxisSpacing: context.pxHeight(12),
                      crossAxisSpacing: context.px(12),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var product = searchResults[index];

                        if (product.quantity == 0) {
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
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white70,
                                          Colors.white54,
                                        ],
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
                            child: CustomProduct(product: product, str: str),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void openProductDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(product: product)),
    );
  }
}
