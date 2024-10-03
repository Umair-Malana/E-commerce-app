import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Product%20details/product_details_creen.dart';
import 'package:e_store/State%20controllers/home_screen_controller.dart';
import 'package:e_store/ui/ui_helper.dart';
import 'package:e_store/widgets/carousel_banner.dart';
import 'package:e_store/widgets/customtext.dart';
import 'package:e_store/widgets/home_container.dart';
import 'package:e_store/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

UiHelp uiHelp = UiHelp();
final homeScreenController = Get.put(HomeScreenController());

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: uiHelp.red,
        title: Text("HomeScreen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselBanner(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "Categories", color: Colors.black, fontSize: 25),

                  Obx(() {
                    return Container(
                      alignment: Alignment.centerLeft,
                      height: mediaheight * 0.07,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: homeScreenController.categories.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Obx(
                                  () => ChoiceChip(
                                    showCheckmark: false,
                                    label: Text("All Products"),
                                    selected: homeScreenController
                                            .selectedCategory.value ==
                                        "All Products",
                                    onSelected: (isSelected) {
                                      homeScreenController.selectedCategory
                                          .value = "All Products";
                                    },
                                    selectedColor: uiHelp.red,
                                    backgroundColor: Colors.grey[100],
                                  ),
                                ));
                          }
                          if (index == 1) {
                            return Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Obx(
                                  () => ChoiceChip(
                                    showCheckmark: false,
                                    label: Text("Sale Products"),
                                    selected: homeScreenController
                                            .selectedCategory.value ==
                                        "Sale Products",
                                    onSelected: (isSelected) {
                                      homeScreenController.selectedCategory
                                          .value = "Sale Products";
                                    },
                                    selectedColor: uiHelp.red,
                                    backgroundColor: Colors.grey[100],
                                  ),
                                ));
                          }

                          // Other categories
                          String category =
                              homeScreenController.categories[index - 2];

                          return Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Obx(
                                () => ChoiceChip(
                                  showCheckmark: false,
                                  label: Text(category),
                                  selected: homeScreenController
                                          .selectedCategory.value ==
                                      category,
                                  onSelected: (isSelected) {
                                    homeScreenController
                                        .selectedCategory.value = category;
                                  },
                                  selectedColor: uiHelp.red,
                                  backgroundColor: Colors.grey[100],
                                ),
                              ));
                        },
                      ),
                    );
                  }),

                  Obx(() => CustomText(
                      text: homeScreenController.selectedCategory.value,
                      color: Colors.black,
                      fontSize: 25)),

                  // Display filtered products based on selected category
                  Obx(() {
                    // Filtering based on selected category
                    var filteredProducts =
                        homeScreenController.snapData.where((doc) {
                      if (homeScreenController.selectedCategory.value ==
                          "All Products") {
                        return true;
                      }

                      if (homeScreenController.selectedCategory.value ==
                          "Sale Products") {
                        // Check if the "sale" field exists
                        if (doc.data().containsKey("issale")) {
                          var docSale = doc["issale"] as bool;
                          return docSale == true;
                        } else {
                          // If "sale" field is missing, don't include this product
                          return false;
                        }
                      }

                      var docCategory =
                          (doc["category"] as String?)?.trim().toLowerCase();
                      return docCategory ==
                          homeScreenController.selectedCategory.value
                              .trim()
                              .toLowerCase();
                    }).toList();

                    return SizedBox(
                      height: mediaheight * 0.7,
                      child: filteredProducts.isEmpty
                          ? Center(child: Text("No products"))
                          : GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot product =
                                    filteredProducts[index];
                                Map<String, dynamic> productdetails =
                                    product.data() as Map<String, dynamic>;

                                Map<String, dynamic> productData =
                                    product.data() as Map<String, dynamic>;

                                // bool isOnSale =
                                //     productData.containsKey("issale") &&
                                //         product["issale"] == true;
                                String salePrice =
                                    productData.containsKey("saleprice")
                                        ? product["saleprice"]
                                        : product["price"];
                                return HomeContainer(
                                  imageurl: product["images"][0],
                                  name: product["name"],
                                  onTap: () {
                                    Get.to(() => ProductDetailsCreen(
                                          productDetails: productdetails,
                                        ));
                                  },
                                  price: product["price"],
                                  text: Text(salePrice),
                                );
                              }),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
      drawer: HomeDrawer(),
    );
  }
}
