import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/globalSearchprovider.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlobaSerchScreenActivity extends StatefulWidget {
  final Function? callback;

  const GlobaSerchScreenActivity({
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  State<GlobaSerchScreenActivity> createState() =>
      _GlobaSerchScreenActivityState();
}

class _GlobaSerchScreenActivityState extends State<GlobaSerchScreenActivity> {
  TextEditingController searchController = new TextEditingController();
  GlobalsearchProvider _dashBoradProvider = GlobalsearchProvider();

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _dashBoradProvider =
        Provider.of<GlobalsearchProvider>(context, listen: false);
    super.initState();
  }

  bool showpoppPremium = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarScreens(
            text: "Sök",
          )),
      body: Consumer<GlobalsearchProvider>(
          builder: (context, globalsearchProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Column(
                  children: [
                    TextField(
                      onChanged: ((value) {
                        _dashBoradProvider.globalsearclist(value.trim());
                      }),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.w),
                            borderSide: BorderSide(color: Colors.teal)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          color: colorGrey,
                          onPressed: () {},
                        ),
                        hintText: '  Sök...',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Amazon',
                            color: colorGrey),
                      ),
                    ),
                    if (globalsearchProvider.globalsearchModeldata.isEmpty)
                      NoDataFoundErrorScreens(
                        height: 50.h,
                      ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            globalsearchProvider.globalsearchModeldata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 6.w, right: 4.w, top: 10, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                if (globalsearchProvider
                                        .globalsearchModeldata[index].premium
                                        .toString()
                                        .toLowerCase() ==
                                    "true") {
                                  if (MyApp.subscriptioncheck) {
                                    if (globalsearchProvider
                                            .globalsearchModeldata[index]
                                            .goto ==
                                        'recipeDetail') {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.foodDetails,
                                        arguments: {
                                          StringFile.foodtypeId:
                                              globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .id
                                                  .toString(),
                                          StringFile.foodtypeName:
                                              globalsearchProvider
                                                      .globalsearchModeldata[
                                                          index]
                                                      .title ??
                                                  ''
                                        },
                                      );
                                    } else if (globalsearchProvider
                                            .globalsearchModeldata[index]
                                            .goto ==
                                        'recipe') {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.beafScreen,
                                        arguments: {
                                          StringFile.foodtypeId:
                                              globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .id
                                                  .toString(),
                                          StringFile.foodtypeName:
                                              globalsearchProvider
                                                      .globalsearchModeldata[
                                                          index]
                                                      .title ??
                                                  '',
                                          StringFile.bannertypes:
                                              StringFile.bannerfoodcategory,
                                          StringFile
                                              .screenname: globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .path ??
                                              '',
                                          StringFile.isAnyCategory: true,
                                        },
                                      );
                                    } else if (globalsearchProvider
                                            .globalsearchModeldata[index]
                                            .goto ==
                                        'subcategory') {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.meatScreen,
                                        arguments: {
                                          StringFile.foodtypeId:
                                              globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .id
                                                  .toString(),
                                          StringFile.foodtypeName:
                                              globalsearchProvider
                                                      .globalsearchModeldata[
                                                          index]
                                                      .title ??
                                                  ''
                                        },
                                      );
                                    } else if (globalsearchProvider
                                            .globalsearchModeldata[index]
                                            .goto ==
                                        'subCategories') {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.proteinScreen,
                                        arguments: {
                                          StringFile.foodtypeId:
                                              globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .id
                                                  .toString(),
                                          StringFile.foodtypeName:
                                              globalsearchProvider
                                                      .globalsearchModeldata[
                                                          index]
                                                      .title ??
                                                  '',
                                          StringFile.bannertypes:
                                              StringFile.bannerfoodcategory,
                                          StringFile
                                              .screenname: globalsearchProvider
                                                  .globalsearchModeldata[index]
                                                  .path ??
                                              '',
                                        },
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      showpoppPremium = true;
                                    });
                                  }
                                } else {
                                  if (globalsearchProvider
                                          .globalsearchModeldata[index].goto ==
                                      'recipeDetail') {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.foodDetails,
                                      arguments: {
                                        StringFile.foodtypeId:
                                            globalsearchProvider
                                                .globalsearchModeldata[index].id
                                                .toString(),
                                        StringFile
                                            .foodtypeName: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .title ??
                                            ''
                                      },
                                    );
                                  } else if (globalsearchProvider
                                          .globalsearchModeldata[index].goto ==
                                      'recipe') {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.beafScreen,
                                      arguments: {
                                        StringFile.foodtypeId:
                                            globalsearchProvider
                                                .globalsearchModeldata[index].id
                                                .toString(),
                                        StringFile
                                            .foodtypeName: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .title ??
                                            '',
                                        StringFile.bannertypes:
                                            StringFile.bannerfoodcategory,
                                        StringFile
                                            .screenname: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .path ??
                                            '',
                                        StringFile.isAnyCategory: true,
                                      },
                                    );
                                  } else if (globalsearchProvider
                                          .globalsearchModeldata[index].goto ==
                                      'subcategory') {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.meatScreen,
                                      arguments: {
                                        StringFile.foodtypeId:
                                            globalsearchProvider
                                                .globalsearchModeldata[index].id
                                                .toString(),
                                        StringFile
                                            .foodtypeName: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .title ??
                                            ''
                                      },
                                    );
                                  } else if (globalsearchProvider
                                          .globalsearchModeldata[index].goto ==
                                      'subCategories') {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.proteinScreen,
                                      arguments: {
                                        StringFile.foodtypeId:
                                            globalsearchProvider
                                                .globalsearchModeldata[index].id
                                                .toString(),
                                        StringFile
                                            .foodtypeName: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .title ??
                                            '',
                                        StringFile.bannertypes:
                                            StringFile.bannerfoodcategory,
                                        StringFile
                                            .screenname: globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .path ??
                                            '',
                                      },
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.black
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: .5,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.w),
                                        bottomLeft: Radius.circular(8.w),
                                        bottomRight: Radius.circular(4.w),
                                        topRight: Radius.circular(4.w))),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Positioned(
                                      top: 1.h,
                                      left: -4.w,
                                      child: Container(
                                        height: 9.h,
                                        width: 9.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorGrey,
                                            image: DecorationImage(
                                                image: globalsearchProvider
                                                        .globalsearchModeldata[
                                                            index]
                                                        .image!
                                                        .isEmpty
                                                    ? AssetImage(
                                                        ImageFile.meat,
                                                      )
                                                    : NetworkImage(
                                                        APIURL.imageurl +
                                                            (globalsearchProvider
                                                                    .globalsearchModeldata[
                                                                        index]
                                                                    .image ??
                                                                ''),
                                                      ) as ImageProvider,
                                                fit: BoxFit.fill),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: colorGrey,
                                                blurRadius: 5,
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            height: 11.h,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0.5.h,
                                                  bottom: 1.h,
                                                  left: 1.h,
                                                  right: 1.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                globalsearchProvider
                                                                        .globalsearchModeldata[
                                                                            index]
                                                                        .title ??
                                                                    '',
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textWidthBasis:
                                                                    TextWidthBasis
                                                                        .longestLine,
                                                                style: Style_File.title.copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: index %
                                                                                2 ==
                                                                            0
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                              SizedBox(
                                                                height: 1.h,
                                                              ),
                                                              Text(
                                                                globalsearchProvider
                                                                        .globalsearchModeldata[
                                                                            index]
                                                                        .subTitle ??
                                                                    '',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Style_File.subtitle.copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: index %
                                                                                2 ==
                                                                            0
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        //: Container(),
                                      ],
                                    ),
                                    (globalsearchProvider.globalsearchModeldata
                                                .isNotEmpty &&
                                            globalsearchProvider
                                                .globalsearchModeldata[index]
                                                .premium!)
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                right: 1.w,
                                                left: 70.w,
                                                top: 7.h),
                                            child: Container(
                                              width: 12.w,
                                              height: 2.5.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.w)),
                                              child: Center(
                                                  child: Text(
                                                "Premie",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              )),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            if (showpoppPremium)
              Center(child: PremiumPopup(
                callback: (value) {
                  setState(() {
                    showpoppPremium = false;
                  });
                },
              )),
          ],
        );
      }),
    );
  }
}
