import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/subsubcategoryprovider.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../details/recentrecipe.dart';
import '../../home/sliderscreen.dart';
import 'meatui.dart';

class MeatScreen extends StatefulWidget {
  final String foodtypeName;
  final String foodtypeId;

  MeatScreen({required this.foodtypeId, required this.foodtypeName});

  // const MeatScreen({Key? key}) : super(key: key);

  @override
  State<MeatScreen> createState() => _MeatScreenState();
}

class _MeatScreenState extends State<MeatScreen> {
  FoodsubsubcategoriesProvider foodsubsubcategoriesProvider =
      FoodsubsubcategoriesProvider();
  bool searchshow = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    foodsubsubcategoriesProvider =
        Provider.of<FoodsubsubcategoriesProvider>(context, listen: false);
    foodsubsubcategoriesProvider.foodsubsubcategorieslist(widget.foodtypeId);

    getalldata();
    print("userid ${MyApp.userid}");
    print(MyApp.userid);
    print(MyApp.AUTH_TOKEN_VALUE);

    super.initState();
  }

  String searchString = '';
  getalldata() async {
    await foodsubsubcategoriesProvider
        .bannerlist("sub-category/${widget.foodtypeId}");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodsubsubcategoriesProvider>(
        builder: (context, foodsubsubcategoriesProvider, child) {
      return Scaffold(
        backgroundColor: colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: colorWhite,
          title: Text(
            widget.foodtypeName,
            style: TextStyle(color: Colors.black),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                color: colorBlack,
                onPressed: () {
                  Navigator.pop(context);
                  //  Navigator.pushNamed(context, Routes.bottomNav);
                },
              );
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? InternetNotAvailable()
            : SingleChildScrollView(
                child: Column(
                  children: [
//              SliderScreen(),

                    if (foodsubsubcategoriesProvider.bannerList.isNotEmpty)
                      SliderScreen(
                          bannerdata: foodsubsubcategoriesProvider.bannerList),

                    SizedBox(
                      height: 2.h,
                    ),
                    // InkWell(
                    //     onTap: () {
                    //       Navigator.pushNamed(context, Routes.bottomNav);
                    //     },
                    //     child: MeatUI()),
                    if (foodsubsubcategoriesProvider.datanotfound)
                      if (foodsubsubcategoriesProvider
                          .foodsubsubcategoriesList.isEmpty)
                        NoDataFoundErrorScreens(
                          height: 50.h,
                        ),

                    foodsubsubcategoriesProvider.datanotfound != null
                        ? MeatUI(
                            subsubcategorydata: foodsubsubcategoriesProvider
                                .foodsubsubcategoriesList,
                            type: "foodtype",
                            searchString: '',
                          )
                        : LoaderScreen(),

                    // MeatUI(),

                    SizedBox(
                      height: 2.h,
                    ),

                    // Container(),
                  ],
                ),
              ),
      );
    });
  }
}
