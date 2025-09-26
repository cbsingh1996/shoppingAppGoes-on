import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopgoes/context.dart';
import 'package:shopgoes/model/product_model.dart';
import 'package:shopgoes/services/mybag_service.dart';
import 'package:shopgoes/services/myfavorite_service.dart';
import 'package:shopgoes/services/product_service.dart';
import 'package:shopgoes/style.dart';

class CustomImageWidget extends StatelessWidget {
  final dynamic image;
  final BoxFit fit;
  final double? height;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.height,
  });

  Widget _wrapWithZoom(Widget child) {
    return InteractiveViewer(
      panEnabled: true,
      minScale: 1,
      maxScale: 4,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image == null || (image is String && image.isEmpty)) {
      return Container(
        color: Colors.grey[300],
        height: height ?? 120,
        width: 120,
        child: const Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        ),
      );
    }

    try {
      if (image is String) {
        if (image.startsWith('http')) {
          return _wrapWithZoom(
            Image.network(
              image,
              fit: fit,
              height: height,
              width: 120,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          );
        } else if (image.startsWith('/')) {
          return _wrapWithZoom(
            Image.file(
              File(image),
              fit: fit,
              height: height,
              width: 120,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
          );
        } else {
          return _wrapWithZoom(
            Image.asset(
              image,
              fit: fit,
              height: height,
              width: 120,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
          );
        }
      } else if (image is File) {
        return _wrapWithZoom(
          Image.file(
            image,
            fit: fit,
            height: height,
            width: 120,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        );
      }
    } catch (e) {
      return Container(
        color: Colors.grey[300],
        height: height,
        width: 120,
        child: const Icon(Icons.error, size: 40, color: Colors.red),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: height,
      width: 120,
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}

// ---------------------------------------------------CUSTOM PRODUCT-----------------------------------------------------------
class CustomProduct extends StatelessWidget {
  final Product product;
  final String str;

  const CustomProduct({super.key, required this.product, this.str = ''});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Product>(
        ProductService.productBoxName,
      ).listenable(),
      builder: (context, _, __) {
        // product ki current state le lo
        final currentProduct = ProductService.getProducts().firstWhere(
          (p) => p.id == product.id,
          orElse: () => product,
        );

        return SizedBox(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomImageWidget(image: currentProduct.images[0]),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: List.generate(
                      currentProduct.averageRating.round(),
                      (index) => Icon(Icons.star, color: btcolor, size: 10),
                    ),
                  ),
                  if (currentProduct.offer == 0)
                    Text(
                      '₹ ${currentProduct.price}',
                      style: planetxt(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹ ${currentProduct.price.toStringAsFixed(2)}',
                          style: planetxt(
                            context,
                            color: Colors.grey,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                        context.sbHeight(2),
                        Text(
                          '₹ ${(currentProduct.price * (100 - currentProduct.offer) / 100).toStringAsFixed(2)}',
                          style: planetxt(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  Text(
                    currentProduct.name,
                    style: style145(
                      context,
                    ).copyWith(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      currentProduct.inBag = !currentProduct.inBag;
                      await ProductService.updateProduct(currentProduct);

                      if (currentProduct.inBag) {
                        await MybagService.addToBag(currentProduct.id);
                      } else {
                        await MybagService.removeFromBag(currentProduct.id);
                      }
                    },
                    child: Container(
                      height: context.pxHeight(30),
                      width: double.infinity,
                      decoration: currentProduct.inBag
                          ? BoxDecoration(
                              color: btcolor,
                              borderRadius: context.radius(30),
                            )
                          : BoxDecoration(
                              border: Border.all(color: btcolor),
                              borderRadius: context.radius(30),
                            ),
                      child: Center(
                        child: Text(
                          'Add to cart',
                          style:
                              planetxt(
                                context,
                                color: currentProduct.inBag
                                    ? Colors.white
                                    : btcolor,
                              ).copyWith(
                                fontSize: context.sp(10),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: currentProduct.offer == 0
                    ? context.px(60)
                    : context.px(80),
                right: context.px(4),
                child: GestureDetector(
                  onTap: () async {
                    currentProduct.isFavorite = !currentProduct.isFavorite;
                    await ProductService.updateProduct(currentProduct);

                    if (currentProduct.isFavorite) {
                      if (!await FavoriteService.isFavorite(
                        currentProduct.id,
                      )) {
                        await FavoriteService.addToFavorites(currentProduct.id);
                      }
                    } else {
                      if (await FavoriteService.isFavorite(currentProduct.id)) {
                        await FavoriteService.removeFromFavorites(
                          currentProduct.id,
                        );
                      }
                    }
                  },
                  child: Icon(
                    currentProduct.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: btcolor,
                    size: context.px(24),
                  ),
                ),
              ),
              if (currentProduct.offer != 0)
                Positioned(
                  left: context.px(0),
                  top: context.pxHeight(-1),
                  child: Container(
                    padding: EdgeInsets.all(context.px(8)),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${currentProduct.offer} %',
                          style: TextStyle(
                            fontSize: context.sp(8),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Off',
                          style: TextStyle(
                            fontSize: context.sp(8),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
