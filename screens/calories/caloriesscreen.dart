import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/provider/foodcategoryprovider.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/slidercheck.dart';

import 'package:http/http.dart';
// import 'package:halsogourmet/utils/seekbardata.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../page_routes/routes.dart';
import '../../utils/colors.dart';
// import '../../utils/seekbarui.dart';
import '../../utils/string_file.dart';
import '../../utils/style_file.dart';

class CaloriesScreen extends StatefulWidget {
  final String? foodtypeId;
  final String? foodtypeName;
  final Function? callback;

  const CaloriesScreen({
    Key? key,
    this.foodtypeId,
    this.foodtypeName,
    this.callback,
  }) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  FoodcategoriesProvider foodcategoriesProvider = FoodcategoriesProvider();
  TextEditingController kcalControlletr = TextEditingController();
  TextEditingController proteincalControlletr = TextEditingController();
  TextEditingController crobcalControlletr = TextEditingController();
  TextEditingController fatcalControlletr = TextEditingController();
  List name = ['Protein', 'Kolhydrater', 'Fett'];

  List<double> namevalue = [0.0, 0.0, 0.0];
  List<double> valueper = [0.0, 0.0, 0.0];
  List<double> filtterdatedata = [0.0, 0.0, 0.0];
  double filtterKcal = 0.0;
  bool proteinchange = false;
  bool carbohydratechange = false;
  bool fetchange = false;
  double totalcal = 0.0;
  bool textfiled1 = false;
  bool textfiled2 = false;
  bool textfiled3 = false;
  bool popshowmicros = false;

  bool _validate = false;

