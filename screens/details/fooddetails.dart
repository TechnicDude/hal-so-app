import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/provider/recipeprovider.dart';
import 'package:halsogourmet/screens/details/recentrecipe.dart';
import 'package:halsogourmet/screens/details/watchvideo.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/calender.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/ratingscreen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../page_routes/routes.dart';
import '../../../utils/colors.dart';
import '../../utils/sepraters.dart';
import '../../utils/style_file.dart';
import 'foodslideui.dart';

class FoodDetails extends StatefulWidget {
  final String foodtypeName;
  final String foodtypeId;
  final String? quantity;
  // final Function callback;
  FoodDetails({
    required this.foodtypeId,
    required this.foodtypeName,
    this.quantity,
    //required this.callback
  });
  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  TextEditingController _reviewcontroller = new TextEditingController();
  TextEditingController _textEditingController = new TextEditingController();

  double ratingdata = 0.0;

  bool reviewlike = true;
  bool microsshow = true;
  bool ingredientsshow = false;
  bool cooksshow = false;
  RecipeProvider recipeProvider = RecipeProvider();
  bool searchshow = false;
  bool showpop = false;
  bool showvideo = false;
  List<String> fooddataamount = [];
  double filtercalories = 0.0;
  String? kacl, fat, protein, kolhydrate;
  bool chagedata = false;
  bool popshowmicros = false;
  double checkcalories = 0.0;
  get i => null;

  bool showpoppPremium = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

    fetchdata();

