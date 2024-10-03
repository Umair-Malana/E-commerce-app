import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/home/home_screen.dart';
import 'package:e_store/widgets/customtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: uiHelp.red,
        title: CustomText(text: "My Orders", color: uiHelp.black, fontSize: 15),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("confirmOrders")
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshots.hasError) {
              return Center(child: Text("Error: ${snapshots.error}"));
            } else if (snapshots.hasData) {
              var snapdata = snapshots.data!.docs;
              return ListView.builder(
                  itemCount: snapdata.length,
                  itemBuilder: (context, index) {
                    var data = snapdata[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data["images"][0]),
                      ),
                      title: Text(data["name"]),
                      subtitle: Row(
                        children: [
                          Text(data["price"].toString()),
                          data["orderStatus"] == false
                              ? Text("Pending")
                              : Text("deliverd")
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: Text("No data in the docs"));
            }
          }),
    );
  }
}
