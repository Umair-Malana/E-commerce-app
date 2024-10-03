import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/Order%20placing/customer_device_token.dart';
import 'package:e_store/Order%20placing/order_details.dart';
import 'package:e_store/home/home_screen.dart';

import 'package:e_store/widgets/container_btn.dart';
import 'package:e_store/widgets/customtext.dart';
import 'package:e_store/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Cart Screen/add_tocart_controller.dart';
import '../Cart Screen/price_calculation_controller.dart';

class SavedProductsScreen extends StatefulWidget {
  const SavedProductsScreen({
    super.key,
  });

  @override
  State<SavedProductsScreen> createState() => _SavedProductsScreenState();
}

final cartScreenController = Get.put(CartScreenController());
final priceController = Get.put(PriceCalculationControllerer());

TextEditingController name = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController address = TextEditingController();

class _SavedProductsScreenState extends State<SavedProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    // final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: uiHelp.red,
          title: Text("Saved Products"),
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
                            Text(data["productQuantity"].toString()),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No saved products"));
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
                    bottomSheet();
                  },
                  child: CustomText(
                      text: "Confirm order", color: uiHelp.black, fontSize: 15),
                  radius: 20,
                  height: 40,
                  width: 150)
            ],
          ),
        ));
  }

  void bottomSheet() {
    Get.bottomSheet(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomTextfield(
              preficIcon: Icon(Icons.person),
              obscureText: false,
              hintText: "Name",
              controller: name),
          SizedBox(height: 10),
          CustomTextfield(
              preficIcon: Icon(Icons.phone),
              obscureText: false,
              hintText: "Phone",
              controller: phone),
          SizedBox(height: 10),
          CustomTextfield(
              preficIcon: Icon(Icons.home_sharp),
              obscureText: false,
              hintText: "Address",
              controller: address),
          SizedBox(height: 10),
          Containerbutton(
              onTap: () async {
                if (name.text.isNotEmpty &&
                    address.text.isNotEmpty &&
                    phone.text.isNotEmpty) {
                  String customerToken = await getCustomerdevicetoken();
                  placeOrder(
                    context: context,
                    customerName: name.text,
                    customerAddress: address.text,
                    customerPhone: phone.text,
                    customerToken: customerToken,
                  );
                  name.clear();
                  phone.clear();
                  address.clear();
                } else {}
              },
              child: CustomText(
                  text: "Place order", color: uiHelp.black, fontSize: 15),
              radius: 20,
              height: 50,
              width: 150)
        ],
      ),
    ));
  }
}
