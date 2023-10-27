import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/recipeprovider.dart';
import 'package:halsogourmet/screens/dises/beaf/beafui.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllRecipeScreenActivity extends StatefulWidget {
  final String? filtteropen;
  const AllRecipeScreenActivity({super.key, this.filtteropen});

  @override
  State<AllRecipeScreenActivity> createState() =>
      _AllRecipeScreenActivityState();
}

class _AllRecipeScreenActivityState extends State<AllRecipeScreenActivity> {
  RecipeProvider recipeProvider = RecipeProvider();
  TextEditingController sercheditcontroler = new TextEditingController();
  String searchString = '';
  bool searchshow = false;
  bool filter = false;
  bool showpop = false;
  late ScrollController _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement initState
    recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    filter = widget.filtteropen == "true" ? true : false;
    getalldata();
    _controller = ScrollController()..addListener(_loadMore);

    super.initState();
  }

  void _loadMore() async {
    await recipeProvider.loadMoreallrecipe(filter.toString());
  }

  getalldata() async {
    await recipeProvider.allrecipelist(1, filter.toString(), '');
    //await recipeProvider.allrecipelist( 1, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorWhite,
        title: Text(
          widget.filtteropen != "true"
              ? "Alla recept"
              : "Kylskåpsingredienser Recept",
          //  "MEAT",
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
          : Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                return Stack(clipBehavior: Clip.none,
                    // alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        controller: _controller,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          border: Border.all(color: colorGrey),
                                          borderRadius:
                                              BorderRadius.circular(1.h)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 2.w),
                                          child: TextField(
                                            controller: sercheditcontroler,
                                            onChanged: ((value) async {
                                              // searchString =
                                              //     sercheditcontroler.text;
                                              recipeProvider.isFirstdatafound =
                                                  true;
                                              recipeProvider.datanotfound =
                                                  false;
                                              await recipeProvider
                                                  .allrecipelist(
                                                      1,
                                                      filter.toString(),
                                                      sercheditcontroler.text);
                                            }),
                                            decoration: InputDecoration(
                                                isDense: true,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: colorGrey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      searchshow = false;
                                                      sercheditcontroler
                                                          .clear();
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
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          if (widget.filtteropen != "true") {
                                            if (!filter) {
                                              await recipeProvider
                                                  .allrecipelist(1, "true", '');
                                              setState(() {
                                                filter = true;
                                              });
                                            } else {
                                              await recipeProvider
                                                  .allrecipelist(
                                                      1, "false", '');
                                              setState(() {
                                                filter = false;
                                              });
                                            }
                                          }
                                        },
                                        child: filter
                                            ? Image.asset(
                                                ImageFile.filterimage,
                                                height: 5.h,
                                                width: 5.h,
                                              )
                                            : Image.asset(
                                                ImageFile.filtercloseimage,
                                                height: 5.h,
                                                width: 5.h,
                                              ))
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
                                              print(MyApp.subscriptioncheck);
                                              if (!MyApp.subscriptioncheck)
                                                setState(() {
                                                  showpop = true;
                                                });
                                            }
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
                      ),
                      if (showpop)
                        Center(child: PremiumPopup(
                          callback: (value) {
                            setState(() {
                              showpop = false;
                            });
                          },
                        )),
                    ]);
              },
            ),
    );
  }
}
