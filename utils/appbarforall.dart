import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/colors.dart';

class AppBarScreens extends StatelessWidget {
  final String? image;
  final String? text;
  final String? icon2;
  final String? icon3;

  final Function()? onPressed;
  const AppBarScreens({
    Key? key,
    this.image,
    this.text,
    this.icon2,
    this.icon3,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorWhite,
      title: Text(
        text ?? '',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     IconButton(
        //       onPressed: onPressed,
        //       icon: Icon(Icons.notifications_outlined),
        //       color: colorBlack,
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
