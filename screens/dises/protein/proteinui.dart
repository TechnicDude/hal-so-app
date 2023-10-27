import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/subcategorymodel.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_file.dart';
import '../../../utils/style_file.dart';

class ProteinUI extends StatefulWidget {
  final List<SubcategoryData>? subcategorydata;
  final String type;
  final String searchString;
  ProteinUI(
      {Key? key,
      required this.subcategorydata,
      required this.type,
      required this.searchString})
      : super(key: key);



  @override
  State<ProteinUI> createState() => _ProteinUIState();
}

class _ProteinUIState extends State<ProteinUI> {
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
              (MediaQuery.of(context).size.height / 1.9),
        ),
        itemCount: widget.subcategorydata!.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (widget.subcategorydata![index].subSubCategories!.length !=
                  0) {
                Navigator.pushNamed(
                  context,
                  Routes.meatScreen,
                  arguments: {
                    StringFile.foodtypeId:
                        widget.subcategorydata![index].id.toString(),
                    StringFile.foodtypeName:
                        widget.subcategorydata![index].subCategoryName ?? ''
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  Routes.beafScreen,
                  arguments: {
                    StringFile.foodtypeId:
                        widget.subcategorydata![index].id.toString(),
                    StringFile.foodtypeName:
                        widget.subcategorydata![index].subCategoryName ?? '',
                    StringFile.bannertypes: StringFile.bannersubcategory,
                    StringFile.screenname: StringFile.subCategoryId,
                    StringFile.isAnyCategory: true,
                  },
                );
              }

              // Navigator.pushNamed(context, Routes.meatScreen);
            },
            child: Container(
                height: 15.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                 
                  children: [
                    Container(
                        height: 18.h,
                        width: 100.w,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                            color: colorSecondry,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          widget.subcategorydata![index].subCategoryName!,
                          style: Style_File.title
                              .copyWith(color: colorWhite, fontSize: 18.sp),
                        )),
                    Positioned(
                      top: -20,
                      child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                ImageFile.plat,
                                height: 20.h,
                              ),
                              decoration: BoxDecoration(
                                //color: Colors.amber,
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 9.h,
                                width: 9.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        APIURL.imageurl +
                                            (widget.subcategorydata![index]
                                                .primaryImage!)),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                )),
            // child: Stack(
            //   clipBehavior: Clip.none,
            //   alignment: Alignment.bottomCenter,
            //   children: [
            //     Stack(
            //       clipBehavior: Clip.none,
            //       alignment: Alignment.topCenter,
            //       children: [
            //         Column(
            //           children: [
            //             Container(
            //               height: 16.h,
            //               width: 45.w,
            //               decoration: BoxDecoration(
            //                 color: colorSecondry,
            //                 borderRadius: BorderRadius.circular(2.w),
            //               ),
            //               child: Center(
            //                 child: Padding(
            //                   padding: EdgeInsets.only(top: 10.0.h),
            //                   child: Text(
            //                       widget
            //                           .subcategorydata![index].subCategoryName!,
            //                       //bottomlist[index].title,
            //                       style: Style_File.title.copyWith(
            //                           color: colorWhite, fontSize: 18.sp)),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),

            //       ],
            //     ),
            //   ],
            // ),

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
      ),
    );
  }
}
