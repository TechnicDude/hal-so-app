import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/dashboardprovider.dart';
import 'package:halsogourmet/screens/drawer/menubar.dart';
import 'package:halsogourmet/screens/home/homecardui.dart';
import 'package:halsogourmet/screens/home/sliderscreen.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/videoslider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../page_routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DashBoradProvider _dashBoradProvider = DashBoradProvider();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _dashBoradProvider = Provider.of<DashBoradProvider>(context, listen: false);
    getalldata();
    print("userid ${MyApp.userid}");
    print(MyApp.userid);
    print(MyApp.AUTH_TOKEN_VALUE);
    super.initState();
  }

  getalldata() async {
    await _dashBoradProvider.bannerlist("main/0");
    await _dashBoradProvider.foodtypelist();
    await _dashBoradProvider.notificationcount();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<DashBoradProvider>(
        builder: (context, dashBoradProvider, child) {
      return Scaffold(
        backgroundColor: colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: colorWhite,
          // title: Container(
          //   decoration: BoxDecoration(
          //       border: Border.all(color: colorGrey, width: 0.3.w),
          //       color: colorWhite,
          //       borderRadius: BorderRadius.circular(4.h)),
          //   child: Center(
          //     child: Padding(
          //       padding:
          //           EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 0.5.w),
          //       child: InkWell(
          //         onTap: () {
          //           Navigator.pushNamed(context, Routes.globalSearch);
          //         },
          //         child: TextField(
          //           readOnly: true,
          //           onChanged: ((value) {}),
          //           decoration: InputDecoration(
          //               suffixIcon: IconButton(
          //                 icon: Icon(Icons.search),
          //                 color: colorGrey,
          //                 onPressed: () {
          //                   Navigator.pushNamed(context, Routes.globalSearch);
          //                 },
          //               ),
          //               hintText: '  Sök...',
          //               hintStyle: TextStyle(
          //                   fontSize: 14,
          //                   fontFamily: 'Amazon',
          //                   color: colorGrey),
          //               border: InputBorder.none),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                // icon: const Icon(Icons.menu_rounded),
                icon: Image.asset(ImageFile.navbar),
                color: colorBlack,

                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.globalSearch);
                  },
                  icon: const Icon(Icons.search),
                  color: colorBlack,
                ),
                Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () async {
                        print("object");
                        String? token;
                        try {
                          token =
                              (await FirebaseMessaging.instance.getToken())!;
                          print(token);
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pushNamed(context, Routes.notificationScreen)
                            .then((value) {
                          getalldata();
                        });
                      },
                      icon: const Icon(Icons.notifications_outlined),
                      color: colorBlack,
                    ),
                    Container(
                      height: 5.w,
                      width: 5.w,
                      decoration: BoxDecoration(boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 3.0,
                        ),
                      ], color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          dashBoradProvider.countnotification,
                          style: Style_File.title,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        drawer: MenuBarScreens(),
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? InternetNotAvailable()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (dashBoradProvider.bannerList.isNotEmpty)
                      SliderScreen(bannerdata: dashBoradProvider.bannerList),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, Routes.healthSchoolVideo)
                            .then((value) {
                          setState(() {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          });
                        });
                      }),
                      child: Container(
                        height: 4.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: colorSecondry,
                          borderRadius: BorderRadius.circular(3.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Hälsoskolan",
                            style: Style_File.title
                                .copyWith(color: colorWhite, fontSize: 20.sp),
                          ),
                        ),
                      ),
                    ),
                    dashBoradProvider.foodtypeModel.data != null
                        ? dashBoradProvider.datanotfound
                            ? NoDataFoundErrorScreens(
                                height: 50.h,
                              )
                            : CardUI(
                                foodtypedata: dashBoradProvider.foodtypeList,
                                type: "foodtype",
                                searchString: '',
                              )
                        : LoaderScreen(),
                  ],
                ),
              ),
      );
    });
  }
}
