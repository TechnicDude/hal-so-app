import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/subsubcategorymodel.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_file.dart';
import '../../../utils/style_file.dart';

class MeatUI extends StatefulWidget {
  final List<SubsubcategoryData>? subsubcategorydata;
  final String type;
  final String searchString;
  MeatUI(
      {Key? key,
      required this.subsubcategorydata,
      required this.type,
      required this.searchString})
      : super(key: key);

 

  @override
  State<MeatUI> createState() => _MeatUIState();
}

class _MeatUIState extends State<MeatUI> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h, right: 2.h),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.beafScreen,
                arguments: {
                  StringFile.foodtypeId:
                      widget.subsubcategorydata![index].id.toString(),
                  StringFile.foodtypeName:
                      widget.subsubcategorydata![index].subSubCategoryName ??
                          '',
                  StringFile.bannertypes: StringFile.bannersubsubcategory,
                  StringFile.screenname: StringFile.subsubCategoryId,
                  StringFile.isAnyCategory: true,
                },
              );
            },
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.subsubcategorydata![index].subSubCategoryName!,
                        // widget.subsubcategorydata.subSubCategoryName!,
                        //bottomlist[index].title,
                        style: Style_File.title.copyWith(fontSize: 18.sp)),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  height: 22.h,
                  width: 100.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.h),

                    // child: Image.asset(
                    //   "assets/images/meat1.jpg",
                    //   //  "assets/images/" + bottomlist[index].image,
                    //   fit: BoxFit.fill,
                    // ),
                    child:
                        widget.subsubcategorydata![index].primaryImage != null
                            ?
                            // Image.network(
                            //     height: 8.h,
                            //     APIURL.imageurl +
                            //         (widget.subsubcategorydata![index]
                            //             .primaryImage!),
                            //     fit: BoxFit.fill,
                            //   )

                            NetWorkImageScreen(
                                height: 8.h,
                                image: APIURL.imageurl +
                                    (widget.subsubcategorydata![index]
                                        .primaryImage!),
                              )
                            : Container(),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: widget.subsubcategorydata!.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
