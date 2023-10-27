import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_file.dart';
import '../../../utils/style_file.dart';
import '../../page_routes/routes.dart';

class StackUI extends StatefulWidget {
  // final String? image;
  // final String? text;
  const StackUI({
    Key? key,
    // this.image,
    // this.text,
  }) : super(key: key);

  @override
  State<StackUI> createState() => _StackUIState();
}

class BottomList {
  BottomList(
    this.image,
    this.title,
  );

  final String image;
  final String title;
}

class _StackUIState extends State<StackUI> {
  final List<BottomList> bottomlist = [
    BottomList(
      'alo.png',
      "POTATO",
    ),
    BottomList(
      'pista.png',
      "PISTA",
    ),
    BottomList(
      'seafood.png',
      "RICE",
    ),
    BottomList(
      'sauses.png',
      "BULGUR",
    ),
    BottomList(
      'seafood.png',
      "PISTA",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.0),
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              //Navigator.pushNamed(context, Routes.dinnerScreen);
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 16.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: colorSecondry,
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0.h),
                              child: Text(bottomlist[index].title,
                                  style: Style_File.title.copyWith(
                                      color: colorWhite, fontSize: 18.sp)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -10.h,
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(10.0.h),
                      //   child: Image.asset(
                      //     "assets/images/" + bottomlist[index].image1,
                      //     height: 18.h,
                      //   ),
                      // ),

                      child: Stack(
                          //clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              children: [
                                Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          ImageFile.plat,
                                          height: 24.h,
                                        ),
                                        decoration: BoxDecoration(
                                          //color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            height: 9.h,
                                            "assets/images/" +
                                                bottomlist[index].image,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),

                // Stack(
                //   clipBehavior: Clip.none,
                //   alignment: Alignment.topCenter,
                //   children: [
                //     Column(
                //       children: [
                //         Container(
                //           height: 20.h,
                //           width: 45.w,
                //           decoration: BoxDecoration(
                //             color: colorSecondry,
                //             borderRadius: BorderRadius.circular(2.w),
                //           ),
                //
                //           child: Center(
                //             child: Padding(
                //               padding:  EdgeInsets.only(top: 12.0.h),
                //               child: Text(
                //                   bottomlist[index].title ?? '',
                //                   style: Style_File.title.copyWith(color: colorWhite, fontSize: 20.sp)),
                //             ),
                //           ),
                //
                //         ),
                //
                //       ],
                //     ),
                //     Positioned(
                //       top: -8.h,
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(10.0.h),
                //         child: Image.asset(
                //           "assets/images/" + bottomlist[index].image,
                //           height: 18.h,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),

            // child: Stack(
            //     alignment: Alignment.bottomCenter,
            //     children: [
            //       Image.asset(
            //         "assets/images/" + bottomlist[index].image,
            //       ),
            //
            //       Container(
            //         decoration: BoxDecoration(
            //             color: colorGrey.withOpacity(0.5),
            //             borderRadius:  BorderRadius.circular(2.h)),
            //         child: Center(
            //           child: Padding(
            //             padding:  EdgeInsets.only(top: 12.h),
            //             child: Text(bottomlist[index].title ?? '',
            //                 style: Style_File.title.copyWith(color: colorWhite, fontSize: 20.sp)),
            //           ),
            //         ),
            //       )
            //     ])
          );
        },
        itemCount: bottomlist.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
