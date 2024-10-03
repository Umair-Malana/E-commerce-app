import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:e_store/Bottom%20Navbar/navbar_controller.dart';
import 'package:e_store/Cart%20Screen/cart_screen.dart';

import 'package:e_store/home/home_screen.dart';
import 'package:e_store/search%20screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

final bottomNavController = Get.put(NavbarController());

List screens = [HomeScreen(), CartScreen(), SearchScreen()];

class _NavBarScreenState extends State<NavBarScreen> {
  late NotchBottomBarController barController = NotchBottomBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens.elementAt(bottomNavController.index.value)),
      bottomNavigationBar: AnimatedNotchBottomBar(
          color: const Color.fromARGB(255, 247, 250, 220),
          notchColor: uiHelp.red,
          showTopRadius: false,
          notchBottomBarController: barController,
          bottomBarItems: [
            BottomBarItem(
                itemLabel: "Home",
                inActiveItem: Icon(Icons.home),
                activeItem: Icon(Icons.home_filled)),
            BottomBarItem(
                inActiveItem: Icon(Icons.card_travel_sharp),
                activeItem: Icon(Icons.category_rounded)),
            BottomBarItem(
                inActiveItem: Icon(Icons.search_rounded),
                activeItem: Icon(Icons.search_outlined)),
          ],
          onTap: (value) {
            bottomNavController.index.value = value;
          },
          kIconSize: 25,
          kBottomRadius: 20),
    );
  }
}