    super.initState();
  }

  fetchdata() async {
    await recipeProvider.recipebyid(widget.foodtypeId);
    setState(() {
      _textEditingController.text =
          widget.quantity != null ? widget.quantity! : '100';
      if (widget.quantity != null) {
        if (recipeProvider.recipeListbyid[0].ingradients!.isNotEmpty) {
          if (!chagedata) {
            kacl = recipeProvider.recipeListbyid[0].calorie;
            protein = recipeProvider.recipeListbyid[0].protein;
            kolhydrate = recipeProvider.recipeListbyid[0].carbohydrate;
            fat = recipeProvider.recipeListbyid[0].fat;
            for (int i = 0;
                i < recipeProvider.recipeListbyid[0].ingradients!.length;
                i++) {
              fooddataamount.add(
                  recipeProvider.recipeListbyid[0].ingradients![i].amount!);
            }
          }
          setState(() {
            chagedata = true;
          });
          if (fooddataamount.isNotEmpty) {
            double kaclvalue = double.parse(kacl!);

            double kaclcheck = kaclvalue / 100;
            print(kaclcheck);
            double fatvalue = double.parse(fat!);
            print(kaclcheck);
            double fatcheck = fatvalue / 100;
            double kolhydratevalue = double.parse(kolhydrate!);
            print(kolhydratevalue);
            double kolhydratecheck = kolhydratevalue / 100;
            double proteinvalue = double.parse(protein!);

            double proteincheck = proteinvalue / 100;
            setState(() {
              recipeProvider.recipeListbyid[0].calorie =
                  (kaclcheck * (double.parse(_textEditingController.text)))
                      .toStringAsFixed(2);
              recipeProvider.recipeListbyid[0].fat =
                  (fatcheck * (double.parse(_textEditingController.text)))
                      .toStringAsFixed(2);

              recipeProvider.recipeListbyid[0].protein =
                  (proteincheck * (double.parse(_textEditingController.text)))
                      .toStringAsFixed(2);
              recipeProvider.recipeListbyid[0].carbohydrate = (kolhydratecheck *
                      (double.parse(_textEditingController.text)))
                  .toStringAsFixed(2);
              checkcalories =
                  double.parse(recipeProvider.recipeListbyid[0].calorie!);
            });
            if (MyApp.filtercalorie) {
              if (double.parse(MyApp.calorie!) <
                  double.parse(recipeProvider.recipeListbyid[0].calorie!)) {
                setState(() {
                  popshowmicros = true;
                });
              }
            }

            for (int i = 0;
                i < recipeProvider.recipeListbyid[0].ingradients!.length;
                i++) {
              double value = double.parse(fooddataamount[i]);
              print(value);
              double check = value / 100;
              print(check);
              double mute = check * (double.parse(_textEditingController.text));
              setState(() {
                recipeProvider.recipeListbyid[0].ingradients![i].amount =
                    mute.toStringAsFixed(1).toString();
              });
            }
          }
        }
      }
    });
    await recipeProvider.reletedrecipelist(widget.foodtypeId);
    await recipeProvider.reviewlist(widget.foodtypeId);
    await recipeProvider.calendarfoodtypes();
    if (recipeProvider.recipeListbyid[0] != null) {
      filtercalories = double.parse(recipeProvider.recipeListbyid[0].calorie!);
    }
    setState(() {
      _textEditingController.text =
          widget.quantity != null ? widget.quantity! : '100';
    });
  }

  String searchString = '';

  Future setnreviwe(String rating, String commit) async {
    var body = {
      "userId": MyApp.userid,
      "recipeId": widget.foodtypeId,
      "rating": rating,
      "comment": commit,
    };
    print(body);
    LoginApi loginApi = LoginApi(body);
    var response = await loginApi.sentreview();
    print(response);
    if (response['status'].toString().toLowerCase() == 'success') {
      DialogHelper.showFlutterToast(strMsg: response['message']);
      Navigator.pop(context);
      await recipeProvider.reviewlist(widget.foodtypeId);
    }
  }

  openBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.h),
            topRight: Radius.circular(5.h),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 3.h,
                right: 3.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 22,
                      icon: Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                Text(
                  "Vad är ditt pris?",
                  style: Style_File.title
                      .copyWith(color: colorBlack, fontSize: 18.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StarRating(
                      rating: ratingdata,
                      callback: (value) {
                        setState(() {
                          ratingdata = value;
                        });
                      },
                      onRatingChanged: (ratings) {},
                      color: Colors.red,
                      size: 5.h,
                    ),
                  ],
                ),

                SizedBox(height: 3.h),
                Text(
                  "Dela gärna din åsikt om produkten",
                  style: Style_File.title.copyWith(color: colorBlack),
                ),
                SizedBox(height: 3.h),

                TextFormField(
                  maxLines: 5,
                  controller: _reviewcontroller,
                  decoration: InputDecoration(
                    hintText:
                        "vänligen ge din värdefulla recension och kommentar!",
                    // "Skriv inhttps://www.youtube.com/embed/7YtPDwk8QaY din recension",
                    hintStyle: Style_File.subtitle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide:
                    //       BorderSide(width: 1, color: colorGrey), //<-- SEE HERE
                    // ),//
                    // focusedBorder:InputBorder(
                    //   borderSide:
                    //       BorderSide(width: 1, color: colorGrey), //<-- SEE HERE
                    // ),/
                  ),
                ),

                SizedBox(height: 3.h),

                SizedBox(
                  height: 5.h,
                  width: 90.w,
                  child: ButtonWidget(
                      //  text: 'SEND REVIEW',
                      text: 'SKICKA RECENSION',
                      onTap: () {
                        setnreviwe(
                            ratingdata.toString(), _reviewcontroller.text);
                      }),
                ),
                //SizedBox(height: 2.h),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(builder: (context, recipeProvider, child) {
      if (recipeProvider.recipeListbyid.isNotEmpty) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.disconnected
              ? InternetNotAvailable()
              : SafeArea(
                  child: InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: SingleChildScrollView(
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (showvideo)
                                          Container(
                                            color: Colors.white,
                                            height: 36.h,
                                          ),
                                        if (!showvideo)
                                          FoodSliderScreen(
                                            bannerdata:
                                                recipeProvider.recipeListbyid,
                                            callback: (value) {
                                              if (MyApp.filtercalorie) {
                                                if (double.parse(
                                                        MyApp.calorie!) <
                                                    double.parse(recipeProvider
                                                        .recipeListbyid[0]
                                                        .calorie!)) {
                                                  setState(() {
                                                    popshowmicros = true;
                                                  });
                                                } else {
                                                  double checkcaloriess = double
                                                          .parse(
                                                              MyApp.calorie!) -
                                                      double.parse(
                                                          recipeProvider
                                                              .recipeListbyid[0]
                                                              .calorie!);
                                                  if (checkcaloriess >
                                                      double.parse(
                                                          MyApp.calorie!)) {
                                                    setState(() {
                                                      popshowmicros = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showpop = true;
                                                    });
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  showpop = true;
                                                });
                                              }
                                            },
                                          ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 2.h, right: 2.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Gram"),
                                              Container(
                                                width: 15.w,
                                                child: TextField(
                                                  // maxLength: 3,
                                                  controller:
                                                      _textEditingController,
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    if (value.isNotEmpty) {
                                                      if (recipeProvider
                                                          .recipeListbyid[0]
                                                          .ingradients!
                                                          .isNotEmpty) {
                                                        if (!chagedata) {
                                                          kacl = recipeProvider
                                                              .recipeListbyid[0]
                                                              .calorie;
                                                          protein = recipeProvider
                                                              .recipeListbyid[0]
                                                              .protein;
                                                          kolhydrate =
                                                              recipeProvider
                                                                  .recipeListbyid[
                                                                      0]
                                                                  .carbohydrate;
                                                          fat = recipeProvider
                                                              .recipeListbyid[0]
                                                              .fat;
                                                          for (int i = 0;
                                                              i <
                                                                  recipeProvider
                                                                      .recipeListbyid[
                                                                          0]
                                                                      .ingradients!
                                                                      .length;
                                                              i++) {
                                                            fooddataamount.add(
                                                                recipeProvider
                                                                    .recipeListbyid[
                                                                        0]
                                                                    .ingradients![
                                                                        i]
                                                                    .amount!);
                                                          }
                                                        }
                                                        setState(() {
                                                          chagedata = true;
                                                        });
                                                        if (fooddataamount
                                                            .isNotEmpty) {
                                                          double kaclvalue =
                                                              double.parse(
                                                                  kacl!);

                                                          double kaclcheck =
                                                              kaclvalue / 100;
                                                          print(kaclcheck);
                                                          double fatvalue =
                                                              double.parse(
                                                                  fat!);
                                                          print(kaclcheck);
                                                          double fatcheck =
                                                              fatvalue / 100;
                                                          double
                                                              kolhydratevalue =
                                                              double.parse(
                                                                  kolhydrate!);
                                                          print(
                                                              kolhydratevalue);
                                                          double
                                                              kolhydratecheck =
                                                              kolhydratevalue /
                                                                  100;
                                                          double proteinvalue =
                                                              double.parse(
                                                                  protein!);
                                                          print(value);
                                                          double proteincheck =
                                                              proteinvalue /
                                                                  100;
                                                          setState(() {
                                                            recipeProvider
                                                                .recipeListbyid[
                                                                    0]
                                                                .calorie = (kaclcheck *
                                                                    (double.parse(
                                                                        _textEditingController
                                                                            .text)))
                                                                .toStringAsFixed(
                                                                    2);
                                                            recipeProvider
                                                                .recipeListbyid[
                                                                    0]
                                                                .fat = (fatcheck *
                                                                    (double.parse(
                                                                        _textEditingController
                                                                            .text)))
                                                                .toStringAsFixed(
                                                                    2);

                                                            recipeProvider
                                                                .recipeListbyid[
                                                                    0]
                                                                .protein = (proteincheck *
                                                                    (double.parse(
                                                                        _textEditingController
                                                                            .text)))
                                                                .toStringAsFixed(
                                                                    2);
                                                            recipeProvider
                                                                .recipeListbyid[
                                                                    0]
                                                                .carbohydrate = (kolhydratecheck *
                                                                    (double.parse(
                                                                        _textEditingController
                                                                            .text)))
                                                                .toStringAsFixed(
                                                                    2);
                                                            checkcalories = double
                                                                .parse(recipeProvider
                                                                    .recipeListbyid[
                                                                        0]
                                                                    .calorie!);
                                                          });
                                                          if (MyApp
                                                              .filtercalorie) {
                                                            if (double.parse(MyApp
                                                                    .calorie!) <
                                                                double.parse(
                                                                    recipeProvider
                                                                        .recipeListbyid[
                                                                            0]
                                                                        .calorie!)) {
                                                              setState(() {
                                                                popshowmicros =
                                                                    true;
                                                              });
                                                            }
                                                          }

                                                          for (int i = 0;
                                                              i <
                                                                  recipeProvider
                                                                      .recipeListbyid[
                                                                          0]
                                                                      .ingradients!
                                                                      .length;
                                                              i++) {
                                                            double value =
                                                                double.parse(
                                                                    fooddataamount[
                                                                        i]);
                                                            print(value);
                                                            double check =
                                                                value / 100;
                                                            print(check);
                                                            double mute = check *
                                                                (double.parse(
                                                                    _textEditingController
                                                                        .text));
                                                            setState(() {
                                                              recipeProvider
                                                                      .recipeListbyid[
                                                                          0]
                                                                      .ingradients![
                                                                          i]
                                                                      .amount =
                                                                  mute
                                                                      .toStringAsFixed(
                                                                          1)
                                                                      .toString();
                                                            });
                                                          }
                                                        }
                                                      }
                                                      // setState(() {
                                                      //   int cal = int.parse(kcalControlletr.text);
                                                      //   totalcal = double.parse(cal.toString());
                                                      //   double thress =
                                                      //       double.parse((cal / 3).toStringAsFixed(1));
                                                      //   double protein = double.parse(
                                                      //       (((cal * 20) / 100) / 4).toStringAsFixed(1));
                                                      //   double carbohydrate = double.parse(
                                                      //       (((cal * 62) / 100) / 4).toStringAsFixed(1));
                                                      //   double fat = double.parse(
                                                      //       (((cal * 18) / 100) / 9).toStringAsFixed(1));

                                                      //   namevalue[0] = protein;

                                                      //   namevalue[1] = carbohydrate;
                                                      //   namevalue[2] = fat;
                                                      //   valueper[0] = 20;
                                                      //   valueper[1] = 62;
                                                      //   valueper[2] = 18;
                                                      //   textfiled1 = false;
                                                      //   textfiled2 = false;
                                                      //   textfiled3 = false;
                                                      //   proteincalControlletr.text =
                                                      //       namevalue[0].toInt().toString();
                                                      //   crobcalControlletr.text =
                                                      //       namevalue[1].toInt().toString();
                                                      //   fatcalControlletr.text =
                                                      //       namevalue[2].toInt().toString();
                                                      // });
                                                      // print(namevalue);
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                    ),
                                                    hintText: "00",
                                                    border:
                                                        OutlineInputBorder(),
                                                    focusedBorder:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              FittedBox(
                                                child: SizedBox(
                                                  width: 95.w,
                                                  child: Text(
                                                      recipeProvider
                                                          .recipeListbyid[0]
                                                          .shortDescription!,
                                                      style: Style_File.subtitle
                                                          .copyWith(
                                                              color: colorBlack,
                                                              fontSize: 17.sp)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: (() {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        if (microsshow) {
                                                          setState(() {
                                                            microsshow = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            microsshow = true;
                                                          });
                                                        }
                                                      }),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: microsshow
                                                              ? colorSecondry
                                                                  .withOpacity(
                                                                      .4)
                                                              : Colors
                                                                  .grey[350],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.w),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h,
                                                                  bottom: 2.h,
                                                                  left: 1.w,
                                                                  right: 1.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Energifördelning",
                                                                  style: Style_File
                                                                      .title
                                                                      .copyWith(
                                                                          color:
                                                                              colorBlack,
                                                                          fontSize:
                                                                              18.sp)),
                                                              Icon(microsshow
                                                                  ? Icons
                                                                      .keyboard_arrow_up
                                                                  : Icons
                                                                      .keyboard_arrow_down),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    if (microsshow)
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                    if (microsshow)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                colorcarddetails,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.w)),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1.h,
                                                                bottom: 1.h,
                                                                left: 1.w,
                                                                right: 1.w),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            // mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Kalorier",
                                                                    style: Style_File
                                                                        .title,
                                                                  ),
                                                                  Text(
                                                                      "${recipeProvider.recipeListbyid[0].calorie ?? '0'} kcal")
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Protein  ",
                                                                    style: Style_File
                                                                        .title,
                                                                  ),
                                                                  Text(
                                                                      "${recipeProvider.recipeListbyid[0].protein ?? '0'} g")
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Kolhydrater",
                                                                    style: Style_File
                                                                        .title,
                                                                  ),
                                                                  Text(
                                                                      "${recipeProvider.recipeListbyid[0].carbohydrate ?? '0'} g")
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Fett",
                                                                    style: Style_File
                                                                        .title,
                                                                  ),
                                                                  Text(
                                                                      "${recipeProvider.recipeListbyid[0].fat ?? '0'} g")
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    InkWell(
                                                      onTap: (() {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        if (ingredientsshow) {
                                                          setState(() {
                                                            ingredientsshow =
                                                                false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            ingredientsshow =
                                                                true;
                                                          });
                                                        }
                                                      }),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ingredientsshow
                                                              ? colorSecondry
                                                                  .withOpacity(
                                                                      .4)
                                                              : Colors
                                                                  .grey[350],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.w),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h,
                                                                  bottom: 2.h,
                                                                  left: 1.w,
                                                                  right: 1.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Ingredienser",
                                                                  style: Style_File
                                                                      .title
                                                                      .copyWith(
                                                                          color:
                                                                              colorBlack,
                                                                          fontSize:
                                                                              18.sp)),
                                                              Icon(ingredientsshow
                                                                  ? Icons
                                                                      .keyboard_arrow_up
                                                                  : Icons
                                                                      .keyboard_arrow_down),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    if (ingredientsshow)
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                    if (ingredientsshow)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                colorcarddetails,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.w)),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 1.h,
                                                                  bottom: 1.h,
                                                                  left: 2.w,
                                                                  right: 2.w),
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: recipeProvider
                                                                      .recipeListbyid[
                                                                          0]
                                                                      .ingradients!
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 1
                                                                              .h),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                20.w,
                                                                            child:
                                                                                Text(
                                                                              "${recipeProvider.recipeListbyid[0].ingradients![index].amount.toString()} g",
                                                                              // textAlign:
                                                                              //     TextAlign.end,
                                                                              style: Style_File.title,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          ),
                                                                          Text(
                                                                            recipeProvider.recipeListbyid[0].ingradients![index].ingradient!.title!,
                                                                            style:
                                                                                Style_File.subtitle.copyWith(color: Colors.black, fontSize: 16.sp),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),

                                                    SizedBox(
                                                      height: 2.h,
                                                    ),

                                                    InkWell(
                                                      onTap: (() {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        if (cooksshow) {
                                                          setState(() {
                                                            cooksshow = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            cooksshow = true;
                                                          });
                                                        }
                                                      }),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: cooksshow
                                                              ? colorSecondry
                                                                  .withOpacity(
                                                                      .4)
                                                              : Colors
                                                                  .grey[350],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.w),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2.h,
                                                                  bottom: 2.h,
                                                                  left: 1.w,
                                                                  right: 1.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Tillagning steg för steg",
                                                                  style: Style_File
                                                                      .title
                                                                      .copyWith(
                                                                          color:
                                                                              colorBlack,
                                                                          fontSize:
                                                                              18.sp)),
                                                              Icon(cooksshow
                                                                  ? Icons
                                                                      .keyboard_arrow_up
                                                                  : Icons
                                                                      .keyboard_arrow_down),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    if (cooksshow)
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                    if (cooksshow)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                colorcarddetails,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.w)),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 1.h,
                                                                  bottom: 1.h,
                                                                  left: 2.w,
                                                                  right: 2.w),
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: recipeProvider
                                                                      .recipeListbyid[
                                                                          0]
                                                                      .cookingSteps!
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: 1
                                                                              .h),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Steg ${index + 1}",
                                                                            style:
                                                                                Style_File.title,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text(
                                                                              recipeProvider.recipeListbyid[0].cookingSteps![index].description.toString(),
                                                                              style: Style_File.subtitle.copyWith(color: Colors.black, fontSize: 16.sp),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),

                                                    // Column(),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),

                                                    if (!recipeProvider
                                                        .datanotbyrelatedrecipefound)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Relaterat recept",
                                                              style: Style_File
                                                                  .title
                                                                  .copyWith(
                                                                      color:
                                                                          colorBlack,
                                                                      fontSize:
                                                                          18.sp)),
                                                        ],
                                                      ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),

                                                    if (!recipeProvider
                                                        .datanotbyrelatedrecipefound)
                                                      recipeProvider.relatedrecipeModel !=
                                                              null
                                                          ? recipeProvider
                                                                  .datanotbyrelatedrecipefound
                                                              ? NoDataFoundErrorScreens(
                                                                  height: 50.h,
                                                                )
                                                              : RecentRecipe(
                                                                  relatedrecipedata:
                                                                      recipeProvider
                                                                          .reletedrecipeList,
                                                                  type:
                                                                      "relatedfoodtype",
                                                                  searchString:
                                                                      '',
                                                                  callback:
                                                                      (value) {
                                                                    if (value ==
                                                                        "Premium") {
                                                                      print(MyApp
                                                                          .subscriptioncheck);
                                                                      if (!MyApp
                                                                          .subscriptioncheck)
                                                                        setState(
                                                                            () {
                                                                          showpoppPremium =
                                                                              true;
                                                                        });
                                                                    }
                                                                  })
                                                          : LoaderScreen(),

                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Betyg & recensioner",
                                                            //"Rating & Reviews",
                                                            style: Style_File
                                                                .title
                                                                .copyWith(
                                                                    color:
                                                                        colorBlack,
                                                                    fontSize:
                                                                        16.sp)),
                                                        InkWell(
                                                          onTap: () {
                                                            openBottomSheet(
                                                                context);
                                                          },
                                                          child: Container(
                                                              height: 5.h,
                                                              width: 35.w,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      colorSecondry,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(2
                                                                              .w)),
                                                              child: Center(
                                                                  child: Text(
                                                                      "Lägg till recensioner",
                                                                      //"Add Reviews",
                                                                      style: Style_File.title.copyWith(
                                                                          color:
                                                                              colorWhite,
                                                                          fontSize:
                                                                              15.sp)))),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    //  if (recipeProvider.reviewList.isNotEmpty)

                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    if (recipeProvider
                                                        .reviewList.isNotEmpty)
                                                      Text(
                                                          "${recipeProvider.reviewModel.total} Reviews",
                                                          style: Style_File
                                                              .title
                                                              .copyWith(
                                                                  color:
                                                                      colorBlack,
                                                                  fontSize:
                                                                      16.sp)),

                                                    SizedBox(height: 2.h),
                                                    if (recipeProvider
                                                        .reviewList.isNotEmpty)
                                                      ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              recipeProvider
                                                                  .reviewList
                                                                  .length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        colorWhite,
                                                                    radius: 4.h,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                      APIURL.imageurl +
                                                                          recipeProvider
                                                                              .reviewList[index]
                                                                              .users!
                                                                              .userAvatar
                                                                              .toString(),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4.w,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        //  "John DavCan",
                                                                        recipeProvider
                                                                            .reviewList[index]
                                                                            .users!
                                                                            .firstName
                                                                            .toString(),

                                                                        style: Style_File
                                                                            .title,
                                                                      ),
                                                                      FittedBox(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              60.w,
                                                                          child: Text(
                                                                              recipeProvider.reviewList[index].comment.toString(),
                                                                              style: Style_File.subtitle.copyWith(color: colorBlack)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),

                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (showvideo)
                                Container(
                                  color: Colors.white,
                                  height: 35.h,
                                ),
                              if (showvideo)
                                WatchVideo(
                                  url: recipeProvider
                                      .recipeListbyid[0].recipeVideo,
                                  callback: (value) {
                                    if (showvideo) {
                                      setState(() {
                                        showvideo = false;
                                      });
                                    } else {
                                      setState(() {
                                        showvideo = true;
                                      });
                                    }
                                  },
                                ),
                              if (popshowmicros)
                                AlertDialog(
                                  title: const Text("Write !"),
                                  content: Text(
                                      "Nej, detta går inte ${double.parse(MyApp.calorie!.toString()).toStringAsFixed(2)} kcal"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.of(ctx).pop();
                                        setState(() {
                                          popshowmicros = false;
                                        });
                                        // Navigator.pop(context);
                                      },
                                      child: Container(
                                        color: colorSecondry,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text(
                                          "Ok",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (showpoppPremium)
                          Center(child: PremiumPopup(
                            callback: (value) {
                              setState(() {
                                showpoppPremium = false;
                              });
                            },
                          )),
                        if (showpop && recipeProvider.foodtypeList.isNotEmpty)
                          CalenderUI(
                            foodtypedate: recipeProvider.foodtypeList,
                            recipeid: widget.foodtypeId,
                            kcal: recipeProvider.recipeListbyid[0].calorie,
                            protein: recipeProvider.recipeListbyid[0].protein,
                            fat: recipeProvider.recipeListbyid[0].fat,
                            kolhydrater:
                                recipeProvider.recipeListbyid[0].carbohydrate,
                            quantity: _textEditingController.text,
                            callback: (value) {
                              if (value) {
                                setState(() {
                                  showpop = false;
                                });
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: (showvideo ||
                  (recipeProvider.recipeListbyid[0].recipeVideo!.isEmpty))
              ? Container()
              : FloatingActionButton.extended(
                  onPressed: () {
                    if (showvideo) {
                      setState(() {
                        showvideo = false;
                      });
                    } else {
                      setState(() {
                        showvideo = true;
                      });
                    }
                  },
                  label: const Text('Se video'),
                  icon: const Icon(Icons.play_circle_fill_outlined),
                  backgroundColor: colorSecondry,
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      } else {
        return Scaffold(
            body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Center(child: SizedBox(height: 80.h, child: LoaderScreen())),
              ],
            ),
          ),
        ));
      }
    });
// rectangle floating button
  }
}
