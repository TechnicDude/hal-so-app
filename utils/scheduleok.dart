import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/planprovider.dart';
import 'package:halsogourmet/utils/appbar.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScheduleOK extends StatefulWidget {
  final String? date;
  final DateTime? dateTime;
  final String? foodtypeid;
  const ScheduleOK({
    super.key,
    this.date,
    this.dateTime,
    this.foodtypeid,
  });

  @override
  State<ScheduleOK> createState() => _ScheduleOKState();
}

class _ScheduleOKState extends State<ScheduleOK> {
  PlanFoodcategoriesProvider _foodcategoriesProvider =
      PlanFoodcategoriesProvider();
  List check = [true, false, false, false, false, false, false];
  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _foodcategoriesProvider =
        Provider.of<PlanFoodcategoriesProvider>(context, listen: false);
    _foodcategoriesProvider.calendarlist(
        DateFormat("yyyy-MM-dd").format(widget.dateTime!).toString());
    super.initState();
  }

  bool cooksshow = true;
  DateTime? startdate = DateTime.now();
  Future delete(String id) async {
    LikeApi likeApi = LikeApi();
    final response = await likeApi.deleterefoodplan(id);
    print(response);
    if (response['status'] == "success") {
      //await planfoodprovider.finalcalenderList();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      await _foodcategoriesProvider
          .calendarlist(DateFormat("yyyy-MM-dd").format(startdate!).toString());
    } else {
      DialogHelper.showFlutterToast(strMsg: response['error']);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Consumer<PlanFoodcategoriesProvider>(
          builder: (context, planfoodprovider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: 12.h,
                  child: ListView.builder(
                      itemCount: 7,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(2.h),
                          child: InkWell(
                            onTap: () {
                              for (int i = 0; i < check.length; i++) {
                                setState(() {
                                  check[i] = false;
                                });
                              }
                              setState(() {
                                check[index] = true;
                              });
                              DateTime datedata =
                                  widget.dateTime!.add(Duration(days: index));
                              startdate = datedata;
                              _foodcategoriesProvider.calendarlist(
                                  DateFormat("yyyy-MM-dd")
                                      .format(datedata)
                                      .toString());
                            },
                            child: Container(
                              height: 10.h,
                              width: 4.2.h,
                              decoration: BoxDecoration(
                                color: check[index]
                                    ? colorSecondry
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.5.h),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('EE', "sv")
                                            .format(widget.dateTime!
                                                .add(Duration(days: index)))
                                            .toString(),
                                        style: Style_File.title.copyWith(
                                            color: check[index]
                                                ? colorWhite
                                                : Colors.black,
                                            fontSize: 16.sp),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(0.2.h),
                                        child: Container(
                                          height: 3.h,
                                          width: 3.h,
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius:
                                                BorderRadius.circular(2.h),
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.dateTime!
                                                  .add(Duration(days: index))
                                                  .day
                                                  .toString(),
                                              style: Style_File.title.copyWith(
                                                  color: check[index]
                                                      ? colorSecondry
                                                      : Colors.black,
                                                  fontSize: 16.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 2.h,
                ),

                if (cooksshow && planfoodprovider.calendarList.length == 0)
                  NoDataFoundErrorScreens(
                    height: 50.h,
                  ),
                if (cooksshow)
                  Container(
                    child: ListView.builder(
                        itemCount: planfoodprovider.calendarList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      planfoodprovider
                                          .calendarList[index].foodtypeName!,
                                      style: Style_File.title.copyWith(
                                          color: colorBlack, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                    itemCount: planfoodprovider
                                        .calendarList[index].items!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.only(top: 2.h, bottom: 2.h),
                                    shrinkWrap: true,
                                    itemBuilder: (context, indexs) {
                                      return Padding(
                                        padding: EdgeInsets.all(1.h),
                                        child: InkWell(
                                          // onTap: () {
                                          //   Navigator.pushNamed(
                                          //     context,
                                          //     Routes.foodDetails,
                                          //     arguments: {
                                          //       StringFile.foodtypeId:
                                          //           planfoodprovider
                                          //               .calendarList[index]
                                          //               .items![indexs]
                                          //               .recipeId
                                          //               .toString(),
                                          //       StringFile.foodtypeName:
                                          //           planfoodprovider
                                          //                   .calendarList[index]
                                          //                   .items![indexs]
                                          //                   .recipes![0]
                                          //                   .title ??
                                          //               ''
                                          //     },
                                          //   ).then((value) => {

                                          //         planfoodprovider.calendarlist(
                                          //             DateFormat("yyyy-MM-dd")
                                          //                 .format(startdate!)
                                          //                 .toString())
                                          //       });
                                          // },
                                          child: Slidable(
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            secondaryActions: <Widget>[
                                              Container(
                                                child: IconSlideAction(
                                                  caption: "Delete",
                                                  onTap: () {
                                                    _dialogBuilder(
                                                        context,
                                                        planfoodprovider
                                                            .calendarList[index]
                                                            .items![indexs]
                                                            .id
                                                            .toString());
                                                  },
                                                  iconWidget: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 6.h,
                                                  ),
                                                  // color: colorlightGrey,
                                                ),

                                                // child: InkWell(
                                                //   onTap: () {
                                                //     _dialogBuilder(
                                                //         context,
                                                //         planfoodprovider
                                                //             .calendarList[index]
                                                //             .items![indexs]
                                                //             .id
                                                //             .toString());
                                                //   },
                                                //   child: Icon(
                                                //     Icons.delete,
                                                //     color: Colors.red,
                                                //     size: 40,
                                                //   ),
                                                // ),
                                              ),
                                            ],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: indexs % 2 == 0
                                                      ? Colors.black
                                                      : Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: .5,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.w),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.w),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  4.w),
                                                          topRight: Radius
                                                              .circular(4.w))),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Positioned(
                                                    top: 1.h,
                                                    left: -4.w,
                                                    child: Container(
                                                      height: 10.h,
                                                      width: 10.h,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: colorGrey,
                                                          image: planfoodprovider
                                                                      .calendarList[
                                                                          index]
                                                                      .items![
                                                                          indexs]
                                                                      .type!
                                                                      .toLowerCase() ==
                                                                  "ingradient"
                                                              ? DecorationImage(
                                                                  image: (planfoodprovider.calendarList[index].items![indexs].ingradient!.isEmpty ||
                                                                          planfoodprovider
                                                                              .calendarList[
                                                                                  index]
                                                                              .items![
                                                                                  indexs]
                                                                              .ingradient![
                                                                                  0]
                                                                              .image!
                                                                              .isEmpty)
                                                                      ? AssetImage(
                                                                          ImageFile
                                                                              .meat,
                                                                        )
                                                                      : NetworkImage(
                                                                              APIURL.imageurl + planfoodprovider.calendarList[index].items![indexs].ingradient![0].image!.toString())
                                                                          as ImageProvider,
                                                                  fit: BoxFit
                                                                      .fill)
                                                              : DecorationImage(
                                                                  image: (planfoodprovider.calendarList[index].items![indexs].recipes!.isEmpty || planfoodprovider.calendarList[index].items![indexs].recipes![0].recipeimage!.isEmpty)
                                                                      ? AssetImage(
                                                                          ImageFile
                                                                              .meat,
                                                                        )
                                                                      : NetworkImage(APIURL.imageurl + planfoodprovider.calendarList[index].items![indexs].recipes![0].recipeimage![0].image.toString()) as ImageProvider,
                                                                  fit: BoxFit.fill),

                                                          // DecorationImage(
                                                          //     image: (planfoodprovider
                                                          //                 .calendarList[
                                                          //                     index]
                                                          //                 .items![
                                                          //                     indexs]
                                                          //                 .recipes!
                                                          //                 .isEmpty ||
                                                          //             planfoodprovider
                                                          //                 .calendarList[
                                                          //                     index]
                                                          //                 .items![
                                                          //                     indexs]
                                                          //                 .recipes![
                                                          //                     0]
                                                          //                 .recipeimage!
                                                          //                 .isEmpty)
                                                          //         ? AssetImage(
                                                          //             ImageFile
                                                          //                 .meat,
                                                          //           )
                                                          //         : NetworkImage(APIURL
                                                          //                 .imageurl +
                                                          //             planfoodprovider
                                                          //                 .calendarList[index]
                                                          //                 .items![indexs]
                                                          //                 .recipes![0]
                                                          //                 .recipeimage![0]
                                                          //                 .image
                                                          //                 .toString()) as ImageProvider,
                                                          //     fit: BoxFit.fill),

                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: colorGrey,
                                                              blurRadius: 5,
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      Flexible(
                                                        child: SizedBox(
                                                          height: 12.h,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 1.h,
                                                                    bottom: 1.h,
                                                                    left: 1.h,
                                                                    right: 1.h),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            30.w,
                                                                        child: Text(
                                                                            planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty
                                                                                ? planfoodprovider.calendarList[index].items![indexs].recipes![0].title!
                                                                                : planfoodprovider.calendarList[index].items![indexs].ingradient![0].title.toString(),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: Style_File.title.copyWith(fontSize: 16.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                                                                      ),
                                                                      // SizedBox(
                                                                      //   width:
                                                                      //       10.w,
                                                                      // ),
                                                                      Spacer(),
                                                                      Icon(
                                                                        Icons
                                                                            .local_fire_department_rounded,
                                                                        size:
                                                                            25,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      Flexible(
                                                                        child: Text(
                                                                            "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].calorie! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].calorie.toString()} kcal ",
                                                                            style:
                                                                                Style_File.title.copyWith(fontSize: 14.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Protein",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Text(
                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].protein! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].protein.toString()} ",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: indexs % 2 == 0 ? Colors.white : Colors.black),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          3.w,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          2.5.h,
                                                                      width:
                                                                          .5.w,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          3.w,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Kolhydrater",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Text(
                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].carbohydrate! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].carbohydrate.toString()} g",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: indexs % 2 == 0 ? Colors.white : Colors.black),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          3.w,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          2.5.h,
                                                                      width:
                                                                          .5.w,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          3.w,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Fett",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Text(
                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].fat! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].fat.toString()} g",
                                                                          //  "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",
                                                                          style: Style_File.title.copyWith(
                                                                              fontSize: 13.sp,
                                                                              color: indexs % 2 == 0 ? Colors.white : Colors.black),
                                                                        )
                                                                      ],
                                                                    ),
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
                                        ),
                                      );
                                    }),
                                Center(
                                  child: Text(
                                    "${planfoodprovider.calendarList[index].protein} g Protein . ${planfoodprovider.calendarList[index].carbohydrate} g  Kolhydrater . ${planfoodprovider.calendarList[index].fat} g Fett",
                                    style: Style_File.title.copyWith(
                                        color: Colors.grey, fontSize: 15.sp),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                SizedBox(
                  height: 2.h,
                )

                // if (!ingredientsshow)
                //   Center(
                //     child: Text(
                //       "82 g Kolhydrater . 17 g Fett. 52 g  Protein",
                //       style: Style_File.title.copyWith(color: Colors.grey),
                //     ),
                //   ),
                // if (ingredientsshow &&
                //     planfoodprovider.weeklyingredientList.isEmpty)
                //   NoDataFoundErrorScreens(
                //     height: 50.h,
                //   ),
                // if (ingredientsshow &&
                //     planfoodprovider.weeklyingredientList.isNotEmpty)
                //   IngredientListScreens(
                //       weeklyingredientList:
                //           planfoodprovider.weeklyingredientList)

                // // if (planfoodprovider.finalcalenderList.length == 0)
                // //   NoDataFoundErrorScreens(
                // //     height: 50.h,
                // //   ),
                // // ListView.builder(
                // //     itemCount: planfoodprovider.finalcalenderList.length,
                // //     shrinkWrap: true,
                // //     physics: NeverScrollableScrollPhysics(),
                // //     itemBuilder: (context, index) {
                // //       return Column(
                // //         crossAxisAlignment: CrossAxisAlignment.start,
                // //         children: [
                // //           Text(
                // //             planfoodprovider.finalcalenderList[index]
                // //                 .calendarrecipes![0].foodtype!.foodType!,
                // //             style: Style_File.title
                // //                 .copyWith(color: colorBlack, fontSize: 16.sp),
                // //           ),
                // //           ListView.builder(
                // //               itemCount: planfoodprovider
                // //                   .finalcalenderList[index]
                // //                   .calendarrecipes!
                // //                   .length,
                // //               physics: NeverScrollableScrollPhysics(),
                // //               padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                // //               shrinkWrap: true,
                // //               itemBuilder: (context, indexs) {
                // //                 return Padding(
                // //                   padding: const EdgeInsets.all(8.0),
                // //                   child: Row(
                // //                     crossAxisAlignment:
                // //                         CrossAxisAlignment.start,
                // //                     children: [
                // //                       Container(
                // //                           height: 9.h,
                // //                           width: 9.h,
                // //                           decoration: BoxDecoration(
                // //                               color: colorGrey,
                // //                               borderRadius:
                // //                                   BorderRadius.circular(4.w),
                // //                               boxShadow: [
                // //                                 BoxShadow(
                // //                                   color: colorGrey,
                // //                                   blurRadius: 0.2.h,
                // //                                 ),
                // //                               ]),
                // //                           child: ClipRRect(
                // //                             borderRadius:
                // //                                 BorderRadius.circular(2.h),
                // //                             child: Image.asset(
                // //                               "assets/images/b5.jpg",
                // //                               fit: BoxFit.fill,
                // //                             ),
                // //                           )),
                // //                       SizedBox(
                // //                         width: 3.h,
                // //                       ),
                // //                       Column(
                // //                         crossAxisAlignment:
                // //                             CrossAxisAlignment.start,
                // //                         children: [
                // //                           Text(
                // //                             planfoodprovider
                // //                                 .finalcalenderList[index]
                // //                                 .calendarrecipes![indexs]
                // //                                 .recipes![0]
                // //                                 .title!,
                // //                             style: Style_File.title.copyWith(
                // //                                 color: colorBlack,
                // //                                 fontSize: 16.sp),
                // //                           ),
                // //                           Text(
                // //                             "5 Serving",
                // //                             style: Style_File.subtitle.copyWith(
                // //                               color: colorBlack,
                // //                             ),
                // //                           ),
                // //                         ],
                // //                       ),
                // //                       Spacer(),
                // //                       Icon(
                // //                         Icons.edit,
                // //                         size: 24,
                // //                         color: colorBlack,
                // //                       ),
                // //                     ],
                // //                   ),
                // //                 );
                // //               }),
                // //         ],
                // //       );
                // //     }),

                // if (cooksshow && planfoodprovider.finalcalenderList.length == 0)
                //   NoDataFoundErrorScreens(
                //     height: 50.h,
                //   ),
                // if (cooksshow)
                //   Container(
                //     child: ListView.builder(
                //         itemCount: planfoodprovider.finalcalenderList.length,
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         itemBuilder: (context, index) {
                //           return Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   planfoodprovider.finalcalenderList[index]
                //                       .calendarrecipes![0].foodtype!.foodType!,
                //                   style: Style_File.title.copyWith(
                //                       color: colorBlack, fontSize: 16.sp),
                //                 ),
                //                 ListView.builder(
                //                     itemCount: planfoodprovider
                //                         .finalcalenderList[index]
                //                         .calendarrecipes!
                //                         .length,
                //                     physics: NeverScrollableScrollPhysics(),
                //                     padding:
                //                         EdgeInsets.only(top: 2.h, bottom: 2.h),
                //                     shrinkWrap: true,
                //                     itemBuilder: (context, indexs) {
                //                       return Padding(
                //                         padding: EdgeInsets.all(1.h),
                //                         child: InkWell(
                //                           onTap: () {
                //                             Navigator.pushNamed(
                //                               context,
                //                               Routes.foodDetails,
                //                               arguments: {
                //                                 StringFile.foodtypeId:
                //                                     planfoodprovider
                //                                         .finalcalenderList[
                //                                             index]
                //                                         .calendarrecipes![
                //                                             indexs]
                //                                         .recipes![0]
                //                                         .id
                //                                         .toString(),
                //                                 StringFile.foodtypeName:
                //                                     planfoodprovider
                //                                             .finalcalenderList[
                //                                                 index]
                //                                             .calendarrecipes![
                //                                                 indexs]
                //                                             .recipes![0]
                //                                             .title ??
                //                                         ''
                //                               },
                //                             ).then((value) => {
                //                                   //  _favoriterecipeProvider.foodcategorylist()
                //                                   planfoodprovider
                //                                       .finalcalenderList[index]
                //                                       .calendarrecipes![indexs],
                //                                 });
                //                           },
                //                           child: Slidable(
                //                             actionPane:
                //                                 SlidableDrawerActionPane(),
                //                             actionExtentRatio: 0.25,
                //                             secondaryActions: <Widget>[
                //                               Container(
                //                                 child: InkWell(
                //                                   onTap: () {
                //                                     _dialogBuilder(
                //                                         context,
                //                                         planfoodprovider
                //                                             .finalcalenderList[
                //                                                 index]
                //                                             .calendarrecipes![
                //                                                 indexs]
                //                                             .id
                //                                             .toString());
                //                                   },
                //                                   child: Icon(
                //                                     Icons.delete,
                //                                     color: Colors.red,
                //                                     size: 40,
                //                                   ),
                //                                 ),
                //                               ),
                //                             ],
                //                             child: Container(
                //                               decoration: BoxDecoration(
                //                                   color: indexs % 2 == 0
                //                                       ? Colors.black
                //                                       : Colors.white,
                //                                   boxShadow: [
                //                                     BoxShadow(
                //                                       color: Colors.black,
                //                                       blurRadius: .5,
                //                                     ),
                //                                   ],
                //                                   borderRadius:
                //                                       BorderRadius.only(
                //                                           topLeft:
                //                                               Radius.circular(
                //                                                   8.w),
                //                                           bottomLeft:
                //                                               Radius.circular(
                //                                                   8.w),
                //                                           bottomRight:
                //                                               Radius.circular(
                //                                                   4.w),
                //                                           topRight: Radius
                //                                               .circular(4.w))),
                //                               child: Stack(
                //                                 clipBehavior: Clip.none,
                //                                 children: [
                //                                   Positioned(
                //                                     top: 1.h,
                //                                     left: -4.w,
                //                                     child: Container(
                //                                       height: 10.h,
                //                                       width: 10.h,
                //                                       decoration: BoxDecoration(
                //                                           shape: BoxShape
                //                                               .circle,
                //                                           color: colorGrey,
                //                                           // borderRadius:
                //                                           //     BorderRadius.circular(4.w),
                //                                           image:
                //                                               DecorationImage(
                //                                                   image: (planfoodprovider
                //                                                               .finalcalenderList[
                //                                                                   index]
                //                                                               .calendarrecipes![
                //                                                                   indexs]
                //                                                               .recipes!
                //                                                               .isEmpty ||
                //                                                           planfoodprovider
                //                                                               .finalcalenderList[
                //                                                                   index]
                //                                                               .calendarrecipes![
                //                                                                   indexs]
                //                                                               .recipes![
                //                                                                   0]
                //                                                               .recipeimage!
                //                                                               .isEmpty)
                //                                                       ? AssetImage(
                //                                                           ImageFile
                //                                                               .meat,
                //                                                         )
                //                                                       : NetworkImage(APIURL
                //                                                               .imageurl +
                //                                                           planfoodprovider
                //                                                               .finalcalenderList[index]
                //                                                               .calendarrecipes![indexs]
                //                                                               .recipes![0]
                //                                                               .recipeimage![0]
                //                                                               .image
                //                                                               .toString()) as ImageProvider,
                //                                                   fit: BoxFit.fill),
                //                                           boxShadow: const [
                //                                             BoxShadow(
                //                                               color: colorGrey,
                //                                               blurRadius: 5,
                //                                             ),
                //                                           ]),
                //                                     ),
                //                                   ),
                //                                   Row(
                //                                     crossAxisAlignment:
                //                                         CrossAxisAlignment
                //                                             .center,
                //                                     mainAxisAlignment:
                //                                         MainAxisAlignment
                //                                             .spaceBetween,
                //                                     children: [
                //                                       SizedBox(
                //                                         width: 20.w,
                //                                       ),
                //                                       Flexible(
                //                                         child: SizedBox(
                //                                           height: 12.h,
                //                                           child: Padding(
                //                                             padding:
                //                                                 EdgeInsets.only(
                //                                                     top: 1.h,
                //                                                     bottom: 1.h,
                //                                                     left: 1.h,
                //                                                     right: 1.h),
                //                                             child: Column(
                //                                               crossAxisAlignment:
                //                                                   CrossAxisAlignment
                //                                                       .start,
                //                                               mainAxisAlignment:
                //                                                   MainAxisAlignment
                //                                                       .spaceBetween,
                //                                               children: [
                //                                                 Row(
                //                                                   // mainAxisAlignment:
                //                                                   //     MainAxisAlignment
                //                                                   //         .spaceBetween,
                //                                                   children: [
                //                                                     SizedBox(
                //                                                       width:
                //                                                           40.w,
                //                                                       child: Text(
                //                                                           planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes!.isNotEmpty
                //                                                               ? planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].title!
                //                                                               : planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].ingradients![0].title.toString(),
                //                                                           // planfoodprovider
                //                                                           //     .finalcalenderList[
                //                                                           //         index]
                //                                                           //     .calendarrecipes![
                //                                                           //         indexs]
                //                                                           //     .recipes![
                //                                                           //         0]
                //                                                           //     .title!,
                //                                                           maxLines: 1,
                //                                                           overflow: TextOverflow.ellipsis,
                //                                                           style: Style_File.title.copyWith(fontSize: 16.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                //                                                     ),
                //                                                     // SizedBox(
                //                                                     //   width:
                //                                                     //       10.w,
                //                                                     // ),
                //                                                     Spacer(),
                //                                                     Icon(
                //                                                       Icons
                //                                                           .local_fire_department_rounded,
                //                                                       size: 25,
                //                                                       color: Colors
                //                                                           .red,
                //                                                     ),
                //                                                     Flexible(
                //                                                       child: Text(
                //                                                           "90 kcal",
                //                                                           // planfoodprovider
                //                                                           //     .finalcalenderList[
                //                                                           //         index]
                //                                                           //     .calendarrecipes![
                //                                                           //         indexs]
                //                                                           //     .recipes![
                //                                                           //         0]
                //                                                           //     .title!,
                //                                                           // maxLines:
                //                                                           //     1,
                //                                                           // overflow: TextOverflow
                //                                                           //     .ellipsis,
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 16.sp,
                //                                                               color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                //                                                     ),
                //                                                   ],
                //                                                 ),

                //                                                 Row(
                //                                                   children: [
                //                                                     Column(
                //                                                       children: [
                //                                                         Text(
                //                                                           "Protien",
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: Colors.grey),
                //                                                         ),
                //                                                         Text(
                //                                                           "70 gm",
                //                                                           // planfoodprovider
                //                                                           //     .finalcalenderList[index]
                //                                                           //     .calendarrecipes![indexs]
                //                                                           //     .recipes![0]
                //                                                           //     .serving!
                //                                                           //     .toString(),
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: indexs % 2 == 0 ? Colors.white : Colors.black),
                //                                                         )
                //                                                       ],
                //                                                     ),
                //                                                     SizedBox(
                //                                                       width:
                //                                                           3.w,
                //                                                     ),
                //                                                     Container(
                //                                                       height:
                //                                                           2.5.h,
                //                                                       width:
                //                                                           .5.w,
                //                                                       color: Colors
                //                                                           .grey,
                //                                                     ),
                //                                                     SizedBox(
                //                                                       width:
                //                                                           3.w,
                //                                                     ),
                //                                                     Column(
                //                                                       crossAxisAlignment:
                //                                                           CrossAxisAlignment
                //                                                               .start,
                //                                                       children: [
                //                                                         Text(
                //                                                           "Corbohidreate",
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: Colors.grey),
                //                                                         ),
                //                                                         Text(
                //                                                           "40 gm",
                //                                                           // "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",

                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: indexs % 2 == 0 ? Colors.white : Colors.black),
                //                                                         )
                //                                                       ],
                //                                                     ),
                //                                                     SizedBox(
                //                                                       width:
                //                                                           3.w,
                //                                                     ),
                //                                                     Container(
                //                                                       height:
                //                                                           2.5.h,
                //                                                       width:
                //                                                           .5.w,
                //                                                       color: Colors
                //                                                           .grey,
                //                                                     ),
                //                                                     SizedBox(
                //                                                       width:
                //                                                           3.w,
                //                                                     ),
                //                                                     Column(
                //                                                       crossAxisAlignment:
                //                                                           CrossAxisAlignment
                //                                                               .start,
                //                                                       children: [
                //                                                         Text(
                //                                                           "Fett",
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: Colors.grey),
                //                                                         ),
                //                                                         Text(
                //                                                           "80 gm",
                //                                                           //  "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",
                //                                                           style: Style_File.title.copyWith(
                //                                                               fontSize: 14.sp,
                //                                                               color: indexs % 2 == 0 ? Colors.white : Colors.black),
                //                                                         )
                //                                                       ],
                //                                                     ),
                //                                                   ],
                //                                                 ),

                //                                                 // Row(
                //                                                 //   children: [
                //                                                 //     Column(
                //                                                 //       children: [
                //                                                 //         Text(
                //                                                 //           "Serving",
                //                                                 //           style: Style_File.title.copyWith(
                //                                                 //               fontSize: 14.sp,
                //                                                 //               color: Colors.grey),
                //                                                 //         ),
                //                                                 //         Text(
                //                                                 //           planfoodprovider
                //                                                 //               .finalcalenderList[index]
                //                                                 //               .calendarrecipes![indexs]
                //                                                 //               .recipes![0]
                //                                                 //               .serving!
                //                                                 //               .toString(),
                //                                                 //           style: Style_File.title.copyWith(
                //                                                 //               fontSize: 14.sp,
                //                                                 //               color: indexs % 2 == 0 ? Colors.white : Colors.black),
                //                                                 //         )
                //                                                 //       ],
                //                                                 //     ),
                //                                                 //     SizedBox(
                //                                                 //       width:
                //                                                 //           8.w,
                //                                                 //     ),
                //                                                 //     Container(
                //                                                 //       height:
                //                                                 //           2.5.h,
                //                                                 //       width:
                //                                                 //           .5.w,
                //                                                 //       color: Colors
                //                                                 //           .grey,
                //                                                 //     ),
                //                                                 //     SizedBox(
                //                                                 //       width:
                //                                                 //           8.w,
                //                                                 //     ),
                //                                                 //     Column(
                //                                                 //       crossAxisAlignment:
                //                                                 //           CrossAxisAlignment
                //                                                 //               .start,
                //                                                 //       children: [
                //                                                 //         Text(
                //                                                 //           "Cook Time",
                //                                                 //           style: Style_File.title.copyWith(
                //                                                 //               fontSize: 14.sp,
                //                                                 //               color: Colors.grey),
                //                                                 //         ),
                //                                                 //         Text(
                //                                                 //           "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",
                //                                                 //           style: Style_File.title.copyWith(
                //                                                 //               fontSize: 14.sp,
                //                                                 //               color: indexs % 2 == 0 ? Colors.white : Colors.black),
                //                                                 //         )
                //                                                 //       ],
                //                                                 //     ),
                //                                                 //     SizedBox(
                //                                                 //       width:
                //                                                 //           8.w,
                //                                                 //     ),
                //                                                 //   ],
                //                                                 // ),
                //                                               ],
                //                                             ),
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       );
                //                     }),
                //                 Center(
                //                   child: Text(
                //                     "82 g Kolhydrater . 17 g Fett. 52 g  Protein",
                //                     style: Style_File.title
                //                         .copyWith(color: Colors.grey),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           );
                //         }),
                //   ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Radera'),
          content: const Text(
              "Är du säker på att du vill ta bort måltiden ur matplanen"),
          //  'Are you sure you want to delete food plan ingredients.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nej'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ja'),
              onPressed: () {
                delete(id);
              },
            ),
          ],
        );
      },
    );
  }
}