  // DateTime currentDate = DateTime.now();
  // DateTime? finaldatetime;
  // TextEditingController _textEditingController = new TextEditingController();
  // int valuecalender = 0;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: currentDate,
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2050));
  //   if (pickedDate != null && pickedDate != currentDate) {
  //     setState(() {
  //       _textEditingController.text =
  //           DateFormat("dd-MM-yyyy").format(pickedDate);
  //       finaldatetime = pickedDate;
  //     });
  //   }
  // }

  DateTime currentDate = DateTime.now();
  DateTime? finaldatetime;
  TextEditingController _textEditingController = new TextEditingController();
  int valuecalender = 0;

  Future<void> _selectDate(BuildContext context,
      FoodcategoriesProvider foodcategoriesProvider) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _textEditingController.text =
            DateFormat("yyyy-MM-dd").format(pickedDate);
        finaldatetime = pickedDate;
      });
      await foodcategoriesProvider.createcaloriefilters(
          _textEditingController.text, widget.foodtypeId!);

      if (foodcategoriesProvider.createcaloriefiltersModel != null) {
        filtterdatedata[0] = double.parse(double.parse(
                foodcategoriesProvider.createcaloriefiltersModel.data!.protein!)
            .toStringAsFixed(2));
        filtterdatedata[1] = double.parse(double.parse(foodcategoriesProvider
                .createcaloriefiltersModel.data!.carbohydrate!)
            .toStringAsFixed(2));
        filtterdatedata[2] = double.parse(double.parse(
                foodcategoriesProvider.createcaloriefiltersModel.data!.fat!)
            .toStringAsFixed(2));
        filtterKcal = double.parse(double.parse(
                foodcategoriesProvider.createcaloriefiltersModel.data!.calorie!)
            .toStringAsFixed(2));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _textEditingController.text = DateFormat("yyyy-MM-dd").format(currentDate);
    finaldatetime = currentDate;
    foodcategoriesProvider =
        Provider.of<FoodcategoriesProvider>(context, listen: false);
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    await foodcategoriesProvider.createcaloriefilters(
        _textEditingController.text, widget.foodtypeId!);
    if (foodcategoriesProvider.createcaloriefiltersModel != null) {
      filtterdatedata[0] = double.parse(double.parse(
              foodcategoriesProvider.createcaloriefiltersModel.data!.protein!)
          .toStringAsFixed(2));
      filtterdatedata[1] = double.parse(double.parse(foodcategoriesProvider
              .createcaloriefiltersModel.data!.carbohydrate!)
          .toStringAsFixed(2));
      filtterdatedata[2] = double.parse(double.parse(
              foodcategoriesProvider.createcaloriefiltersModel.data!.fat!)
          .toStringAsFixed(2));
      filtterKcal = double.parse(double.parse(
              foodcategoriesProvider.createcaloriefiltersModel.data!.calorie!)
          .toStringAsFixed(2));
    }
  }

  @override
  void dispose() {
    kcalControlletr.dispose();
    super.dispose();
  }

  // List<TextEditingController> controllter = [
  //   proteincalControlletr,crobcalControlletr,fatcalControlletr
  // ];

  String _error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Consumer<FoodcategoriesProvider>(
          builder: (context, caloriesprovider, child) {
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Column(
                    // shrinkWrap: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kaloribehov",
                        style: Style_File.subtitle.copyWith(
                            color: colorBlack,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 15.w,
                            child: TextField(
                              // maxLength: 3,
                              controller: kcalControlletr,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    int cal = int.parse(kcalControlletr.text);
                                    totalcal = double.parse(cal.toString());
                                    double thress = double.parse(
                                        (cal / 3).toStringAsFixed(1));
                                    double protein = double.parse((double.parse(
                                              (((cal * 20) / 100) / 4)
                                                  .toStringAsFixed(1),
                                            ) -
                                            (filtterdatedata[0]))
                                        .toStringAsFixed(1));
                                    double carbohydrate =
                                        double.parse((double.parse(
                                                  (((cal * 62) / 100) / 4)
                                                      .toStringAsFixed(1),
                                                ) -
                                                (filtterdatedata[1]))
                                            .toStringAsFixed(1));
                                    double fat = double.parse((double.parse(
                                                (((cal * 18) / 100) / 9)
                                                    .toStringAsFixed(1)) -
                                            (filtterdatedata[2]))
                                        .toStringAsFixed(1));

                                    namevalue[0] = protein > 0 ? protein : 0;

                                    namevalue[1] =
                                        carbohydrate > 0 ? carbohydrate : 0;
                                    namevalue[2] = fat > 0 ? fat : 0;
                                    // print(protein);
                                    // print(((namevalue[0] * 100) / cal));
                                    valueper[0] = namevalue[0] > 0
                                        ? ((((namevalue[0] * 4) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    valueper[1] = namevalue[1] > 0
                                        ? ((((namevalue[1] * 4) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    valueper[2] = namevalue[2] > 0
                                        ? ((((namevalue[2] * 9) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    textfiled1 = false;
                                    textfiled2 = false;
                                    textfiled3 = false;
                                    proteincalControlletr.text =
                                        namevalue[0].toInt().toString();
                                    crobcalControlletr.text =
                                        namevalue[1].toInt().toString();
                                    fatcalControlletr.text =
                                        namevalue[2].toInt().toString();
                                  });
                                  print(namevalue);
                                  print(valueper);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                ),
                                hintText: "00",
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1.h,
                          ),
                          Text(
                            "Kcal",
                            style: Style_File.subtitle.copyWith(
                              color: colorBlack,
                              fontSize: 16.sp,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            // height: 4.h,
                            width: 40.w,
                            child: GestureDetector(
                              onTap: (() {
                                _selectDate(context, caloriesprovider);
                              }),
                              child: TextField(
                                controller: _textEditingController,
                                enabled: false,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      color: Colors.red,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'DD-MM-YYYY',
                                    hintStyle: Style_File.subtitle
                                        .copyWith(fontSize: 14.sp)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        _error,
                        style: Style_File.subtitle
                            .copyWith(color: Colors.red, fontSize: 15.sp),
                      ),

                      // Text(
                      //   _validate.toString(),
                      //   //"value can not be empty!",
                      //   style: Style_File.subtile.copyWith(
                      //     color: Colors.red,
                      //     fontSize: 14.sp,
                      //   ),
                      // ),

                      if (kcalControlletr.text.isNotEmpty)
                        Text(
                          "kvarvarande kalori : ${(double.parse(kcalControlletr.text) - filtterKcal) > 0 ? (double.parse(kcalControlletr.text) - filtterKcal).toStringAsFixed(2) : 0}",
                          style: TextStyle(
                              color: colorSecondry,
                              fontWeight: FontWeight.bold),
                        ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Macros",
                            style: Style_File.subtitle.copyWith(
                                color: colorBlack,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                if (kcalControlletr.text.isNotEmpty) {
                                  setState(() {
                                    int cal = int.parse(kcalControlletr.text);
                                    totalcal = double.parse(cal.toString());
                                    double thress = double.parse(
                                        (cal / 3).toStringAsFixed(1));
                                    // double protein = double.parse(
                                    //     (((cal * 20) / 100) / 4).toStringAsFixed(1));
                                    // double carbohydrate = double.parse(
                                    //     (((cal * 62) / 100) / 4).toStringAsFixed(1));
                                    // double fat = double.parse(
                                    //     (((cal * 18) / 100) / 9).toStringAsFixed(1));

                                    // namevalue[0] = protein;
                                    // namevalue[1] = carbohydrate;
                                    // namevalue[2] = fat;
                                    // valueper[0] = 20;
                                    // valueper[1] = 62;
                                    // valueper[2] = 18;
                                    double protein = double.parse((double.parse(
                                              (((cal * 20) / 100) / 4)
                                                  .toStringAsFixed(1),
                                            ) -
                                            (filtterdatedata[0]))
                                        .toStringAsFixed(1));
                                    double carbohydrate =
                                        double.parse((double.parse(
                                                  (((cal * 62) / 100) / 4)
                                                      .toStringAsFixed(1),
                                                ) -
                                                (filtterdatedata[1]))
                                            .toStringAsFixed(1));
                                    double fat = double.parse((double.parse(
                                                (((cal * 18) / 100) / 9)
                                                    .toStringAsFixed(1)) -
                                            (filtterdatedata[2]))
                                        .toStringAsFixed(1));

                                    namevalue[0] = protein > 0 ? protein : 0;

                                    namevalue[1] =
                                        carbohydrate > 0 ? carbohydrate : 0;
                                    namevalue[2] = fat > 0 ? fat : 0;
                                    valueper[0] = namevalue[0] > 0
                                        ? ((((namevalue[0] * 4) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    valueper[1] = namevalue[1] > 0
                                        ? ((((namevalue[1] * 4) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    valueper[2] = namevalue[2] > 0
                                        ? ((((namevalue[2] * 9) * 100) / cal)
                                            .toDouble())
                                        : 0;
                                    proteinchange = false;
                                    carbohydratechange = false;
                                    fetchange = false;
                                    textfiled1 = false;
                                    textfiled2 = false;
                                    textfiled3 = false;
                                    proteincalControlletr.text =
                                        namevalue[0].toInt().toString();
                                    crobcalControlletr.text =
                                        namevalue[1].toInt().toString();
                                    fatcalControlletr.text =
                                        namevalue[2].toInt().toString();
                                  });
                                  print(namevalue);
                                }
                              },
                              icon: Icon(Icons.restart_alt_rounded))
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      ListView.builder(
                          itemCount: name.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          name[index].toString(),
                                          style: Style_File.subtitle.copyWith(
                                            color: colorBlack,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // height: 100.h,
                                      width: 15.w,
                                      child: TextField(
                                        // maxLength: 3,
                                        controller: index == 0
                                            ? proteincalControlletr
                                            : index == 1
                                                ? crobcalControlletr
                                                : fatcalControlletr,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          if (value != null) {
                                            if (index == 0) {
                                              setState(() {
                                                textfiled1 = true;
                                                textfiled2 = false;
                                                textfiled3 = false;
                                              });
                                            } else if (index == 1) {
                                              setState(() {
                                                textfiled1 = false;
                                                textfiled2 = true;
                                                textfiled3 = false;
                                              });
                                            } else if (index == 2) {
                                              setState(() {
                                                textfiled1 = false;
                                                textfiled2 = false;
                                                textfiled3 = true;
                                              });
                                            }
                                            double finavalueper = 0.0;
                                            double cal = double.parse(
                                                kcalControlletr.text);

                                            // double checkvalue = double.parse(value);
                                            double checkvalue =
                                                double.parse(value);
                                            if (index == 0 || index == 1) {
                                              finavalueper = ((checkvalue * 4) *
                                                  100 /
                                                  cal);
                                            } else {
                                              finavalueper = ((checkvalue * 9) *
                                                  100 /
                                                  cal);
                                            }

                                            controllerprotein(
                                                index, cal, finavalueper);
                                          }
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 1.h,
                                          ),
                                          hintText: "00",
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                getui(index),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: Colors.red),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Text(
                                        "${filtterdatedata[index].toString()} g"),
                                    SizedBox(
                                        width: 50.w,
                                        child: Center(
                                            child: Text(
                                                "${namevalue[index].toString()} g"))),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.breakfastScreen,
                                arguments: {
                                  StringFile.foodtypeId: widget.foodtypeId,
                                  StringFile.foodtypeName: widget.foodtypeName
                                },
                              );
                            },
                            child: Container(
                              height: 6.h,
                              width: 18.h,
                              decoration: BoxDecoration(
                                  color: colorSecondry,
                                  borderRadius: BorderRadius.circular(10.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorGrey,
                                      blurRadius: 1.h,
                                    ),
                                  ]),
                              child: InkWell(
                                onTap: () {
                                  if (kcalControlletr.text.isEmpty) {
                                    setState(() {
                                      _error =
                                          'Kalori värdet kan inte vara tomt'; // value can\'t be empty
                                      isLoading = false;
                                    });

                                    DialogHelper.showFlutterToast(
                                        strMsg:
                                            "Kalori värdet kan inte vara tomt");
                                  } else {
                                    if ((double.parse(kcalControlletr.text) -
                                            filtterKcal) >
                                        0) {
                                      setState(() {
                                        MyApp.protein = namevalue[0].toString();
                                        MyApp.carbohydrate =
                                            namevalue[1].toString();
                                        MyApp.fat = namevalue[2].toString();
                                        MyApp.calorie = (double.parse(
                                                    kcalControlletr.text) -
                                                filtterKcal)
                                            .toStringAsFixed(2);
                                        MyApp.filterfat = true;
                                        MyApp.filtercalorie = true;
                                        MyApp.filtercarbohydrate = true;
                                        MyApp.filterprotein = true;
                                        MyApp.filterdate = true;
                                        MyApp.Date = DateTime.parse(
                                            _textEditingController.text);
                                      });

                                      Navigator.pushNamed(
                                        context,
                                        Routes.breakfastScreen,
                                        arguments: {
                                          StringFile.foodtypeId:
                                              widget.foodtypeId,
                                          StringFile.foodtypeName:
                                              widget.foodtypeName
                                        },
                                      ).then((value) {
                                        setState(() {
                                          MyApp.protein = "null";
                                          MyApp.carbohydrate = "null";
                                          MyApp.fat = "null";
                                          MyApp.calorie = "null";
                                          MyApp.filterfat = false;
                                          MyApp.filtercalorie = false;
                                          MyApp.filtercarbohydrate = false;
                                          MyApp.filterprotein = false;
                                          MyApp.filterdate = false;
                                          MyApp.Date = DateTime.now()
                                              .subtract(Duration(days: 2));
                                        });
                                        fetchdata();
                                      });
                                    } else {
                                      setState(() {
                                        popshowmicros = true;
                                      });
                                    }
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Fortsätt",
                                    style: Style_File.subtitle.copyWith(
                                      color: colorWhite,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.breakfastScreen,
                                arguments: {
                                  StringFile.foodtypeId: widget.foodtypeId,
                                  StringFile.foodtypeName: widget.foodtypeName
                                },
                              );
                            },
                            child: Container(
                              height: 6.h,
                              width: 18.h,
                              decoration: BoxDecoration(
                                  color: colorSecondry,
                                  borderRadius: BorderRadius.circular(10.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorGrey,
                                      blurRadius: 1.h,
                                    ),
                                  ]),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.breakfastScreen,
                                    arguments: {
                                      StringFile.foodtypeId: widget.foodtypeId,
                                      StringFile.foodtypeName:
                                          widget.foodtypeName
                                    },
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Hoppa över",
                                    style: Style_File.subtitle.copyWith(
                                      color: colorWhite,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ),
              if (popshowmicros)
                Center(
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    color: Colors.transparent,
                    child: AlertDialog(
                      title: const Text("Write !"),
                      content: Text(
                          "Nej, detta går inte ${(double.parse(kcalControlletr.text) - filtterKcal) > 0 ? (double.parse(kcalControlletr.text) - filtterKcal).toStringAsFixed(2) : 0} kcal"),
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
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget getui(int index) {
    return Slidercheck(
        value: valueper[index],
        min: 0.0,
        max: 100,
        //divisions: 20,
        activeColor: colorSecondry,
        inactiveColor: colorWhite,
        thumbColor: Colors.grey,
        // activeTrackColor: Colors.red,
        // inactiveTrackColor: Colors.amber,
        label: '${valueper[index].round()}',
        onChanged: (double newValue) {
          if (kcalControlletr.text.isNotEmpty) {
            double cal = double.parse(kcalControlletr.text);
            print(" value $valueper");
            print(" name $namevalue");
            print(totalcal);

            if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
              setState(() {
                textfiled1 = false;
                textfiled2 = false;
                textfiled3 = false;
              });
              protein(index, cal, datatostring(newValue));
            } else if (valueper[index] > newValue) {
              setState(() {
                textfiled1 = false;
                textfiled2 = false;
                textfiled3 = false;
              });
              protein(index, cal, datatostring(newValue));
            }
          }
        },
        semanticFormatterCallback: (double newValue) {
          return '${newValue.round()}';
        });
  }

  protein(int index, double cal, double newValue) {
    double proteinvalue = 0.0;
    double fatvalue = 0.0;
    double carbohydratevalue = 0.0;
    double carbohydrateper = 0.0;
    double fatper = 0.0;
    double proteinper = 0.0;
    double differedata = 0.0;

    if (index == 0) {
      setState(() {
        proteinchange = true;
      });
      proteinper = newValue;
      differedata = datatostring(datasub(newValue, 20));

      proteinvalue = datatostring(((cal * newValue) / 100) / 4);

      if ((!carbohydratechange && !fetchange) ||
          (carbohydratechange && fetchange)) {
        if (newValue >= 20) {
          double dividetwo = datatostring(differedata / 2);

          fatper = datasub(dividetwo, 18);

          carbohydrateper = datasub(dividetwo, 62);

          fatvalue = datatostring((((cal * fatper) / 100) / 9));

          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          fatper = 18 + dividetwo;
          carbohydrateper = 62 + dividetwo;
          fatvalue = datatostring(((cal * fatper) / 100) / 9);
          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        }
      } else if (!fetchange) {
        carbohydrateper = valueper[1];
        carbohydratevalue = datatostring(namevalue[1]);
        double caldata = datatostring(
            cal - datatostring((proteinvalue + carbohydratevalue) * 4));
        double totalper = proteinper + carbohydrateper;
        fatper = 100 - totalper;
        fatvalue = datatostring(((caldata) / 9));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 18 + dividetwo;

        //   fatvalue = datatostring(((caldata) / 9));
        // }
      } else if (!carbohydratechange) {
        fatper = valueper[2];
        fatvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = proteinper + fatper;
        carbohydrateper = 100 - totalper;
        carbohydratevalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;
        //   carbohydrateper = datasub(dividetwo, 62);

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // } else {
        //   double dividetwo = differedata;

        //   carbohydrateper = 62 + dividetwo;

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;
      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        if (totalper == 100) {
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
              namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                  : 0.0;
              namevalue[1] = double.parse(
                          ((carbohydratevalue) - filtterdatedata[1])
                              .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                      .toStringAsFixed(2))
                  : 0.0;
              namevalue[2] = double.parse(((fatvalue) - filtterdatedata[2])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                  : 0.0;
              valueper[0] = double.parse((((namevalue[0] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[1] = double.parse((((namevalue[1] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[2] = double.parse((((namevalue[2] * 9) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              if (!textfiled1) {
                proteincalControlletr.text =
                    (namevalue[0] + filtterdatedata[0]).toInt().toString();
              }
              if (!textfiled2) {
                crobcalControlletr.text =
                    (namevalue[1] + filtterdatedata[1]).toInt().toString();
              }
              if (!textfiled3) {
                fatcalControlletr.text =
                    (namevalue[2] + filtterdatedata[2]).toInt().toString();
              }
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    } else if (index == 1) {
      setState(() {
        carbohydratechange = true;
      });
      carbohydrateper = newValue;
      differedata = datatostring(datasub(newValue, 62));

      carbohydratevalue = datatostring(((cal * newValue) / 100) / 4);

      if ((!proteinchange && !fetchange) || (proteinchange && fetchange)) {
        if (newValue >= 62) {
          double dividetwo = datatostring(differedata / 2);

          fatper = datasub(dividetwo, 18);

          proteinper = datasub(dividetwo, 20);

          fatvalue = datatostring((((cal * fatper) / 100) / 9));

          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          fatper = 18 + dividetwo;
          proteinper = 20 + dividetwo;
          fatvalue = datatostring(((cal * fatper) / 100) / 9);
          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
        }
      } else if (!fetchange) {
        proteinper = valueper[0];
        print(proteinper);

        proteinvalue = datatostring(namevalue[0]);

        double caldata = datatostring(
            cal - datatostring((proteinvalue + carbohydratevalue) * 4));
        double totalper = proteinper + carbohydrateper;
        fatper = 100 - totalper;

        fatvalue = datatostring((caldata) / 9);

        // if (newValue >= 62) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 100 - totalper;

        //   fatvalue = datatostring((caldata) / 9);
        // }
        print(fatper);
        print(carbohydrateper);
      } else if (!proteinchange) {
        fatper = valueper[2];
        fatvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = fatper + carbohydrateper;
        proteinper = 100 - totalper;
        proteinvalue = datatostring(((caldata) / 4));
        // if (newValue >= 62) {
        //   double dividetwo = differedata;
        //   proteinper = datasub(dividetwo, 20);

        //   proteinvalue = datatostring(((caldata) / 4));
        // } else {
        //   proteinper = 100 - totalper;

        //   proteinvalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;

      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        if (totalper == 100) {
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            // namevalue[0] = datatostring(proteinvalue) > 0.0
            //     ? datatostring(proteinvalue)
            //     : 0.0;
            // namevalue[1] = datatostring(carbohydratevalue) > 0.0
            //     ? datatostring(carbohydratevalue)
            //     : 0.0;
            // namevalue[2] =
            //     datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
            // valueper[0] = proteinper > 0 ? proteinper : 0.0;
            // valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
            // valueper[2] = fatper > 0 ? fatper : 0.0;
            namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                        .toStringAsFixed(2)) >
                    0.0
                ? double.parse(
                    ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                : 0.0;
            namevalue[1] = double.parse(
                        ((carbohydratevalue) - filtterdatedata[1])
                            .toStringAsFixed(2)) >
                    0.0
                ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                    .toStringAsFixed(2))
                : 0.0;
            namevalue[2] = double.parse(
                        ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2)) >
                    0.0
                ? double.parse(
                    ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                : 0.0;
            valueper[0] = double.parse(
                        (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            valueper[1] = double.parse(
                        (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            valueper[2] = double.parse(
                        (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            if (!textfiled1) {
              proteincalControlletr.text =
                  (namevalue[0] + filtterdatedata[0]).toInt().toString();
            }
            if (!textfiled2) {
              crobcalControlletr.text =
                  (namevalue[1] + filtterdatedata[1]).toInt().toString();
            }
            if (!textfiled3) {
              fatcalControlletr.text =
                  (namevalue[2] + filtterdatedata[2]).toInt().toString();
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    } else if (index == 2) {
      setState(() {
        fetchange = true;
      });
      fatper = newValue;
      differedata = datatostring(datasub(newValue, 18));

      fatvalue = datatostring(((cal * newValue) / 100) / 9);

      if ((!carbohydratechange && !proteinchange) ||
          (carbohydratechange && proteinchange)) {
        if (newValue >= 18) {
          double dividetwo = datatostring(differedata / 2);

          proteinper = datasub(dividetwo, 20);

          carbohydrateper = datasub(dividetwo, 62);

          proteinvalue = datatostring((((cal * proteinper) / 100) / 4));

          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          proteinper = 20 + dividetwo;
          carbohydrateper = 62 + dividetwo;
          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        }
      } else if (!proteinchange) {
        carbohydrateper = valueper[1];
        carbohydratevalue = datatostring(namevalue[1]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        // double caldata = datatostring(
        //     cal - datatostring(( carbohydratevalue) * 4));
        double totalper = fatper + carbohydrateper;
        proteinper = 100 - totalper;
        proteinvalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 18 + dividetwo;

        //   fatvalue = datatostring(((caldata) / 9));
        // }
      } else if (!carbohydratechange) {
        proteinper = valueper[0];
        proteinvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = proteinper + fatper;
        carbohydrateper = 100 - totalper;
        carbohydratevalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;
        //   carbohydrateper = datasub(dividetwo, 62);

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // } else {
        //   double dividetwo = differedata;

        //   carbohydrateper = 62 + dividetwo;

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;
      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        if (totalper == 100) {
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
              // namevalue[0] = datatostring(proteinvalue) > 0.0
              //     ? datatostring(proteinvalue)
              //     : 0.0;
              // namevalue[1] = datatostring(carbohydratevalue) > 0.0
              //     ? datatostring(carbohydratevalue)
              //     : 0.0;
              // namevalue[2] =
              //     datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
              // valueper[0] = proteinper > 0 ? proteinper : 0.0;
              // valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
              // valueper[2] = fatper > 0 ? fatper : 0.0;
              namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                  : 0.0;
              namevalue[1] = double.parse(
                          ((carbohydratevalue) - filtterdatedata[1])
                              .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                      .toStringAsFixed(2))
                  : 0.0;
              namevalue[2] = double.parse(((fatvalue) - filtterdatedata[2])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                  : 0.0;
              valueper[0] = double.parse((((namevalue[0] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[1] = double.parse((((namevalue[1] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[2] = double.parse((((namevalue[2] * 9) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              if (!textfiled1) {
                proteincalControlletr.text =
                    (namevalue[0] + filtterdatedata[0]).toInt().toString();
              }
              if (!textfiled2) {
                crobcalControlletr.text =
                    (namevalue[1] + filtterdatedata[1]).toInt().toString();
              }
              if (!textfiled3) {
                fatcalControlletr.text =
                    (namevalue[2] + filtterdatedata[2]).toInt().toString();
              }
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    }
    // else if (index == 2) {
    //   setState(() {
    //     fetchange = true;
    //   });

    //   differedata = datatostring(datasub(newValue, 18));

    //   fatvalue = datatostring(((cal * newValue) / 100) / 9);

    //   if ((!proteinchange && !carbohydratechange) ||
    //       (proteinchange && carbohydratechange)) {
    //     if (newValue >= 18) {
    //       double dividetwo = datatostring(differedata / 2);

    //       carbohydrateper = datasub(dividetwo, 62);

    //       proteinper = datasub(dividetwo, 20);

    //       carbohydratevalue =
    //           datatostring((((cal * carbohydrateper) / 100) / 4));

    //       proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
    //     } else {
    //       double dividetwo = datatostring(differedata / 2);

    //       carbohydrateper = 18 + dividetwo;
    //       proteinper = 20 + dividetwo;
    //       carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
    //       proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
    //     }
    //   } else if (!carbohydratechange) {
    //     print("object ok 2");
    //     proteinper = valueper[0];

    //     proteinvalue = datatostring(namevalue[0]);

    //     double caldata = datatostring(cal -
    //         (datatostring((proteinper) * 4) + datatostring(fatvalue * 9)));
    //     double totalper = fatper + proteinper;
    //     carbohydrateper = 100 - totalper;
    //     carbohydratevalue = datatostring(((caldata) / 4));

    //     // if (newValue >= 62) {
    //     //   double dividetwo = differedata;

    //     //   carbohydrateper = datasub(dividetwo, 62);

    //     //   carbohydratevalue = datatostring(((caldata) / 4));
    //     // } else {
    //     //   double dividetwo = differedata;
    //     //   carbohydrateper = 62 + dividetwo;

    //     //   carbohydratevalue = datatostring(((caldata) / 4));
    //     // }
    //   } else if (!proteinchange) {
    //     print("object ok 3");
    //     carbohydrateper = valueper[1];
    //     carbohydratevalue = datatostring(namevalue[1]);
    //     double caldata = datatostring(cal -
    //         (datatostring((carbohydratevalue) * 4) +
    //             datatostring(fatvalue * 9)));
    //     double totalper = fatper + carbohydrateper;
    //     proteinper = 100 - totalper;
    //     proteinvalue = datatostring(((caldata) / 4));
    //     // if (newValue >= 62) {
    //     //   double dividetwo = differedata;
    //     //   proteinper = datasub(dividetwo, 20);

    //     //   proteinvalue = datatostring(((caldata) / 4));
    //     // } else {
    //     //   double dividetwo = differedata;

    //     //   proteinper = 20 + dividetwo;

    //     //   proteinvalue = datatostring(((caldata) / 4));
    //     // }
    //   }

    //   double backtotalcal = totalcal;

    //   totalcal = datatostring(
    //       double.parse((proteinvalue * 4).toStringAsFixed(1)) +
    //           double.parse((fatvalue * 9).toStringAsFixed(1)) +
    //           double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
    //   print(totalcal);
    //   double totalper = proteinper + carbohydrateper + fatper;
    //   print(totalper);
    //   if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
    //     if (totalper == 100) {
    //       if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
    //         namevalue[0] = datatostring(proteinvalue) > 0.0
    //             ? datatostring(proteinvalue)
    //             : 0.0;
    //         namevalue[1] = datatostring(carbohydratevalue) > 0.0
    //             ? datatostring(carbohydratevalue)
    //             : 0.0;
    //         namevalue[2] =
    //             datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
    //         valueper[0] = proteinper > 0 ? proteinper : 0.0;
    //         valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
    //         valueper[2] = fatper > 0 ? fatper : 0.0;
    //       } else {
    //         setState(() {
    //           totalcal = backtotalcal;
    //         });
    //       }
    //     }
    //   }
    // }
  }

  controllerprotein(int index, double cal, double newValue) {
    double proteinvalue = 0.0;
    double fatvalue = 0.0;
    double carbohydratevalue = 0.0;
    double carbohydrateper = 0.0;
    double fatper = 0.0;
    double proteinper = 0.0;
    double differedata = 0.0;

    if (index == 0) {
      setState(() {
        proteinchange = true;
      });
      proteinper = newValue;
      differedata = datatostring(datasub(newValue, 20));

      proteinvalue = datatostring(((cal * newValue) / 100) / 4);

      if ((!carbohydratechange && !fetchange) ||
          (carbohydratechange && fetchange)) {
        if (newValue >= 20) {
          double dividetwo = datatostring(differedata / 2);

          fatper = datasub(dividetwo, 18);

          carbohydrateper = datasub(dividetwo, 62);

          fatvalue = datatostring((((cal * fatper) / 100) / 9));

          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          fatper = 18 + dividetwo;
          carbohydrateper = 62 + dividetwo;
          fatvalue = datatostring(((cal * fatper) / 100) / 9);
          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        }
      } else if (!fetchange) {
        carbohydrateper = valueper[1];
        carbohydratevalue = datatostring(namevalue[1]);
        double caldata = datatostring(
            cal - datatostring((proteinvalue + carbohydratevalue) * 4));
        double totalper = proteinper + carbohydrateper;
        fatper = 100 - totalper;
        fatvalue = datatostring(((caldata) / 9));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 18 + dividetwo;

        //   fatvalue = datatostring(((caldata) / 9));
        // }
      } else if (!carbohydratechange) {
        fatper = valueper[2];
        fatvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = proteinper + fatper;
        carbohydrateper = 100 - totalper;
        carbohydratevalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;
        //   carbohydrateper = datasub(dividetwo, 62);

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // } else {
        //   double dividetwo = differedata;

        //   carbohydrateper = 62 + dividetwo;

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;
      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        print("object data 1");
        if (totalper == 100) {
          print("object data 2");
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            print("object data 3");
            if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
              print("object data 4");
              // namevalue[0] = datatostring(proteinvalue) > 0.0
              //     ? datatostring(proteinvalue)
              //     : 0.0;
              // namevalue[1] = datatostring(carbohydratevalue) > 0.0
              //     ? datatostring(carbohydratevalue)
              //     : 0.0;
              // namevalue[2] =
              //     datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
              // valueper[0] = proteinper > 0 ? proteinper : 0.0;
              // valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
              // valueper[2] = fatper > 0 ? fatper : 0.0;
              // print("textfiled1 $textfiled1");
              namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                  : 0.0;
              namevalue[1] = double.parse(
                          ((carbohydratevalue) - filtterdatedata[1])
                              .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                      .toStringAsFixed(2))
                  : 0.0;
              namevalue[2] = double.parse(((fatvalue) - filtterdatedata[2])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                  : 0.0;
              valueper[0] = double.parse((((namevalue[0] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[1] = double.parse((((namevalue[1] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[2] = double.parse((((namevalue[2] * 9) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                  : 0.0;

              if (!textfiled1) {
                proteincalControlletr.text =
                    (namevalue[0] + filtterdatedata[0]).toInt().toString();
              }
              if (!textfiled2) {
                crobcalControlletr.text =
                    (namevalue[1] + filtterdatedata[1]).toInt().toString();
              }
              if (!textfiled3) {
                fatcalControlletr.text =
                    (namevalue[2] + filtterdatedata[2]).toInt().toString();
              }
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    } else if (index == 1) {
      setState(() {
        carbohydratechange = true;
      });
      carbohydrateper = newValue;
      differedata = datatostring(datasub(newValue, 62));

      carbohydratevalue = datatostring(((cal * newValue) / 100) / 4);

      if ((!proteinchange && !fetchange) || (proteinchange && fetchange)) {
        if (newValue >= 62) {
          double dividetwo = datatostring(differedata / 2);

          fatper = datasub(dividetwo, 18);

          proteinper = datasub(dividetwo, 20);

          fatvalue = datatostring((((cal * fatper) / 100) / 9));

          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          fatper = 18 + dividetwo;
          proteinper = 20 + dividetwo;
          fatvalue = datatostring(((cal * fatper) / 100) / 9);
          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
        }
      } else if (!fetchange) {
        proteinper = valueper[0];
        print(proteinper);

        proteinvalue = datatostring(namevalue[0]);

        double caldata = datatostring(
            cal - datatostring((proteinvalue + carbohydratevalue) * 4));
        double totalper = proteinper + carbohydrateper;
        fatper = 100 - totalper;

        fatvalue = datatostring((caldata) / 9);

        // if (newValue >= 62) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 100 - totalper;

        //   fatvalue = datatostring((caldata) / 9);
        // }
        print(fatper);
        print(carbohydrateper);
      } else if (!proteinchange) {
        fatper = valueper[2];
        fatvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = fatper + carbohydrateper;
        proteinper = 100 - totalper;
        proteinvalue = datatostring(((caldata) / 4));
        // if (newValue >= 62) {
        //   double dividetwo = differedata;
        //   proteinper = datasub(dividetwo, 20);

        //   proteinvalue = datatostring(((caldata) / 4));
        // } else {
        //   proteinper = 100 - totalper;

        //   proteinvalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;

      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        if (totalper == 100) {
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            // namevalue[0] = datatostring(proteinvalue) > 0.0
            //     ? datatostring(proteinvalue)
            //     : 0.0;
            // namevalue[1] = datatostring(carbohydratevalue) > 0.0
            //     ? datatostring(carbohydratevalue)
            //     : 0.0;
            // namevalue[2] =
            //     datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
            // valueper[0] = proteinper > 0 ? proteinper : 0.0;
            // valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
            // valueper[2] = fatper > 0 ? fatper : 0.0;
            namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                        .toStringAsFixed(2)) >
                    0.0
                ? double.parse(
                    ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                : 0.0;
            namevalue[1] = double.parse(
                        ((carbohydratevalue) - filtterdatedata[1])
                            .toStringAsFixed(2)) >
                    0.0
                ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                    .toStringAsFixed(2))
                : 0.0;
            namevalue[2] = double.parse(
                        ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2)) >
                    0.0
                ? double.parse(
                    ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                : 0.0;
            valueper[0] = double.parse(
                        (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            valueper[1] = double.parse(
                        (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            valueper[2] = double.parse(
                        (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2)) >
                    0
                ? double.parse(
                    (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                : 0.0;
            if (!textfiled1) {
              proteincalControlletr.text =
                  (namevalue[0] + filtterdatedata[0]).toInt().toString();
            }
            if (!textfiled2) {
              crobcalControlletr.text =
                  (namevalue[1] + filtterdatedata[1]).toInt().toString();
            }
            if (!textfiled3) {
              fatcalControlletr.text =
                  (namevalue[2] + filtterdatedata[2]).toInt().toString();
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    } else if (index == 2) {
      setState(() {
        fetchange = true;
      });

      fatper = newValue;
      differedata = datatostring(datasub(newValue, 18));

      fatvalue = datatostring(((cal * newValue) / 100) / 9);

      if ((!carbohydratechange && !proteinchange) ||
          (carbohydratechange && proteinchange)) {
        if (newValue >= 18) {
          double dividetwo = datatostring(differedata / 2);

          proteinper = datasub(dividetwo, 20);

          carbohydrateper = datasub(dividetwo, 62);

          proteinvalue = datatostring((((cal * proteinper) / 100) / 4));

          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        } else {
          double dividetwo = datatostring(differedata / 2);

          proteinper = 20 + dividetwo;
          carbohydrateper = 62 + dividetwo;
          proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
          carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
        }
      } else if (!proteinchange) {
        carbohydrateper = valueper[1];
        carbohydratevalue = datatostring(namevalue[1]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        // double caldata = datatostring(
        //     cal - datatostring(( carbohydratevalue) * 4));
        double totalper = fatper + carbohydrateper;
        proteinper = 100 - totalper;
        proteinvalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;

        //   fatper = datasub(dividetwo, 18);

        //   fatvalue = datatostring(((caldata) / 9));
        // } else {
        //   double dividetwo = differedata;
        //   fatper = 18 + dividetwo;

        //   fatvalue = datatostring(((caldata) / 9));
        // }
      } else if (!carbohydratechange) {
        proteinper = valueper[0];
        proteinvalue = datatostring(namevalue[2]);
        double caldata = datatostring(cal -
            (datatostring((carbohydratevalue) * 4) +
                datatostring(fatvalue * 9)));
        double totalper = proteinper + fatper;
        carbohydrateper = 100 - totalper;
        carbohydratevalue = datatostring(((caldata) / 4));
        // if (newValue >= 20) {
        //   double dividetwo = differedata;
        //   carbohydrateper = datasub(dividetwo, 62);

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // } else {
        //   double dividetwo = differedata;

        //   carbohydrateper = 62 + dividetwo;

        //   carbohydratevalue = datatostring(((caldata) / 4));
        // }
      }

      double backtotalcal = totalcal;
      totalcal = datatostring(
          double.parse((proteinvalue * 4).toStringAsFixed(1)) +
              double.parse((fatvalue * 9).toStringAsFixed(1)) +
              double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
      double totalper = proteinper + carbohydrateper + fatper;
      if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
        if (totalper == 100) {
          if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
            if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
              // namevalue[0] = datatostring(proteinvalue) > 0.0
              //     ? datatostring(proteinvalue)
              //     : 0.0;
              // namevalue[1] = datatostring(carbohydratevalue) > 0.0
              //     ? datatostring(carbohydratevalue)
              //     : 0.0;
              // namevalue[2] =
              //     datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
              // valueper[0] = proteinper > 0 ? proteinper : 0.0;
              // valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
              // valueper[2] = fatper > 0 ? fatper : 0.0;
              namevalue[0] = double.parse((proteinvalue - filtterdatedata[0])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((proteinvalue) - filtterdatedata[0]).toStringAsFixed(2))
                  : 0.0;
              namevalue[1] = double.parse(
                          ((carbohydratevalue) - filtterdatedata[1])
                              .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(((carbohydratevalue) - filtterdatedata[1])
                      .toStringAsFixed(2))
                  : 0.0;
              namevalue[2] = double.parse(((fatvalue) - filtterdatedata[2])
                          .toStringAsFixed(2)) >
                      0.0
                  ? double.parse(
                      ((fatvalue) - filtterdatedata[2]).toStringAsFixed(2))
                  : 0.0;
              valueper[0] = double.parse((((namevalue[0] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[0] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[1] = double.parse((((namevalue[1] * 4) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[1] * 4) * 100) / cal).toStringAsFixed(2))
                  : 0.0;
              valueper[2] = double.parse((((namevalue[2] * 9) * 100) / cal)
                          .toStringAsFixed(2)) >
                      0
                  ? double.parse(
                      (((namevalue[2] * 9) * 100) / cal).toStringAsFixed(2))
                  : 0.0;

              if (!textfiled1) {
                proteincalControlletr.text =
                    (namevalue[0] + filtterdatedata[0]).toInt().toString();
              }
              if (!textfiled2) {
                crobcalControlletr.text =
                    (namevalue[1] + filtterdatedata[1]).toInt().toString();
              }
              if (!textfiled3) {
                fatcalControlletr.text =
                    (namevalue[2] + filtterdatedata[2]).toInt().toString();
              }
            }
          } else {
            setState(() {
              totalcal = backtotalcal;
            });
          }
        }
      }
    }
    // else if (index == 2) {
    //   setState(() {
    //     fetchange = true;
    //   });

    //   differedata = datatostring(datasub(newValue, 18));

    //   fatvalue = datatostring(((cal * newValue) / 100) / 9);

    //   if ((!proteinchange && !carbohydratechange) ||
    //       (proteinchange && carbohydratechange)) {
    //     if (newValue >= 18) {
    //       double dividetwo = datatostring(differedata / 2);

    //       carbohydrateper = datasub(dividetwo, 62);

    //       proteinper = datasub(dividetwo, 20);

    //       carbohydratevalue =
    //           datatostring((((cal * carbohydrateper) / 100) / 4));

    //       proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
    //     } else {
    //       double dividetwo = datatostring(differedata / 2);

    //       carbohydrateper = 18 + dividetwo;
    //       proteinper = 20 + dividetwo;
    //       carbohydratevalue = datatostring(((cal * carbohydrateper) / 100) / 4);
    //       proteinvalue = datatostring(((cal * proteinper) / 100) / 4);
    //     }
    //   } else if (!carbohydratechange) {
    //     print("object ok 2");
    //     proteinper = valueper[0];

    //     proteinvalue = datatostring(namevalue[0]);

    //     double caldata = datatostring(cal -
    //         (datatostring((proteinper) * 4) + datatostring(fatvalue * 9)));
    //     double totalper = fatper + proteinper;
    //     carbohydrateper = 100 - totalper;
    //     carbohydratevalue = datatostring(((caldata) / 4));

    //     // if (newValue >= 62) {
    //     //   double dividetwo = differedata;

    //     //   carbohydrateper = datasub(dividetwo, 62);

    //     //   carbohydratevalue = datatostring(((caldata) / 4));
    //     // } else {
    //     //   double dividetwo = differedata;
    //     //   carbohydrateper = 62 + dividetwo;

    //     //   carbohydratevalue = datatostring(((caldata) / 4));
    //     // }
    //   } else if (!proteinchange) {
    //     print("object ok 3");
    //     carbohydrateper = valueper[1];
    //     carbohydratevalue = datatostring(namevalue[1]);
    //     double caldata = datatostring(cal -
    //         (datatostring((carbohydratevalue) * 4) +
    //             datatostring(fatvalue * 9)));
    //     double totalper = fatper + carbohydrateper;
    //     proteinper = 100 - totalper;
    //     proteinvalue = datatostring(((caldata) / 4));
    //     // if (newValue >= 62) {
    //     //   double dividetwo = differedata;
    //     //   proteinper = datasub(dividetwo, 20);

    //     //   proteinvalue = datatostring(((caldata) / 4));
    //     // } else {
    //     //   double dividetwo = differedata;

    //     //   proteinper = 20 + dividetwo;

    //     //   proteinvalue = datatostring(((caldata) / 4));
    //     // }
    //   }

    //   double backtotalcal = totalcal;

    //   totalcal = datatostring(
    //       double.parse((proteinvalue * 4).toStringAsFixed(1)) +
    //           double.parse((fatvalue * 9).toStringAsFixed(1)) +
    //           double.parse((carbohydratevalue * 4).toStringAsFixed(1)));
    //   print(totalcal);
    //   double totalper = proteinper + carbohydrateper + fatper;
    //   print(totalper);
    //   if (proteinper > 0 && carbohydrateper > 0 && fatper > 0) {
    //     if (totalper == 100) {
    //       if (totalcal <= cal + 1 && totalcal >= (cal - 1)) {
    //         namevalue[0] = datatostring(proteinvalue) > 0.0
    //             ? datatostring(proteinvalue)
    //             : 0.0;
    //         namevalue[1] = datatostring(carbohydratevalue) > 0.0
    //             ? datatostring(carbohydratevalue)
    //             : 0.0;
    //         namevalue[2] =
    //             datatostring(fatvalue) > 0.0 ? datatostring(fatvalue) : 0.0;
    //         valueper[0] = proteinper > 0 ? proteinper : 0.0;
    //         valueper[1] = carbohydrateper > 0 ? carbohydrateper : 0.0;
    //         valueper[2] = fatper > 0 ? fatper : 0.0;
    //       } else {
    //         setState(() {
    //           totalcal = backtotalcal;
    //         });
    //       }
    //     }
    //   }
    // }
  }

  datatostring(double value) {
    double data = double.parse(value.toStringAsFixed(2));
    return data;
  }

  datasub(double finalvalue, double finalcheck) {
    double finaldata = finalcheck > finalvalue
        ? finalcheck - finalvalue
        : finalvalue - finalcheck;
    return finaldata;
  }
  // protein(int index, double cal, double newValue) {
  //   if (kcalControlletr.text.isNotEmpty) {
  //     if (index == 0) {
  //       setState(() {
  //         proteinchange = true;
  //       });
  //       double protein = namevalue[index] * 4;
  //       double perprotein = ((protein * 100) / cal);

  //       double carbohydrate = 0.0;
  //       double fat = 0.0;
  //       if (!carbohydratechange && !fetchange) {
  //         if (perprotein >= 20.0) {
  //           double pervalue = perprotein - 20.0;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double carbohydrateadd = 62.0 - add;
  //           double fatadd = 18.0 - add;
  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perprotein;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double carbohydrateadd = 62.0 + add;
  //           double fatadd = 18.0 + add;
  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));

  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         }
  //         namevalue[0] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //         namevalue[1] = carbohydrate > 0.0 ? carbohydrate : 0.0;
  //         namevalue[2] = fat > 0.0 ? fat : 0.0;
  //       } else if (!fetchange) {
  //         if (perprotein >= 20.0) {
  //           double pervalue = perprotein - 20.0;

  //           double add = pervalue;

  //           double fatadd = 18.0 - add;

  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perprotein;

  //           double add = pervalue;

  //           double fatadd = 18.0 + add;

  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         }
  //         namevalue[0] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;

  //         namevalue[2] = fat > 0.0 ? fat : 0.0;
  //       } else if (!carbohydratechange) {
  //         if (perprotein >= 20.0) {
  //           double pervalue = perprotein - 20.0;

  //           double add = pervalue;

  //           double carbohydrateadd = 62.0 - add;

  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perprotein;

  //           double add = pervalue;

  //           double carbohydrateadd = 62.0 + add;

  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //         }
  //         namevalue[0] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //         namevalue[1] = carbohydrate > 0.0 ? carbohydrate : 0.0;
  //       } else {
  //         print("object ok");
  //         namevalue[0] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //       }
  //       // double pervalue = (subvalue * 50) / 100;
  //       // double carbohydrate =
  //       //     double.parse((pervalue / 4).toStringAsFixed(1));
  //       // double fat = double.parse((pervalue / 9).toStringAsFixed(1));

  //       setState(() {
  //         totalcal = double.parse((namevalue[0] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[1] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[2] * 9).toStringAsFixed(1));
  //       });
  //     } else if (index == 1) {
  //       setState(() {
  //         carbohydratechange = true;
  //       });
  //       double carbohydrate = namevalue[index] * 4;
  //       double percarbohydrate = ((carbohydrate * 100) / cal);

  //       double protein = 0.0;
  //       double fat = 0.0;
  //       if (!proteinchange && !fetchange) {
  //         print("object");
  //         if (percarbohydrate >= 62.0) {
  //           double pervalue = percarbohydrate - 62.0;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double proteinadd = 20.0 - add;
  //           double fatadd = 18.0 - add;
  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 62.0 - percarbohydrate;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double proteinadd = 20.0 + add;
  //           double fatadd = 18.0 + add;
  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         }
  //         namevalue[1] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //         namevalue[0] = protein > 0.0 ? protein : 0.0;
  //         namevalue[2] = fat > 0.0 ? fat : 0.0;
  //       } else if (!proteinchange) {
  //         if (percarbohydrate >= 62.0) {
  //           double pervalue = percarbohydrate - 62.0;

  //           double add = pervalue;

  //           double proteinadd = 20.0 - add;

  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 62.0 - percarbohydrate;

  //           double add = pervalue;

  //           double proteinadd = 20.0 + add;

  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         }
  //         namevalue[1] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //         namevalue[0] = protein > 0.0 ? protein : 0.0;
  //       } else if (!fetchange) {
  //         if (percarbohydrate >= 62.0) {
  //           double pervalue = percarbohydrate - 62.0;

  //           double add = pervalue;

  //           double fatadd = 18.0 - add;

  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 62.0 - percarbohydrate;

  //           double add = pervalue;

  //           double fatadd = 18.0 + add;

  //           fat = double.parse((((cal * fatadd) / 100) / 9).toStringAsFixed(1));
  //         }
  //         namevalue[1] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;

  //         namevalue[2] = fat > 0.0 ? fat : 0.0;
  //       } else {
  //         namevalue[1] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //       }
  //       // double pervalue = (subvalue * 50) / 100;
  //       // double carbohydrate =
  //       //     double.parse((pervalue / 4).toStringAsFixed(1));
  //       // double fat = double.parse((pervalue / 9).toStringAsFixed(1));

  //       setState(() {
  //         totalcal = double.parse((namevalue[0] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[1] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[2] * 9).toStringAsFixed(1));
  //       });
  //     } else if (index == 2) {
  //       setState(() {
  //         fetchange = true;
  //       });
  //       double fat = namevalue[index] * 9;
  //       double perfat = ((fat * 100) / cal);

  //       double protein = 0.0;
  //       double carbohydrate = 0.0;

  //       if (!carbohydratechange && !fetchange) {
  //         if (perfat >= 18.0) {
  //           double pervalue = perfat - 20.0;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double carbohydrateadd = 62.0 - add;
  //           double proteinadd = 20.0 - add;
  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perfat;

  //           double add = double.parse((pervalue / 2).toStringAsFixed(2));

  //           double carbohydrateadd = 62.0 - add;
  //           double proteinadd = 20.0 - add;
  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         }
  //         namevalue[2] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //         namevalue[1] = carbohydrate > 0.0 ? carbohydrate : 0.0;
  //         namevalue[0] = protein > 0.0 ? protein : 0.0;
  //       } else if (!proteinchange) {
  //         if (perfat >= 18.0) {
  //           double pervalue = perfat - 20.0;

  //           double add = pervalue;

  //           double carbohydrateadd = 62.0 - add;

  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perfat;

  //           double add = pervalue;

  //           double carbohydrateadd = 62.0 - add;

  //           carbohydrate = double.parse(
  //               (((cal * carbohydrateadd) / 100) / 4).toStringAsFixed(1));
  //         }
  //         namevalue[2] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;

  //         namevalue[1] = carbohydrate > 0.0 ? carbohydrate : 0.0;
  //       } else if (!carbohydratechange) {
  //         if (perfat >= 18.0) {
  //           double pervalue = perfat - 20.0;

  //           double add = pervalue;

  //           double proteinadd = 20.0 - add;

  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         } else {
  //           double pervalue = 20.0 - perfat;

  //           double add = pervalue;

  //           double proteinadd = 20.0 - add;

  //           protein = double.parse(
  //               (((cal * proteinadd) / 100) / 4).toStringAsFixed(1));
  //         }
  //         namevalue[2] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;

  //         namevalue[0] = protein > 0.0 ? protein : 0.0;
  //       } else {
  //         namevalue[2] =
  //             newValue.roundToDouble() > 0.0 ? newValue.roundToDouble() : 0.0;
  //       }

  //       // double pervalue = (subvalue * 50) / 100;
  //       // double carbohydrate =
  //       //     double.parse((pervalue / 4).toStringAsFixed(1));
  //       // double fat = double.parse((pervalue / 9).toStringAsFixed(1));

  //       setState(() {
  //         totalcal = double.parse((namevalue[0] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[1] * 4).toStringAsFixed(1)) +
  //             double.parse((namevalue[2] * 9).toStringAsFixed(1));
  //       });
  //     }
  //   }
  // }
}
