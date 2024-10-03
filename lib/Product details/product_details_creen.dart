import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_store/Cart%20Screen/add_tocart_controller.dart';
import 'package:e_store/home/home_screen.dart';
import 'package:e_store/widgets/container_btn.dart';
import 'package:e_store/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:photo_view/photo_view_gallery.dart';

class ProductDetailsCreen extends StatefulWidget {
  final Map<String, dynamic> productDetails;
  const ProductDetailsCreen({super.key, required this.productDetails});

  @override
  State<ProductDetailsCreen> createState() => _ProductDetailsCreenState();
}

final cartController = Get.put(CartScreenController());

class _ProductDetailsCreenState extends State<ProductDetailsCreen> {
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = List<String>.from(widget.productDetails["images"]);
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: uiHelp.red,
          title: Text(widget.productDetails['name'] ?? 'Product Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: imageUrls.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    // Open full-screen image view
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: Border.all(
                          color: uiHelp.red,
                        ),
                        child: PhotoViewGallery.builder(
                          itemCount: imageUrls.length,
                          builder: (context, index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(imageUrls[index]),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                      width: double.infinity, imageUrl, fit: BoxFit.cover),
                );
              }).toList(),
              options: CarouselOptions(
                height: Get.height / 3,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: uiHelp.grey),
                    child: Text("4.5"),
                  ),
                  SizedBox(
                    height: mediaHeight * 0.03,
                  ),
                  CustomText(
                      text: widget.productDetails["name"],
                      color: uiHelp.black,
                      fontSize: 25),
                  CustomText(
                      text:
                          " Description:\n         ${widget.productDetails["description"]}",
                      color: uiHelp.black.withOpacity(0.7),
                      fontSize: 15),
                  SizedBox(
                    height: mediaHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: widget.productDetails["price"],
                          color: uiHelp.black,
                          fontSize: 20),
                      Containerbutton(
                        onTap: () {
                          cartController.addTocart(
                              widget.productDetails["name"],
                              widget.productDetails["price"],
                              widget.productDetails["images"],
                              widget.productDetails["description"],
                              widget.productDetails["name"],
                              1);
                        },
                        radius: 20,
                        height: mediaHeight * 0.06,
                        width: mediaWidth / 3,
                        child: Text("Add to cart"),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
