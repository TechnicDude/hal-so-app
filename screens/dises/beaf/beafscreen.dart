import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/recipeprovider.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/style_file.dart';
import '../../home/sliderscreen.dart';
import 'beafui.dart';

class BeafScreen extends StatefulWidget {
  final String foodtypeName;
  final String foodtypeId;
  final bool isAnyCategory;
  final String type;
  final String bannername;

  BeafScreen(
      {required this.foodtypeId,
      required this.foodtypeName,
      required this.bannername,
      required this.type,
      required this.isAnyCategory});
  @override
  State<BeafScreen> createState() => _BeafScreenState();
}

class _BeafScreenState extends State<BeafScreen> {
  RecipeProvider recipeProvider = RecipeProvider();
  late ScrollController _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    getalldata();
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  void _loadMore() async {
    print("isAnyCategory ${widget.isAnyCategory}");
    if (!widget.isAnyCategory) {
      await recipeProvider.loadMorefoodtype(widget.foodtypeId);
    } else {
      await recipeProvider.loadMore(widget.foodtypeId, widget.type);
    }
  }

  getalldata() async {
    print("isAnyCategory ${widget.isAnyCategory}");
    if (!widget.isAnyCategory) {
      await recipeProvider
          .bannerlist("${widget.bannername}/${widget.foodtypeId}");
      await recipeProvider.recipelistfoodtype(widget.foodtypeId, 1);
    } else {
      await recipeProvider
          .bannerlist("${widget.bannername}/${widget.foodtypeId}");
      await recipeProvider.recipelist(widget.foodtypeId, 1, widget.type);
    }
  }

  TextEditingController sercheditcontroler = new TextEditingController();
  String searchString = '';
  bool searchshow = false;
  bool showpop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff6f3ef),
        // appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(50), child: AppBarScreens()),

        appBar: AppBar(
          title: searchshow
              ? Container(
                  width: double.infinity,
                  height: 5.h,
                  decoration: BoxDecoration(
                      color: colorWhite,
                      border: Border.all(color: colorGrey),
                      borderRadius: BorderRadius.circular(4.h)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: TextField(
                        controller: sercheditcontroler,
                        onChanged: ((value) {
                          setState(() {
                            searchString = sercheditcontroler.text;
                          });
                        }),
                        decoration: InputDecoration(
                            isDense: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colorGrey,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchshow = false;
                                  sercheditcontroler.clear();
                                  searchString = '';
                                });
                              },
                            ),
                            hintText: 'Sök...',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Amazon',
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                )
              : Text(" "),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: colorBlack,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            if (!searchshow)
              IconButton(
                onPressed: () {
                  setState(() {
                    searchshow = true;
                  });
                },
                icon: Icon(Icons.search, color: colorBlack),
              ),
          ],
          centerTitle: true,
          elevation: 1,
          backgroundColor: colorWhite,
        ),
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? InternetNotAvailable()
            : Consumer<RecipeProvider>(
                builder: (context, recipeProvider, child) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          //  SliderScreen(),

                          if (recipeProvider.bannerList.isNotEmpty)
                            SliderScreen(bannerdata: recipeProvider.bannerList),

                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(widget.foodtypeName,
                                    // "BEAF",
                                    style: Style_File.title
                                        .copyWith(fontSize: 20.sp)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),

                          !recipeProvider.isFirstdatafound
                              ? recipeProvider.datanotfound
                                  ? NoDataFoundErrorScreens(
                                      height: 50.h,
                                    )
                                  : BeafUI(
                                      recipedata: recipeProvider.recipeList,
                                      type: "foodtype",
                                      searchString: searchString,
                                      callback: (value) {
                                        if (value == "Premium") {
                                          if (!MyApp.subscriptioncheck)
                                            setState(() {
                                              showpop = true;
                                            });
                                        } else {
                                          getalldata();
                                        }
                                        // setState(() {
                                        //   showpop = true;
                                        // });
                                      },
                                    )
                              : LoaderScreen(),

                          SizedBox(
                            height: 3.h,
                          ),
                          if (recipeProvider.isLoadMoreRunning)
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),

                          Container(),
                        ],
                      ),
                    ),
                    if (showpop)
                      Center(
                        child: PremiumPopup(
                          callback: (value) {
                            setState(() {
                              showpop = false;
                            });
                          },
                        ),
                      )
                  ],
                );
              }));
  }
}
