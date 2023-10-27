import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/subcategoryprovider.dart';
import 'package:halsogourmet/screens/dises/protein/proteinui.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/colors.dart';
import '../../home/sliderscreen.dart';

class ProteinScreen extends StatefulWidget {
  final String foodtypeName;
  final String foodtypeId;

  final String bannername;
  final String type;

  ProteinScreen(
      {required this.foodtypeId,
      required this.bannername,
      required this.type,
      required this.foodtypeName});

  // const ProteinScreen({Key? key}) : super(key: key);

  @override
  State<ProteinScreen> createState() => _ProteinScreenState();
}

class _ProteinScreenState extends State<ProteinScreen> {
  //  FoodcategoriesProvider foodcategoriesProvider = FoodcategoriesProvider();
  // bool searchshow = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   foodcategoriesProvider =
  //       Provider.of<FoodcategoriesProvider>(context, listen: false);
  //   foodcategoriesProvider.foodcategorylist(widget.foodtypeId);
  // }

  // String searchString = '';

  // @override
  // Widget build(BuildContext context) {
  //   final _scaffoldKey = GlobalKey<ScaffoldState>();

  FoodsubcategoriesProvider foodsubcategoriesProvider =
      FoodsubcategoriesProvider();
  bool searchshow = false;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    foodsubcategoriesProvider =
        Provider.of<FoodsubcategoriesProvider>(context, listen: false);

    getalldata();
    print("userid ${MyApp.userid}");
    print(MyApp.userid);
    print(MyApp.AUTH_TOKEN_VALUE);

    super.initState();
  }

  String searchString = '';
  getalldata() async {
    await foodsubcategoriesProvider.foodsubcategorieslist(
        widget.foodtypeId, widget.type);
    await foodsubcategoriesProvider
        .bannerlist("${widget.bannername}/${widget.foodtypeId}");
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<FoodsubcategoriesProvider>(
        builder: (context, foodsubcategoriesProvider, child) {
      return Scaffold(
        backgroundColor: colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarScreens(text: widget.foodtypeName)),

        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? InternetNotAvailable()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // SliderScreen(),
                    if (foodsubcategoriesProvider.bannerList.isNotEmpty)
                      SliderScreen(
                          bannerdata: foodsubcategoriesProvider.bannerList),

                    SizedBox(
                      height: 8.h,
                    ),

                    // ProteinUI(),
                    if (foodsubcategoriesProvider.datanotfound)
                      if (foodsubcategoriesProvider
                          .foodsubcategoriesList.isEmpty)
                        NoDataFoundErrorScreens(
                          height: 50.h,
                        ),

                    foodsubcategoriesProvider.datanotfound
                        ? ProteinUI(
                            subcategorydata:
                                foodsubcategoriesProvider.foodsubcategoriesList,
                            type: "foodtype",
                            searchString: '',
                          )
                        : LoaderScreen(),

                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),

        //})),
      );
    });
  }
}
