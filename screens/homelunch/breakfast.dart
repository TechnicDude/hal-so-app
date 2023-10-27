import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/foodcategoryprovider.dart';
import 'package:halsogourmet/screens/home/homecardui.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../page_routes/routes.dart';
import '../../utils/colors.dart';
import '../home/sliderscreen.dart';
import 'breakfastui.dart';

class BreakfastScreen extends StatefulWidget {
  final String foodtypeName;
  final String foodtypeId;
  bool datanotfound = false;

  BreakfastScreen({required this.foodtypeId, required this.foodtypeName});

  @override
  State<BreakfastScreen> createState() => _BreakfastScreenState();
}

class _BreakfastScreenState extends State<BreakfastScreen> {
  FoodcategoriesProvider foodcategoriesProvider = FoodcategoriesProvider();

  bool searchshow = false;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    foodcategoriesProvider =
        Provider.of<FoodcategoriesProvider>(context, listen: false);
    foodcategoriesProvider.foodcategorylist(widget.foodtypeId);

    getalldata();
    print("userid ${MyApp.userid}");
    print(MyApp.userid);
    print(MyApp.AUTH_TOKEN_VALUE);

    super.initState();
  }

  String searchString = '';
  getalldata() async {
    await foodcategoriesProvider.bannerlist("food-types/${widget.foodtypeId}");
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<FoodcategoriesProvider>(
        builder: (context, foodcategoriesProvider, child) {
      return Scaffold(
        backgroundColor: colorWhite,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarScreens(text: widget.foodtypeName)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (foodcategoriesProvider.bannerList.isNotEmpty)
                SliderScreen(bannerdata: foodcategoriesProvider.bannerList),

              SizedBox(
                height: 2.h,
              ),

              //  BreakfastUI(),
              // CardUI(
              //   foodtypedata: foodcategoriesProvider.foodcategoriesList,
              //   type: "subcategory",
              //   searchString: searchString,
              // ),

              if (foodcategoriesProvider.datanotfound)
                if (foodcategoriesProvider.foodcategoriesList.isEmpty)
                  NoDataFoundErrorScreens(
                    height: 50.h,
                  ),

              foodcategoriesProvider.datanotfound
                  ? BreakfastUI(
                      foodcategorydata:
                          foodcategoriesProvider.foodcategoriesList,
                      type: "foodcategory",
                      searchString: '',
                    )
                  : LoaderScreen(),

              SizedBox(
                height: 5.h,
              ),
            ],
          ),
          // );
          // }),
        ),
      );
    });
  }
}
