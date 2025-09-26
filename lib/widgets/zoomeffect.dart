import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class ImageCarouselZoom extends StatefulWidget {
  final List<dynamic> images; // Can be URLs, asset paths, or Files

  const ImageCarouselZoom({super.key, required this.images});

  @override
  State<ImageCarouselZoom> createState() => _ImageCarouselZoomState();
}

class _ImageCarouselZoomState extends State<ImageCarouselZoom> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel Slider
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImage(image: image),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImage(image, BoxFit.cover),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.blue
                    : Colors.grey[400],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImage(dynamic image, BoxFit fit) {
    if (image is String && image.startsWith('http')) {
      return Image.network(image, fit: fit);
    } else if (image is String) {
      return Image.asset(image, fit: fit);
    } else if (image is File) {
      return Image.file(image, fit: fit);
    } else {
      return const SizedBox();
    }
  }
}

// Fullscreen zoomable image
class FullScreenImage extends StatelessWidget {
  final dynamic image;

  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: PhotoView(
          imageProvider: _getImageProvider(image),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(dynamic img) {
    if (img is String && img.startsWith('http')) {
      return NetworkImage(img);
    } else if (img is String) {
      return AssetImage(img);
    } else if (img is File) {
      return FileImage(img);
    } else {
      throw Exception("Unsupported image type");
    }
  }
}
