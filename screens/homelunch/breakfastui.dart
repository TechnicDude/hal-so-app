import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../page_routes/routes.dart';
import '../../utils/colors.dart';
import '../../utils/image_file.dart';
import '../../utils/style_file.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BreakfastUI extends StatefulWidget {
  final List<FoodcategoryData>? foodcategorydata;
  final String type;
  final String searchString;
  BreakfastUI(
      {Key? key,
      required this.foodcategorydata,
      required this.type,
      required this.searchString})
      : super(key: key);

  @override
  State<BreakfastUI> createState() => _BreakfastUIState();
}

class _BreakfastUIState extends State<BreakfastUI> {
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
              (MediaQuery.of(context).size.height / 2.5),
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (widget.foodcategorydata![index].subCategories!.length > 0) {
                Navigator.pushNamed(
                  context,
                  Routes.proteinScreen,
                  arguments: {
                    StringFile.foodtypeId:
                        widget.foodcategorydata![index].id.toString(),
                    StringFile.foodtypeName:
                        widget.foodcategorydata![index].categoryName ?? '',
                    StringFile.bannertypes: StringFile.bannerfoodcategory,
                    StringFile.screenname: StringFile.categoryId
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  Routes.beafScreen,
                  arguments: {
                    StringFile.foodtypeId:
                        widget.foodcategorydata![index].id.toString(),
                    StringFile.foodtypeName:
                        widget.foodcategorydata![index].categoryName ?? '',
                    StringFile.bannertypes: StringFile.bannerfoodcategory,
                    StringFile.screenname: StringFile.categoryId,
                    StringFile.isAnyCategory: true,
                  },
                );
              }
              //  else {
              //   Navigator.pushNamed(
              //     context,
              //     Routes.beafScreen,
              //     arguments: {
              //       StringFile.proteinscreenfood:
              //           widget.foodcategorydata![index].categoryName ?? '',
              //     },
              //   );
              // }
            },

            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    height: 100.h,
                    width: 100.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.h),
                      child: NetWorkImageScreen(
                          image: APIURL.imageurl +
                              (widget.foodcategorydata![index].primaryImage!)),
                    )),
                Container(
                  height: 6.h,
                  // width: 100.h,
                  decoration: BoxDecoration(
                      color: colorSecondry.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(2.h),
                          bottomRight: Radius.circular(2.h))),

                  child: Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            widget.foodcategorydata![index].categoryName!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Style_File.title
                                .copyWith(color: colorWhite, fontSize: 20.sp)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // child: Stack(alignment: Alignment.bottomCenter, children: [
            //   // Image.asset(
            //   //   "assets/images/" + bottomlist[index].image,
            //   // ),

            //   Container(
            //       height: 100.h,
            //       width: 100.h,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(2.h),

            //         child: NetWorkImageScreen(
            //             image: APIURL.imageurl +
            //                 (widget.foodcategorydata![index].primaryImage!)),

            //         //  Image.network(
            //         //   APIURL.imageurl +
            //         //       (widget.foodcategorydata![index].primaryImage!),
            //         //   fit: BoxFit.fill,
            //         // ),

            //         // child: Image.asset(
            //         //   "assets/images/" + bottomlist[index].image,
            //         //   fit: BoxFit.fill,
            //         // ),
            //       )),

            //   Container(
            //     alignment: Alignment.bottomCenter,
            //     padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.h),
            //     decoration: BoxDecoration(
            //         color: colorGrey.withOpacity(0.1),
            //         // color: colorGrey.withOpacity(0.5),
            //         borderRadius: BorderRadius.circular(2.h)),
            //     child: Text(widget.foodcategorydata![index].categoryName!,
            //         textAlign: TextAlign.center,
            //         //bottomlist[index].title,
            //         style: Style_File.title
            //             .copyWith(color: colorWhite, fontSize: 20.sp)),
            //   )
            // ])
          );
        },
        itemCount: widget.foodcategorydata!.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
