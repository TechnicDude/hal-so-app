import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_file.dart';
import '../../../utils/style_file.dart';

class BeafUI extends StatefulWidget {
  final List<RecipeData>? recipedata;
  final String type;
  final String searchString;
  final Function? callback;

  const BeafUI({
    Key? key,
    required this.recipedata,
    required this.type,
    required this.searchString,
    this.callback,
  }) : super(key: key);

  @override
  State<BeafUI> createState() => _BeafUIState();
}

class _BeafUIState extends State<BeafUI> {
  List<RecipeData> bottomlist = [];
  bool datashow = false;

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  Future fetchdata() async {
    bottomlist = [];
    for (int i = 0; i < widget.recipedata!.length; i++) {
      if (widget.recipedata![i].title!
          .toLowerCase()
          .contains(widget.searchString.toLowerCase())) {
        bottomlist.add(widget.recipedata![i]);
      }
    }
    datashow = true;
    return bottomlist;
  }

  bool isPressed = false;
  bool isPressedLike = false;

  Future _isPressedLike(
      String like, String recipeid, int index, String likeid) async {
    print(like);
    if (like == "1") {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.dislike(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          bottomlist[index].isLike = "0";
        });
      }
      DialogHelper.showFlutterToast(strMsg: "Som att ta bort framgångsrikt");
    } else {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.like(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          bottomlist[index].isLike = "1";
        });

        DialogHelper.showFlutterToast(strMsg: "Gilla tillagd framgångsrikt");
      }
    }
  }

  bool showpop = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchdata(),
        builder: (context, snapshot) {
          if (bottomlist.isEmpty)
            return NoDataFoundErrorScreens(
              height: 50.h,
            );

          if (snapshot.hasData && datashow) {
            return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  ListView.builder(
                    itemCount: bottomlist.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 6.w, right: 6.w, top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            if (bottomlist.isNotEmpty &&
                                bottomlist[index].premium!) {
                              if (MyApp.subscriptioncheck) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.foodDetails,
                                  arguments: {
                                    StringFile.foodtypeId:
                                        bottomlist[index].id.toString(),
                                    StringFile.foodtypeName:
                                        bottomlist[index].title ?? ''
                                  },
                                ).then((value) {
                                  widget.callback!("ok");
                                });
                              } else {
                                widget.callback!("Premium");
                              }
                            } else {
                              Navigator.pushNamed(
                                context,
                                Routes.foodDetails,
                                arguments: {
                                  StringFile.foodtypeId:
                                      bottomlist[index].id.toString(),
                                  StringFile.foodtypeName:
                                      bottomlist[index].title ?? ''
                                },
                              ).then((value) {
                                widget.callback!("ok");
                              });
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
                                    height: 10.h,
                                    width: 10.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorGrey,
                                        // borderRadius:
                                        //     BorderRadius.circular(4.w),
                                        image: DecorationImage(
                                            image: bottomlist[index]
                                                    .recipeimage!
                                                    .isEmpty
                                                ? AssetImage(
                                                    ImageFile.meat,
                                                  )
                                                : NetworkImage(APIURL.imageurl +
                                                        bottomlist[index]
                                                            .recipeimage![0]
                                                            .image!)
                                                    as ImageProvider,
                                            fit: BoxFit.cover),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: colorGrey,
                                            blurRadius: 5,
                                          ),
                                        ]),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        height: 12.h,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        bottomlist[index]
                                                            .title!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Style_File.title
                                                            .copyWith(
                                                                fontSize: 16.sp,
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(bottomlist[index]
                                                                .isLike !=
                                                            null
                                                        ? bottomlist[index]
                                                                    .isLike! ==
                                                                "1"
                                                            ? Icons.thumb_up_alt
                                                            : Icons
                                                                .thumb_up_alt_outlined
                                                        : Icons
                                                            .thumb_up_alt_outlined),
                                                    onPressed: () =>
                                                        _isPressedLike(
                                                            bottomlist[index]
                                                                .isLike!,
                                                            bottomlist[index]
                                                                .id!
                                                                .toString(),
                                                            index,
                                                            bottomlist[index]
                                                                        .isLike !=
                                                                    null
                                                                ? bottomlist[
                                                                        index]
                                                                    .isLike!
                                                                    .toString()
                                                                : '0'),
                                                    iconSize: 6.w,
                                                    color: bottomlist[index]
                                                                .isLike! ==
                                                            "1"
                                                        ? Colors.red
                                                        : index % 2 != 0
                                                            ? Colors.black
                                                            : Colors.white,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Servering",
                                                        style: Style_File.title
                                                            .copyWith(
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                      Text(
                                                        bottomlist[index]
                                                            .serving
                                                            .toString(),
                                                        style: Style_File.title
                                                            .copyWith(
                                                                fontSize: 14.sp,
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
                                                  SizedBox(
                                                    width: 6.w,
                                                  ),
                                                  Container(
                                                    height: 2.5.h,
                                                    width: .5.w,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Tillagningstid",
                                                        style: Style_File.title
                                                            .copyWith(
                                                                fontSize: 14.sp,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                      Text(
                                                        " ${((int.parse(bottomlist[index].prepareTime.toString()) + int.parse(bottomlist[index].prepareTime.toString())).toString())} min",
                                                        style: Style_File.title
                                                            .copyWith(
                                                                fontSize: 14.sp,
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
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  (bottomlist.isNotEmpty &&
                                                          bottomlist[index]
                                                              .premium!)
                                                      ? Container(
                                                          width: 12.w,
                                                          height: 2.5.h,
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          1.w)),
                                                          child: Center(
                                                              child: Text(
                                                            "Premie",
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (showpop)
                    Container(
                      height: 10.h,
                      width: 90.w,
                      color: Colors.transparent,
                      child: PremiumPopup(
                        callback: (value) {
                          print(value);
                          setState(() {
                            showpop = false;
                          });
                        },
                      ),
                    )
                ]);
          } else {
            return LoaderScreen();
          }
        });
  }
}
