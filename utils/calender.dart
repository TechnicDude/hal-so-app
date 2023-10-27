import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/string_file.dart';

import 'package:halsogourmet/utils/style_file.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CalenderUI extends StatefulWidget {
  final List<FoodtypeData>? foodtypedate;
  final String? recipeid;
  final String? kcal;
  final String? protein;
  final String? fat;
  final String? kolhydrater;
  final Function? callback;
  final String quantity;
  const CalenderUI(
      {super.key,
      this.foodtypedate,
      this.recipeid,
      this.fat,
      this.kolhydrater,
      this.protein,
      this.kcal,
      this.callback,
      required this.quantity});

  @override
  State<CalenderUI> createState() => _CalenderUIState();
}

class _CalenderUIState extends State<CalenderUI> {
  DateTime currentDate = DateTime.now();
  DateTime? finaldatetime;
  TextEditingController _textEditingController = new TextEditingController();
  int valuecalender = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        locale: const Locale("sv", "SE"),
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _textEditingController.text =
            DateFormat("dd-MM-yyyy").format(pickedDate);
        finaldatetime = pickedDate;
      });
    }
  }

  addcalender(String date, String foodTypeId, String recipeId) async {
    var body = {
      "date": date,
      "recipeId": recipeId,
      "foodTypeId": foodTypeId,
      "serving": 1,
      "type": "recipe",
      "quantity": widget.quantity,
    };

    LoginApi _loginapi = new LoginApi(body);
    var response = await _loginapi.planadd();
    // print(response);
    if (response['status'].toString().toUpperCase() == 'SUCCESS') {
      DialogHelper.showFlutterToast(strMsg: response['message']);
      if (MyApp.Date != null) {
        if (MyApp.Date == DateTime.parse(date)) {
          setState(() {
            if (MyApp.filterprotein &&
                MyApp.filtercarbohydrate &&
                MyApp.filterfat &&
                MyApp.filtercalorie) {
              double proteins = double.parse(MyApp.protein!);
              double fats = double.parse(MyApp.fat!);
              double carbohydrates = double.parse(MyApp.carbohydrate!);
              double calories = double.parse(MyApp.calorie!);
              double getproteins = double.parse(widget.protein!);
              double getfats = double.parse(widget.fat!);
              double getcarbohydrates = double.parse(widget.kolhydrater!);
              double getcalories = double.parse(widget.kcal!);
              if (calories > 0) {
                calories -= getcalories;
                if (calories > 0) {
                  MyApp.calorie = calories.toString();
                } else {
                  MyApp.calorie = "0";
                }
              }
              if (proteins > 0) {
                proteins -= getproteins;
                if (proteins > 0) {
                  MyApp.protein = proteins.toString();
                } else {
                  MyApp.protein = "0";
                }
              }
              if (carbohydrates > 0) {
                carbohydrates -= getcarbohydrates;
                if (carbohydrates > 0) {
                  MyApp.carbohydrate = carbohydrates.toString();
                } else {
                  MyApp.carbohydrate = "0";
                }
              }
              if (fats > 0) {
                fats -= getfats;
                if (fats > 0) {
                  MyApp.fat = fats.toString();
                } else {
                  MyApp.fat = "0";
                }
              }
            }
          });
        }
      }

      Navigator.pushNamed(context, Routes.scheduleOK, arguments: {
        StringFile.date: _textEditingController.text,
        StringFile.datetime: DateTime.now(),
        StringFile.foodttype: widget.foodtypedate![valuecalender].id.toString(),
      }).then((value) {
        widget.callback!(true);
      });
    } else {
      DialogHelper.showFlutterToast(strMsg: response['error']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _textEditingController.text = DateFormat("dd-MM-yyyy").format(currentDate);
    finaldatetime = MyApp.filterdate ? MyApp.Date! : currentDate;
    print("object");
    print(widget.foodtypedate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      //color: Colors.white,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(2.w),
        boxShadow: [
          BoxShadow(blurRadius: 2.0),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: -1.0,
            top: -1.0,
            child: IconButton(
                onPressed: () {
                  widget.callback!(true);
                },
                icon: Icon(Icons.close)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 5.h,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("Schemalägg tid",
                      //"Schedule Time",
                      style: Style_File.title
                          .copyWith(color: colorBlack, fontSize: 18.sp)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),
                  Text("Datum",
                      style: Style_File.subtitle
                          .copyWith(color: colorBlack, fontSize: 17.sp)),
                  SizedBox(
                    height: 5.h,
                    width: 80.w,
                    child: GestureDetector(
                      onTap: (() {
                        if (!MyApp.filterdate) {
                          _selectDate(context);
                        }
                      }),
                      child: TextField(
                        controller: _textEditingController,
                        enabled: false,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month),
                            border: InputBorder.none,
                            hintText: 'DD-MM-YYYY',
                            hintStyle:
                                Style_File.subtitle.copyWith(fontSize: 15.sp)),
                      ),
                    ),
                  ),
                  Container(
                    height: 5.h,
                    width: 80.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(1.w),
                        border: Border.all(color: colorBlack)),
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: widget.foodtypedate![valuecalender].id.toString(),
                      hint: Container(
                        width: 150, //and here
                        child: Text(
                          "Välj Artikeltyp",
                          //  "Select Item Type",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),

                      style: Style_File.subtitle,
                      isExpanded: true,
                      // underline: SizedBox(),
                      // icon: Icon(
                      //   Icons.language,
                      //   color: Colors.black,
                      // ),
                      items: widget.foodtypedate!.map((FoodtypeData lang) {
                        return DropdownMenuItem<String>(
                          value: lang.id.toString(),
                          child: Text(
                            lang.foodType.toString(),
                            style: Style_File.subtitle
                                .copyWith(color: Colors.black, fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        for (int i = 0; i < widget.foodtypedate!.length; i++) {
                          if (widget.foodtypedate![i].id.toString() ==
                              val.toString()) {
                            setState(() {
                              valuecalender = i;
                            });
                            break;
                          }
                        }
                        print(valuecalender);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h, left: 70.w, bottom: 1.h),
                    child: GestureDetector(
                      onTap: (() {
                        if (widget.quantity.toString().trim() == "0") {
                          DialogHelper.showFlutterToast(
                              strMsg: "Vänligen ange kvantitet");
                        } else {
                          addcalender(
                              DateFormat("yyyy-MM-dd")
                                  .format(finaldatetime!)
                                  .toString(),
                              widget.foodtypedate![valuecalender].id.toString(),
                              widget.recipeid!);
                        }
                      }),
                      child: Container(
                        height: 3.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: colorSecondry,
                          borderRadius: BorderRadius.circular(1.w),
                          boxShadow: [
                            BoxShadow(blurRadius: 2.0),
                          ],
                        ),
                        child: Center(
                          child: Text("OK",
                              style: Style_File.title.copyWith(
                                  color: colorWhite, fontSize: 18.sp)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
