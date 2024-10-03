import 'package:e_store/widgets/customtext.dart';
import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final String imageurl, name, price;
  final double? heght, width;
  final dynamic onTap;
  final Widget? text;

  const HomeContainer({
    super.key,
    required this.imageurl,
    required this.name,
    this.heght,
    this.width,
    required this.onTap,
    required this.price,
    this.text
  });

  @override
  Widget build(BuildContext context) {
    final mediaheight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageurl,
                height: mediaheight * 0.15,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            CustomText(
                text: name, color: Colors.black, fontSize: mediaheight * 0.025),
            Row(
              children: [
                CustomText(
                    text: price,
                    color: Colors.black,
                    fontSize: mediaheight * 0.015),
               
              ],
            ),
          ],
        ),
      ),
    );
  }
}
