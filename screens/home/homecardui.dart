import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../page_routes/routes.dart';
import '../../utils/colors.dart';
import '../../utils/image_file.dart';
import '../../utils/style_file.dart';

class CardUI extends StatelessWidget {
  final List<FoodtypeData>? foodtypedata;
  final String type;
  final String searchString;
  CardUI(
      {Key? key,
      required this.foodtypedata,
      required this.type,
      required this.searchString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.2),
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (!foodtypedata![index].isAnyCategory!) {
                Navigator.pushNamed(
                  context,
                  Routes.beafScreen,
                  arguments: {
                    StringFile.foodtypeId: foodtypedata![index].id.toString(),
                    StringFile.foodtypeName:
                        foodtypedata![index].foodType ?? '',
                    StringFile.isAnyCategory:
                        foodtypedata![index].isAnyCategory,
                    StringFile.bannertypes: StringFile.bannerfoodtype,
                    StringFile.screenname: StringFile.bannerfoodtype,
                  },
                ).then((value) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                });
              } else {
                Navigator.pushNamed(
                  context,
                  Routes.caloriesScreen,
                  arguments: {
                    StringFile.foodtypeId: foodtypedata![index].id.toString(),
                    StringFile.foodtypeName: foodtypedata![index].foodType ?? ''
                  },
                ).then((value) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                });
              }
            },

            // onTap: () {
            //   if (type == "foodtype") {
            //     Navigator.pushNamed(
            //       context,
            //       Routes.breakfastScreen,
            //       arguments: {
            //         StringFile.foodtypeId: foodtypedata![index].id.toString(),
            //         StringFile.foodtypeName:
            //             foodtypedata![index].foodType ?? ''
            //       },
            //     );
            //   } else {
            //     Navigator.pushNamed(
            //       context,
            //       Routes.proteinScreen,
            //       arguments: {
            //         StringFile.proteinscreenfood:
            //             foodtypedata![index].foodType ?? '',
            //       },
            //     );
            //   }

            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    height: 100.h,
                    width: 100.h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.h),
                        child: NetWorkImageScreen(
                          height: 2.h,
                          image: APIURL.imageurl +
                              (foodtypedata![index].primaryImage!),
                        ))),
                Container(
                  height: 5.h,
                  // width: 100.h,
                  decoration: BoxDecoration(
                      color: colorSecondry.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(2.h),
                          bottomRight: Radius.circular(2.h))),

                  child: Center(
                    child: Text(foodtypedata![index].foodType!,
                        style: Style_File.title
                            .copyWith(color: colorWhite, fontSize: 20.sp)),
                  ),
                ),
              ],
            ),

            // child: Stack(alignment: Alignment.center, children: [
            //   Container(
            //       height: 100.h,
            //       width: 100.h,
            //       child: ClipRRect(
            //           borderRadius: BorderRadius.circular(2.h),
            //           // child: Image.asset(
            //           //   "assets/images/" + bottomlist[index].image,
            //           //   fit: BoxFit.fill,
            //           // ),
            //           // child: Image.network(
            //           //   APIURL.imageurl + (foodtypedata![index].primaryImage!),
            //           //   // .replaceAll("public/", ""),
            //           //   fit: BoxFit.fill,
            //           // ),
            //           child: NetWorkImageScreen(
            //             height: 2.h,
            //             image: APIURL.imageurl +
            //                 (foodtypedata![index].primaryImage!),
            //           ))),
            //   Container(
            //     decoration: BoxDecoration(
            //         color: colorGrey.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(2.h)),
            //     child: Center(
            //       child: Padding(
            //         padding: EdgeInsets.only(top: 14.h),
            //         child: Text(foodtypedata![index].foodType!,
            //             style: Style_File.title
            //                 .copyWith(color: colorWhite, fontSize: 20.sp)),
            //       ),
            //     ),
            //   )
            // ])
          );
        },
        itemCount: foodtypedata!.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
