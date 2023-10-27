import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/screens/splash.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/colors.dart';
import '../../utils/style_file.dart';

class FoodSliderScreen extends StatefulWidget {
  final List<RecipeData>? bannerdata;
  final Function? callback;

  const FoodSliderScreen({
    Key? key,
    this.bannerdata,
    this.callback,
  }) : super(key: key);

  @override
  State<FoodSliderScreen> createState() => _FoodSliderScreenState();
}

class _FoodSliderScreenState extends State<FoodSliderScreen> {
  bool showsendQuery = false;

  // final Function? oncallback;
  bool isPressed = false;
  bool isPressedLike = false;
  String searchdata = '';
  bool searchbarclose = true;
  DateTime currentDate = DateTime.now();
  TextEditingController _dobController = new TextEditingController();
  String datecont = '';

  // LIKE

  Future _isPressedLike(
      String like, String recipeid, int index, String likeid) async {
    if (like == "1") {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.dislike(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          widget.bannerdata![index].isLike = "0";
        });
      }
      DialogHelper.showFlutterToast(strMsg: "Som att ta bort framgångsrikt");
    } else {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.like(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          widget.bannerdata![index].isLike = "1";
        });

        DialogHelper.showFlutterToast(strMsg: "Gilla tillagd framgångsrikt");
      }
    }
  }

// FAVORITE
  Future _pressed(
      String favorite, String recipeid, int index, String favoriteid) async {
    if (favorite == "1") {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.disfav(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          widget.bannerdata![index].isFavorite = "0";
        });
      }
      DialogHelper.showFlutterToast(strMsg: "Favoriter remove successfully");
    } else {
      LikeApi _likeapi = new LikeApi();
      final response = await _likeapi.fevalbum(recipeid);

      if (response['status'] == 'success') {
        setState(() {
          widget.bannerdata![index].isFavorite = "1";
        });

        DialogHelper.showFlutterToast(strMsg: "Favoriter added successfully");
      }
    }
  }

  @override
  void initState() {
    // super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        datecont = DateFormat("dd-MM-yyyy").format(pickedDate).toString();
      });
    }

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("start", pickedDate.toString());
    // var date = pickedDate.toString();
    // starttitledate = date.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            if (widget.bannerdata!.isNotEmpty)
              CarouselSlider.builder(
                itemCount: widget.bannerdata![0].recipeimage!.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return InkWell(
                    onTap: () {},
                    child: CachedNetworkImage(
                      imageUrl: APIURL.imageurl +
                          widget.bannerdata![0].recipeimage![itemIndex].image!,
                      //bannerdata![itemIndex].i!,
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => LoaderScreen(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
              ),
            if (widget.bannerdata!.isNotEmpty)
              Positioned(
                  top: Platform.isAndroid ? 18.h : 16.h,
                  child: Opacity(
                    opacity: .85,
                    child: Container(
                      height: 15.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: colorSecondry,
                        //withOpacity: 0.1,
                        // elevation: 8,
                        // shadowColor: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: colorGrey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                // FittedBox(
                                //     child: SizedBox(
                                //   width: 80.w,
                                //   child: Text("Delicious Healthy Beef and burrite",
                                //       //  bottomlist[index].title ?? '',
                                //       style: Style_File.title.copyWith(
                                //           color: colorWhite, fontSize: 18.sp)),
                                // )),
                                SizedBox(
                                  height: 1.h,
                                ),
                                FittedBox(
                                  child: SizedBox(
                                    width: 70.w,
                                    child: Text(widget.bannerdata![0].title!,
                                        textAlign: TextAlign.center,
                                        style: Style_File.title.copyWith(
                                            color: colorWhite,
                                            fontSize: 18.sp)),
                                  ),
                                ),

                                Spacer(),
                                Container(
                                  width: 90.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    boxShadow: [],
                                    // elevation: 8,
                                    // shadowColor: Colors.blue,
                                    //  borderRadius: BorderRadius.circular(2.h),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(2.h),
                                      bottomRight: Radius.circular(2.h),
                                    ),
                                  ),
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_fire_department_rounded,
                                            size: 25,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 1.h,
                                          ),
                                          Text(
                                              "${widget.bannerdata![0].calorie ?? '0'} Kcal",
                                              style: Style_File.title.copyWith(
                                                  color: colorBlack,
                                                  fontSize: 16.sp)),
                                          SizedBox(
                                            width: 6.h,
                                          ),
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 25,
                                            color: colorGrey,
                                          ),
                                          SizedBox(
                                            width: 1.h,
                                          ),
                                          Text(
                                              "${int.parse(widget.bannerdata![0].cookTime!) + int.parse(widget.bannerdata![0].prepareTime!)} min",
                                              style: Style_File.title.copyWith(
                                                  color: colorBlack,
                                                  fontSize: 16.sp)),
                                          SizedBox(
                                            width: 6.h,
                                          ),
                                          Icon(
                                            Icons.self_improvement_rounded,
                                            size: 28,
                                            color: colorSecondry,
                                          ),
                                          // Icon(Icons.label, color: Colors.red,size: 25),
                                          Text(
                                              "${widget.bannerdata![0].serving} Servering",
                                              style: Style_File.title.copyWith(
                                                  color: colorBlack,
                                                  fontSize: 16.sp)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 2.w,
                    ),
                    Container(
                      height: 10.w,
                      width: 10.w,
                      decoration: BoxDecoration(
                        color: Color(0xffc9d3e0),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Center(
                        child: IconButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            icon: Icon(
                              Platform.isAndroid
                                  ? Icons.arrow_back
                                  : Icons.arrow_back_ios,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Spacer(),
                    if (widget.bannerdata!.isNotEmpty)
                      Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Color(0xffc9d3e0),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            widget.callback!(true);
                          },
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 1.h,
                    ),
                    if (widget.bannerdata!.isNotEmpty)
                      Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Color(0xffc9d3e0),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: IconButton(
                          icon: Icon(widget.bannerdata![0].isLike != null
                              ? widget.bannerdata![0].isLike! == "1"
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined
                              : Icons.thumb_up_alt_outlined),
                          onPressed: () => _isPressedLike(
                              widget.bannerdata![0].isLike!,
                              widget.bannerdata![0].id!.toString(),
                              0,
                              widget.bannerdata![0].like != null
                                  ? widget.bannerdata![0].like!.id!.toString()
                                  : '0'),
                          iconSize: 6.w,
                          color: widget.bannerdata![0].isLike! == "1"
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    SizedBox(
                      width: 1.h,
                    ),
                    if (widget.bannerdata!.isNotEmpty)
                      Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Color(0xffc9d3e0),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: IconButton(
                          icon: Icon(widget.bannerdata![0].isFavorite != null
                              ? widget.bannerdata![0].isFavorite! == "1"
                                  ? Icons.favorite
                                  : Icons.favorite_border
                              : Icons.favorite_border),
                          onPressed: () => _pressed(
                              widget.bannerdata![0].isFavorite!,
                              widget.bannerdata![0].id!.toString(),
                              0,
                              widget.bannerdata![0].favorite != null
                                  ? widget.bannerdata![0].favorite!.id!
                                      .toString()
                                  : '0'),
                          iconSize: 6.w,
                          color: widget.bannerdata![0].isFavorite! == "1"
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    SizedBox(
                      width: 1.h,
                    ),
                  ],
                ),
              ],
            )
          ]),
    );
  }
}
