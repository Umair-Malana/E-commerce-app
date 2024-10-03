import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Cart%20Screen/add_tocart_controller.dart';
import 'package:e_store/Cart%20Screen/price_calculation_controller.dart';

import 'package:e_store/home/home_screen.dart';
import 'package:e_store/saved%20products/saved_products_screen.dart';
import 'package:e_store/widgets/container_btn.dart';
import 'package:e_store/widgets/customtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

final cartScreenController = Get.put(CartScreenController());
final priceController = Get.put(PriceCalculationControllerer());

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: uiHelp.red,
          title: const Text("Cart Screen"),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("cart")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("cartproducts")
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshots.hasError) {
                return Center(child: Text("Error: ${snapshots.error}"));
              } else if (snapshots.hasData && snapshots.data!.docs.isNotEmpty) {
                var snapdata = snapshots.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  priceController.fullPrice(snapdata);
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapdata.length,
                  itemBuilder: (context, index) {
                    var data = snapdata[index];

                    return Card(
                      color: const Color.fromARGB(255, 247, 250, 220),
                      child: ListTile(
                        leading: Image(
                          fit: BoxFit.cover,
                          width: mediaWidth / 4,
                          image: NetworkImage(data["imageurl"][0]),
                        ),
                        title: CustomText(
                          text: data["name"],
                          color: uiHelp.black,
                          fontSize: 15,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("\$${data["price"]}"),
                            CircleAvatar(
                                backgroundColor: uiHelp.red,
                                child: IconButton(
                                  onPressed: () {
                                    if (data["productQuantity"] > 1) {
                                      // Decrease the quantity in Firestore
                                      FirebaseFirestore.instance
                                          .collection("cart")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("cartproducts")
                                          .doc(data
                                              .id) // Use the document id of the product
                                          .update({
                                        "productQuantity":
                                            data["productQuantity"] - 1,
                                        "price": data["price"] -
                                            (data["price"] /
                                                data["productQuantity"])
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                )),
                            Text(data["productQuantity"].toString()),
                            CircleAvatar(
                              backgroundColor: uiHelp.red,
                              child: IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("cartproducts")
                                      .doc(data
                                          .id) // Use the document id of the product
                                      .update({
                                    "productQuantity":
                                        data["productQuantity"] + 1,
                                    "price": data["price"] +
                                        (data["price"] /
                                            data["productQuantity"])
                                  });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              cartScreenController.deletefromCart(data.id);
                            },
                            icon: Icon(Icons.delete_rounded)),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No products in the cart"));
              }
            },
          ),
        ),
        bottomNavigationBar: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                  text: "Total price: ${priceController.fullprice.value}",
                  color: uiHelp.black,
                  fontSize: 15),
              Containerbutton(
                  onTap: () {
                    Get.to(() => SavedProductsScreen());
                  },
                  child: CustomText(
                      text: "Save products", color: uiHelp.black, fontSize: 15),
                  radius: 20,
                  height: 40,
                  width: 150)
            ],
          ),
        ));
  }
}
