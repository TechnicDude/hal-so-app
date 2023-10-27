import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/model/weeklyingredientmodel.dart';
import 'package:halsogourmet/screens/home/sliderscreen.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IngredientListScreens extends StatefulWidget {
  final Function? callback;
  final List<WeeklyingredientData>? weeklyingredientList;

  const IngredientListScreens(
      {super.key, this.weeklyingredientList, this.callback});

  @override
  State<IngredientListScreens> createState() => _IngredientListScreensState();
}

class _IngredientListScreensState extends State<IngredientListScreens> {
  Color _color = Colors.red;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  //use red line

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.weeklyingredientList!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w, bottom: 1.h),
          child: GestureDetector(
            onTap: () {
              // for (int i = 0; i < ingredient.length; i++) {
              //   setState(() {
              //     ingredient[i] = false;
              //   });
              // }
              // if (ingredient[index]) {
              //   setState(() {
              //     ingredient[index] = false;
              //   });
              // } else {
              //   setState(() {
              //     ingredient[index] = true;
              //   });
              // }
            },
            child: InkWell(
              onTap: () {
                print(index);
                widget.callback!(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: colorWhite,
                    // color:
                    //     _hasBeenPressed[index] ? Colors.white : Colors.amber,
                    borderRadius: BorderRadius.circular(1.h),
                    boxShadow: [
                      BoxShadow(
                        color: colorGrey,
                        blurRadius: 0.2.h,
                      ),
                    ]),
                height: 8.h,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageFile.filtercloseimage,
                                height: 5.h,
                                width: 5.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              SizedBox(
                                width: 30.w,
                                child: Text(
                                  widget.weeklyingredientList![index]
                                      .ingradientTitle!,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Style_File.subtitle.copyWith(
                                      // color: ingredient[index]
                                      //     ? Colors.red
                                      //     : Colors.black,
                                      fontSize: 15.sp),
                                ),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.weeklyingredientList![index].calculatedAmount!} g",
                                    style: Style_File.title.copyWith(
                                        // color: ingredient[index]
                                        //     ? Colors.red
                                        //     : Colors.black,
                                        fontSize: 16.sp),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            ImageFile.filtercloseimage,
                                            height: 3.h,
                                            width: 3.h,
                                          ),
                                          // Icon(
                                          //   Icons.kitchen,
                                          //   size: 15,
                                          //   color: colorGrey,
                                          //   // color: ingredient[index]
                                          //   //     ? Colors.green
                                          //   //     : Colors.grey,
                                          // ),
                                          Text(
                                            "${widget.weeklyingredientList![index].ingradientAmount!.toString()} g",
                                            style: Style_File.subtitle.copyWith(
                                                color: colorBlack,
                                                // color: ingredient[index]
                                                //     ? Colors.green
                                                //     : Colors.black,
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            ImageFile.filterimage,
                                            height: 3.h,
                                            width: 3.h,
                                          ),
                                          Text(
                                            "${widget.weeklyingredientList![index].refrigeratorAmount!.toString()} g",
                                            style: Style_File.subtitle.copyWith(
                                                // color: ingredient[index]
                                                //     ? Colors.red
                                                //     : Colors.black,
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.weeklyingredientList![index].calculatedAmount
                                .toString() ==
                            '0'
                        ? Center(
                            child: Divider(
                              color: Colors.red,
                              thickness: 2,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // bottomNavigationBar: Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20),
    //   child: Container(
    //     width: 90.w,
    //     height: 10.h,
    //     decoration: BoxDecoration(
    //         color: colorSecondry, borderRadius: BorderRadius.circular(2.w)),
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             "Total ",
    //             style: TextStyle(color: colorWhite),
    //           ),
    //           Text(
    //             "\$ 100 ",
    //             style: TextStyle(color: colorWhite),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
