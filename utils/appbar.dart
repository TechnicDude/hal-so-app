import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/colors.dart';

class AppBarUI extends StatefulWidget {
  final String? image;
  final String? text;
  final String? icon2;
  final String? icon3;

  final Function()? onPressed;
  const AppBarUI({
    Key? key,
    this.image,
    this.text,
    this.icon2,
    this.icon3,
    this.onPressed,
  }) : super(key: key);

  @override
  State<AppBarUI> createState() => _AppBarUIState();
}

class _AppBarUIState extends State<AppBarUI> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      elevation: 1,
      backgroundColor: colorWhite,

      title: Text(
        widget.text ?? '',
        //"Protein",
        style: TextStyle(color: Colors.black),
      ),
      // leading: Builder(
      //   builder: (BuildContext context) {
      //     return IconButton(
      //       // icon: const Icon(Icons.menu_rounded),
      //       icon: const Icon(Icons.arrow_back),
      //       color: colorBlack,
      //       onPressed: () {
      //         Navigator.pop(context);
      //         //Navigator.pushNamed(context, Routes.bottomNav);
      //       },
      //     );
      //   },
      // ),
      // automaticallyImplyLeading: false,

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () async {
                String? token;
                try {
                  token = (await FirebaseMessaging.instance.getToken())!;
                  print(token);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.notifications_outlined),
              color: colorBlack,
            ),
            IconButton(
              onPressed: widget.onPressed,
              icon: Icon(Icons.settings_outlined),
              color: colorBlack,
            ),
          ],
        ),
      ],
    );
  }
}
