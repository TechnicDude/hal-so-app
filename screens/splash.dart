import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:halsogourmet/auth/locdb.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/firebasenotificationutils.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseNotificationUtils().requestingPermissionForIOS();
    FirebaseNotificationUtils().initfirebasesetting();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("remote");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        FirebaseNotificationUtils().showNotification(message);
      }
      if (Platform.isIOS) {
        if (notification != null) {
          FirebaseNotificationUtils().flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(

                  // android: AndroidNotificationDetails(
                  //   channel.id,
                  //   channel.name,
                  //   channelDescript
                  //ion: channel.description,
                  //   color: Colors.blue,
                  //   playSound: true,
                  //   icon: '@mipmap/ic_launcher',
                  // ),

                  iOS: DarwinNotificationDetails()));
        }
      }
    });

    startTimer();
    godo();
  }

  void godo() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );
    //  final DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    //   onDidReceiveLocalNotification:
    //       (int id, String? title, String? body, String? payload) async {
    //     didReceiveLocalNotificationSubject.add(
    //       ReceivedNotification(
    //         id: id,
    //         title: title,
    //         body: body,
    //         payload: payload,
    //       ),
    //     );
    //   },
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    //   notificationCategories: darwinNotificationCategories,
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            // iOS: initializationSettingsIOS,
            macOS: null);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              // Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, homePageRoute);
  }

  homePageRoute() async {
    String? onbard;
    await LocDb().isLoggedIn();
    bool check = await LocDb().loginapp;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    onbard = preferences.getString(StringFile.onBoard).toString();

    if (check) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.bottomNav, (Route<dynamic> route) => false);
    } else {
      if (onbard != "0") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.introScreen, (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.loginScreen, (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecondry,
      body: Stack(children: [
        Center(
          child: Container(
            height: 100.h,
            width: 100.h,
            child: Image.asset(
              ImageFile.splash,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: 20.h,
            child: Image.asset(
              ImageFile.logosplash,
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 70.h),
            child: const Center(
              child: CircularProgressIndicator(
                color: colorWhite,
              ),
            ))
      ]),
    );
  }
}
