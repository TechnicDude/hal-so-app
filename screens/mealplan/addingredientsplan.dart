import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/myaddingredientsprovider.dart';
import 'package:halsogourmet/screens/mealplan/addingredientscalander.dart';
import 'package:halsogourmet/screens/myrefrigerator/addingredients.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddinGredientsplan extends StatefulWidget {
  const AddinGredientsplan({super.key});

  @override
  State<AddinGredientsplan> createState() => _AddinGredientsplanState();
}

class _AddinGredientsplanState extends State<AddinGredientsplan> {
  bool adddatashow = false;
  String searchString = "";
  bool searchshow = false;
  MyaddingredientsProvider myaddingredientsProvider =
      MyaddingredientsProvider();
  TextEditingController sercheditcontroler = new TextEditingController();
  int ingredientindex = 0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    myaddingredientsProvider =
        Provider.of<MyaddingredientsProvider>(context, listen: false);

    fetchdata();
    super.initState();
  }

  fetchdata() async {
    await myaddingredientsProvider.ingradientslist();
    await myaddingredientsProvider.calendarfoodtypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarScreens(
            text: "Lägg till ingredienser",

            // "Add Ingredients",
          )),
      body: Consumer<MyaddingredientsProvider>(
          builder: (context, myaddingredientsProvider, child) {
        if (myaddingredientsProvider.datanotfound) {
          if (myaddingredientsProvider.ingradientsModellist.isNotEmpty) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: colorGrey),
                              borderRadius: BorderRadius.circular(4.h)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: TextField(
                                controller: sercheditcontroler,
                                onChanged: ((value) {
                                  setState(() {
                                    searchString = sercheditcontroler.text;
                                    if (sercheditcontroler.text.isNotEmpty) {
                                      searchshow = true;
                                    } else {
                                      searchshow = false;
                                    }
                                  });
                                }),
                                decoration: InputDecoration(
                                    isDense: true,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: colorGrey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          searchshow = false;
                                          sercheditcontroler.clear();
                                          searchString = '';
                                        });
                                      },
                                    ),
                                    hintText: 'Sök...',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Amazon',
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ListView.builder(
                            itemCount: myaddingredientsProvider
                                .ingradientsModellist.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return (myaddingredientsProvider
                                      .ingradientsModellist[index].title!
                                      .toLowerCase()
                                      .contains(searchString.toLowerCase()))
                                  ? Padding(
                                      padding: EdgeInsets.all(1.h),

                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            adddatashow = true;
                                            ingredientindex = index;
                                          });
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
                                                  bottomLeft:
                                                      Radius.circular(8.w),
                                                  bottomRight:
                                                      Radius.circular(4.w),
                                                  topRight:
                                                      Radius.circular(4.w))),
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
                                                      shape: BoxShape.circle,
                                                      color: colorGrey,
                                                      image: DecorationImage(
                                                          image: (myaddingredientsProvider
                                                                      .ingradientsModellist[
                                                                          index]
                                                                      .image!
                                                                      .isEmpty ||
                                                                  myaddingredientsProvider
                                                                      .ingradientsModellist[
                                                                          index]
                                                                      .image!
                                                                      .isEmpty)
                                                              ? AssetImage(
                                                                  ImageFile
                                                                      .logo,
                                                                )
                                                              : NetworkImage(APIURL
                                                                      .imageurl +
                                                                  myaddingredientsProvider
                                                                      .ingradientsModellist[
                                                                          index]
                                                                      .image!
                                                                      .toString()) as ImageProvider,
                                                          fit: BoxFit.fill),
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
                                                    CrossAxisAlignment.center,
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
                                                                    width: 25.w,
                                                                    child: Text(
                                                                        myaddingredientsProvider
                                                                            .ingradientsModellist[
                                                                                index]
                                                                            .title!,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: Style_File.title.copyWith(
                                                                            fontSize: 16
                                                                                .sp,
                                                                            color: index % 2 == 0
                                                                                ? Colors.white
                                                                                : Colors.black)),
                                                                  ),
                                                                  Spacer(),
                                                                  Icon(
                                                                    Icons
                                                                        .local_fire_department_rounded,
                                                                    size: 25,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                        "  ${myaddingredientsProvider.ingradientsModellist[index].calorie!} kcal",
                                                                        style: Style_File.title.copyWith(
                                                                            fontSize: 14
                                                                                .sp,
                                                                            color: index % 2 == 0
                                                                                ? Colors.white
                                                                                : Colors.black)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      "Protein",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    Text(
                                                                      "${myaddingredientsProvider.ingradientsModellist[index].protein!} g",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: index % 2 == 0
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Container(
                                                                  height: 2.5.h,
                                                                  width: .5.w,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Kolhydrater",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    Text(
                                                                      "${myaddingredientsProvider.ingradientsModellist[index].carbohydrate!} g",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: index % 2 == 0
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Container(
                                                                  height: 2.5.h,
                                                                  width: .5.w,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Fett",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    Text(
                                                                      "${myaddingredientsProvider.ingradientsModellist[index].fat!} g",
                                                                      style: Style_File.title.copyWith(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: index % 2 == 0
                                                                              ? Colors.white
                                                                              : Colors.black),
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

                                      //),
                                    )
                                  : Container();
                            }),
                      ],
                    ),
                  ),
                ),
                if (adddatashow)
                  Container(
                    height: 100.h,
                    width: 100.w,
                    color: Colors.transparent,
                    child: Center(
                      child: AddIngredientsCalanderScreenActivity(
                          callback: (value) {
                            setState(() {
                              adddatashow = false;
                            });
                          },
                          ingredientid: myaddingredientsProvider
                              .ingradientsModellist[ingredientindex].id
                              .toString(),
                          ingredientname: myaddingredientsProvider
                              .ingradientsModellist[ingredientindex].title!,
                          foodlist: myaddingredientsProvider.foodtypeList),
                    ),
                  ),
              ],
            );
          } else {
            return NoDataFoundErrorScreens();
          }
        } else {
          return LoaderScreen();
        }
      }),
    );
  }
}
