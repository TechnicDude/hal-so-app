import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/relatedrecipemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_file.dart';
import '../../../utils/style_file.dart';

class RecentRecipe extends StatefulWidget {
  final List<RelatedRecipeData>? relatedrecipedata;
  final String type;
  final String searchString;
  final Function? callback;

  const RecentRecipe(
      {Key? key,
      required this.relatedrecipedata,
      required this.type,
      this.callback,
      required this.searchString})
      : super(key: key);

  @override
  State<RecentRecipe> createState() => _RecentRecipeState();
}

class BottomList {
  BottomList(
    this.image,
    this.title,
  );

  final String image;
  final String title;
}

class _RecentRecipeState extends State<RecentRecipe> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                  height: 30.h,
                  width: 100.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.relatedrecipedata!.length,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (widget.relatedrecipedata![index].premium
                                  .toString()
                                  .toLowerCase() ==
                              "true") {
                            if (MyApp.subscriptioncheck) {
                              Navigator.pushNamed(
                                context,
                                Routes.foodDetails,
                                arguments: {
                                  StringFile.foodtypeId: widget
                                      .relatedrecipedata![index].id
                                      .toString(),
                                  StringFile.foodtypeName:
                                      widget.relatedrecipedata![index].title ??
                                          ''
                                },
                              );
                            } else {
                              widget.callback!("Premium");
                            }
                          } else {
                            Navigator.pushNamed(
                              context,
                              Routes.foodDetails,
                              arguments: {
                                StringFile.foodtypeId: widget
                                    .relatedrecipedata![index].id
                                    .toString(),
                                StringFile.foodtypeName:
                                    widget.relatedrecipedata![index].title ?? ''
                              },
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30.h,
                              color: Colors.white54,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 2.h, left: 1.2.h, right: 1.2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 15.h,
                                        width: 20.h,
                                        decoration: BoxDecoration(
                                            color: colorGrey,
                                            borderRadius:
                                                BorderRadius.circular(2.h),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colorGrey,
                                                blurRadius: 0.5.h,
                                              ),
                                            ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: NetWorkImageScreen(
                                              height: 5.h,
                                              image: APIURL.imageurl +
                                                  (widget
                                                      .relatedrecipedata![index]
                                                      .recipeimage![0]
                                                      .image!)),
                                        )),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    FittedBox(
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Center(
                                          child: Text(
                                              widget.relatedrecipedata![index]
                                                  .title!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              //widget.relatedrecipedata![0].data!.title!,
                                              //bottomlist[index].title,
                                              style: Style_File.title.copyWith(
                                                  color: colorBlack,
                                                  fontSize: 16.sp)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    // shrinkWrap: true,
                    // itemCount: widget.relatedrecipedata!.length,
                    // scrollDirection: Axis.horizontal,
                  )),
            ],
          );
        });
  }
}
