import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_store/State%20controllers/banner_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

final bannercotroller = Get.put(BannerController());

class _CarouselBannerState extends State<CarouselBanner> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CarouselSlider(
          items: bannercotroller.bannerUrls
              .map((imageUrls) => CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: imageUrls,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ))
              .toList(),
          options: CarouselOptions(
              autoPlay: true, aspectRatio: 1.5, viewportFraction: 1));
    });
  }
}
