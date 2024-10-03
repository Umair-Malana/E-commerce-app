import 'package:e_store/My%20orders/my_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/ui_helper.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: UiHelp().red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            runSpacing: 10,
            children: [
              ListTile(
                leading: CircleAvatar(),
                title: Text("data"),
                subtitle: Text("data"),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Get.to(() => MyOrders());
                },
                title: Text("My orders"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ));
  }
}
