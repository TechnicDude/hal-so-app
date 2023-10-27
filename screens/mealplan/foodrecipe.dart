import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FoodRecipe extends StatefulWidget {
  const FoodRecipe({super.key});

  @override
  State<FoodRecipe> createState() => _FoodRecipeState();
}

class _FoodRecipeState extends State<FoodRecipe> {
  Color _colorContainer = Color(0xFF9ab6ed);

  double _containerHeight = double.infinity;
  Color _containerColor = Colors.blue;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorBlack,
        ),
        backgroundColor: colorWhite,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Mat Recept for You",
                  style: Style_File.title
                      .copyWith(color: colorBlack, fontSize: 18.sp),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),

              Container(
                height: 90.h,
                child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _colorContainer =
                                      _colorContainer == Color(0xFF9ab6ed)
                                          ? Colors.red
                                          : Color(0xFF9ab6ed);
                                });
                              },
                              child: Container(
                                height: 20.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? Colors.redAccent[400]
                                      : index == 1
                                          ? Colors.amber[300]
                                          : Colors.blue[600],
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, Routes.planScreen);
                                            },
                                            child: Container(
                                              height: 5.h,
                                              width: 13.h,
                                              decoration: BoxDecoration(
                                                  color: colorSecondry,
                                                  border: Border.all(
                                                      color: colorGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.h)),
                                              child: Center(
                                                  child: Text(
                                                'Måltid Planner',
                                                style: Style_File.subtitle
                                                    .copyWith(
                                                        color: colorWhite),
                                              )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  Routes.ingredientListScreens);
                                            },
                                            child: Container(
                                              height: 5.h,
                                              width: 13.h,
                                              decoration: BoxDecoration(
                                                  color: colorSecondry,
                                                  border: Border.all(
                                                      color: colorGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.h)),
                                              child: Center(
                                                  child: Text(
                                                'Ingredient List',
                                                style: Style_File.subtitle
                                                    .copyWith(
                                                        color: colorWhite),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Routes.planScreen);
                                        },
                                        child: Text(
                                          'All Recept Plan',
                                          style: Style_File.title
                                              .copyWith(color: colorWhite),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: 2.h,
              ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       _colorContainer = _colorContainer == Colors.red
              //           ? Colors.blue
              //           : Colors.red;
              //     });
              //   },
              //   child: Container(
              //       //  color: colorSecondry,
              //       height: 20.h,
              //       // width: 50.h,
              //       child: ListView.builder(
              //           itemCount: 1,
              //           shrinkWrap: true,
              //           scrollDirection: Axis.vertical,
              //           itemBuilder: (context, index) {
              //             //     // gradient: LinearGradient(
              //             //     //   begin: Alignment.topCenter,
              //             //     //   end: Alignment.bottomCenter,
              //             //     //   colors: [Color(0xFF86e3ce), Color(0xFF9862ca)],
              //             //     // )
              //             //     );
              //             return Container(
              //               color: colorSecondry,
              //               child: Padding(
              //                 padding: EdgeInsets.all(2.h),
              //                 child: Column(
              //                   children: [
              //                     // InkWell(
              //                     //   onTap: () {
              //                     //     Navigator.pushNamed(
              //                     //         context, Routes.planScreen);
              //                     //   },
              //                     //   child: Container(
              //                     //     height: 5.h,
              //                     //     width: 44.h,
              //                     //     decoration: BoxDecoration(
              //                     //         color: colorSecondry,
              //                     //         //  border: Border.all(color: colorSecondry),
              //                     //         borderRadius: BorderRadius.circular(2.h)),
              //                     //     child: Center(
              //                     //         child: Text(
              //                     //       'Week',
              //                     //       style: Style_File.title
              //                     //           .copyWith(color: colorWhite),
              //                     //     )),
              //                     //   ),
              //                     // ),
              //                     SizedBox(
              //                       height: 3.h,
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       children: [
              //                         InkWell(
              //                           onTap: () {
              //                             Navigator.pushNamed(
              //                                 context, Routes.planScreen);
              //                           },
              //                           child: Container(
              //                             height: 5.h,
              //                             width: 10.h,
              //                             decoration: BoxDecoration(
              //                                 border:
              //                                     Border.all(color: colorWhite),
              //                                 borderRadius:
              //                                     BorderRadius.circular(2.h)),
              //                             child: Center(
              //                                 child: Text(
              //                               'All Recipe Plan',
              //                               style: Style_File.subtitle
              //                                   .copyWith(color: colorWhite),
              //                             )),
              //                           ),
              //                         ),
              //                         InkWell(
              //                           onTap: () {
              //                             Navigator.pushNamed(
              //                                 context, Routes.planScreen);
              //                           },
              //                           child: Container(
              //                             height: 5.h,
              //                             width: 10.h,
              //                             decoration: BoxDecoration(
              //                                 border:
              //                                     Border.all(color: colorWhite),
              //                                 borderRadius:
              //                                     BorderRadius.circular(2.h)),
              //                             child: Center(
              //                                 child: Text(
              //                               'Ingredient',
              //                               style: Style_File.subtitle
              //                                   .copyWith(color: colorWhite),
              //                             )),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: 2.h,
              //                     ),
              //                     Text(
              //                       'Recipe',
              //                       style: Style_File.title
              //                           .copyWith(color: colorWhite),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           })),
              // ),

              SizedBox(
                height: 4.h,
              ),

              // Container(
              //   height: 20.h,
              //   width: 50.h,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(2.h),
              //       color: Color(0xFF1d64ac)

              //       // color: Color.fromARGB(255, 158, 236, 218),
              //       // gradient: LinearGradient(
              //       //   begin: Alignment.topCenter,
              //       //   end: Alignment.bottomCenter,
              //       //   colors: [Color(0xFF86e3ce), Color(0xFF9862ca)],
              //       // )
              //       ),
              //   child: Column(
              //     children: [
              //       Container(),
              //       SizedBox(
              //         height: 3.h,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           // Navigator.pushNamed(context, Route.bottomNav);
              //         },
              //         child: Container(
              //           height: 5.h,
              //           width: 44.h,
              //           decoration: BoxDecoration(
              //               color: colorSecondry,
              //               //  border: Border.all(color: colorSecondry),
              //               borderRadius: BorderRadius.circular(2.h)),
              //           child: Center(
              //               child: Text(
              //             'Second Week',
              //             style: Style_File.title.copyWith(color: colorWhite),
              //           )),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 3.h,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           InkWell(
              //             onTap: () {
              //               // Navigator.pushNamed(context, Route.bottomNav);
              //             },
              //             child: Container(
              //               height: 5.h,
              //               width: 20.h,
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: colorSecondry),
              //                   borderRadius: BorderRadius.circular(2.h)),
              //               child: Center(
              //                   child: Text(
              //                 'Item to Buy',
              //                 style: Style_File.subtitle
              //                     .copyWith(color: colorWhite),
              //               )),
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () {
              //               // Navigator.pushNamed(context, Route.bottomNav);
              //             },
              //             child: Container(
              //               height: 5.h,
              //               width: 20.h,
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: colorSecondry),
              //                   borderRadius: BorderRadius.circular(2.h)),
              //               child: Center(
              //                   child: Text(
              //                 'Ingredient',
              //                 style: Style_File.subtitle
              //                     .copyWith(color: colorWhite),
              //               )),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(
              //   height: 4.h,
              // ),

              // Container(
              //   height: 20.h,
              //   width: 50.h,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(2.h),
              //       color: Color(0xFF1d64ac)

              //       // gradient: LinearGradient(
              //       //   begin: Alignment.topCenter,
              //       //   end: Alignment.bottomCenter,
              //       //   colors: [Color(0xFF86e3ce), Color(0xFF9862ca)],
              //       // )
              //       ),
              //   child: Column(
              //     children: [
              //       Container(),
              //       SizedBox(
              //         height: 3.h,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           // Navigator.pushNamed(context, Route.bottomNav);
              //         },
              //         child: Container(
              //           height: 5.h,
              //           width: 44.h,
              //           decoration: BoxDecoration(
              //               color: colorSecondry,
              //               //  border: Border.all(color: colorSecondry),
              //               borderRadius: BorderRadius.circular(2.h)),
              //           child: Center(
              //               child: Text(
              //             'Third Week',
              //             style: Style_File.title.copyWith(color: colorWhite),
              //           )),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 3.h,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           InkWell(
              //             onTap: () {
              //               // Navigator.pushNamed(context, Route.bottomNav);
              //             },
              //             child: Container(
              //               height: 5.h,
              //               width: 20.h,
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: colorSecondry),
              //                   borderRadius: BorderRadius.circular(2.h)),
              //               child: Center(
              //                   child: Text(
              //                 'Item to Buy',
              //                 style: Style_File.subtitle
              //                     .copyWith(color: colorWhite),
              //               )),
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () {
              //               // Navigator.pushNamed(context, Route.bottomNav);
              //             },
              //             child: Container(
              //               height: 5.h,
              //               width: 20.h,
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: colorSecondry),
              //                   borderRadius: BorderRadius.circular(2.h)),
              //               child: Center(
              //                   child: Text(
              //                 'Ingredient',
              //                 style: Style_File.subtitle
              //                     .copyWith(color: colorWhite),
              //               )),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              // InkWell(
              //   onTap: () {
              //     // Navigator.pushNamed(context, Route.bottomNav);
              //   },
              //   child: Container(
              //     height: 5.h,
              //     width: 50.h,
              //     decoration: BoxDecoration(
              //         color: colorSecondry,
              //         //  border: Border.all(color: colorSecondry),
              //         borderRadius: BorderRadius.circular(2.h)),
              //     child: Center(
              //         child: Text(
              //       'One Week',
              //       style: Style_File.title.copyWith(color: colorWhite),
              //     )),
              //   ),
              // ),
              // SizedBox(
              //   height: 3.h,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child:
              //                 Text('Food Title', style: Style_File.subtitle)),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child: Text('Gredient', style: Style_File.subtitle)),
              //       ),
              //     ),
              //   ],
              // ),

              // SizedBox(
              //   height: 7.h,
              // ),
              // InkWell(
              //   onTap: () {
              //     // Navigator.pushNamed(context, Route.bottomNav);
              //   },
              //   child: Container(
              //     height: 5.h,
              //     width: 50.h,
              //     decoration: BoxDecoration(
              //         color: colorSecondry,
              //         //  border: Border.all(color: colorSecondry),
              //         borderRadius: BorderRadius.circular(2.h)),
              //     child: Center(
              //         child: Text(
              //       'Second Week',
              //       style: Style_File.title.copyWith(color: colorWhite),
              //     )),
              //   ),
              // ),
              // SizedBox(
              //   height: 3.h,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child:
              //                 Text('Food Title', style: Style_File.subtitle)),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child: Text('Gredient', style: Style_File.subtitle)),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 7.h,
              // ),
              // InkWell(
              //   onTap: () {
              //     // Navigator.pushNamed(context, Route.bottomNav);
              //   },
              //   child: Container(
              //     height: 5.h,
              //     width: 50.h,
              //     decoration: BoxDecoration(
              //         color: colorSecondry,
              //         //  border: Border.all(color: colorSecondry),
              //         borderRadius: BorderRadius.circular(2.h)),
              //     child: Center(
              //         child: Text(
              //       'Third Week',
              //       style: Style_File.title.copyWith(color: colorWhite),
              //     )),
              //   ),
              // ),
              // SizedBox(
              //   height: 3.h,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child:
              //                 Text('Food Title', style: Style_File.subtitle)),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         // Navigator.pushNamed(context, Route.bottomNav);
              //       },
              //       child: Container(
              //         height: 5.h,
              //         width: 20.h,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: colorSecondry),
              //             borderRadius: BorderRadius.circular(2.h)),
              //         child: Center(
              //             child: Text('Gredient', style: Style_File.subtitle)),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
