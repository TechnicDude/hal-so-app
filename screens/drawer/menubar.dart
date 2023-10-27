import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/auth/login.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MenuBarScreens extends StatelessWidget {
  const MenuBarScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorSecondry,
      child: ListView(
        padding: EdgeInsets.only(left: 1.h, right: 1.h),
        children: [
          Container(
            height: 18.h,
            child: DrawerHeader(
              child: Image.asset(ImageFile.logom),
            ),
          ),
          // const Divider(
          //   color: Colors.grey,
          //   thickness: 1,
          // ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('Hem',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.bottomNav);
            },
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.restaurant,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('Alla recept',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushNamed(context, Routes.allrecipe,
                  arguments: {StringFile.filtteroption: "false"});
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.kitchen_outlined,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('I mitt kylskåp',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushNamed(context, Routes.myrefrigeratoringredients);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.food_bank_rounded,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('Inköpslista',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushNamed(context, Routes.planshoplistScreen);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('Mitt konto',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushNamed(context, Routes.profileScreen);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.videocam_outlined,
              size: 18,
              color: Colors.white,
            ),
            title: const Text('Videoklipp',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              Navigator.pushNamed(context, Routes.videocreensShow);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.login,
              size: 18,
              color: Colors.white,
            ),
            title: Text(MyApp.userid == null ? 'Logga in' : 'Logga ut',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Amazon',
                )),
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                btnOkColor: colorSecondry,
                borderSide: BorderSide(color: colorSecondry, width: 0.1.h),
                buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                headerAnimationLoop: false,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Logga ut',
                desc: 'Är du säker på att du vill logga ut från Halsogourmet?',
                showCloseIcon: true,
                // btnCancelOnPress: () {
                //   Navigator.pop(context);
                // },
                btnOkOnPress: () {
                  if (MyApp.userid == null) {
                    Navigator.pushNamed(context, Routes.loginScreen);
                  } else {
                    MyApp.logout();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(Routes.loginScreen,
                            (Route<dynamic> route) => false);
                  }
                },
              )..show();
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
