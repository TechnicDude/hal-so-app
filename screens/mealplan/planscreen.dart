import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/planprovider.dart';
import 'package:halsogourmet/screens/mealplan/ingredientlist.dart';
import 'package:halsogourmet/screens/myrefrigerator/addingredientsforweek.dart';
import 'package:halsogourmet/screens/myrefrigerator/editingredients.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class PlanShopListScreen extends StatefulWidget {
  const PlanShopListScreen({super.key});

  @override
  State<PlanShopListScreen> createState() => _PlanShopListScreenState();
}

class _PlanShopListScreenState extends State<PlanShopListScreen> {
  PlanFoodcategoriesProvider _foodcategoriesProvider =
      PlanFoodcategoriesProvider();
  DateTime todaydate = DateTime.now();
  DateTime nextmonday = DateTime.now();
  DateTime secmonday = DateTime.now();

  bool ingredientsshow = false;
  bool ingredientaddshow = false;

  bool cooksshow = true;
  DateTime? startdate;
  int? weekname;
  String ingradientslistaddid = '';
  String ingradientslistaddname = '';

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print(" today date $todaydate");
    weekNumber(DateTime.now());

    print(DateTime.now());
    _foodcategoriesProvider =
        Provider.of<PlanFoodcategoriesProvider>(context, listen: false);
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    await mostRecentWeekday(startdate!, weekname!);
    await _foodcategoriesProvider
        .calendarlist(DateFormat("yyyy-MM-dd").format(startdate!).toString());
    await _foodcategoriesProvider.weeklyingredientlist(
        DateFormat("yyyy-MM-dd").format(startdate!).toString());
  }

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  Future weekNumber(DateTime date) async {
    print("object date $date");
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }

    mostRecentWeekday(date, woy);
    mostnextandsecfind(date, woy);

    setState(() {
      weekname = woy;
    });

    return woy;
  }

  int weekNumbers(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    print(((dayOfYear - date.weekday + 10) / 7).floor());
    var week = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (week == weekname) {
      for (int i = 0; i < weeklist.length; i++) {
        weeklist[i] = false;
      }
      weeklist[0] = true;
    } else if (week == (weekname! + 1)) {
      for (int i = 0; i < weeklist.length; i++) {
        weeklist[i] = false;
      }
      weeklist[1] = true;
    } else if (week == (weekname! + 2)) {
      for (int i = 0; i < weeklist.length; i++) {
        weeklist[i] = false;
      }
      weeklist[2] = true;
    }
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  DateTime mostnextandsecfind(DateTime date, int weekday) {
    int today = date.weekday;

    var dayNr = (today + 6) % 7;

    var thisMonday = date.subtract(new Duration(days: (dayNr)));
    nextmonday = thisMonday.add(Duration(days: 7));
    secmonday = thisMonday.add(Duration(days: 14));

    return nextmonday;
  }

  DateTime mostRecentWeekday(DateTime date, int weekday) {
    print(date);
    if (date.isBefore(DateTime.now())) {
      setState(() {
        startdate = DateTime.now();
      });
    } else {
      print("object name");
      int today = date.weekday;

      var dayNr = (today + 6) % 7;

      var thisMonday = date.subtract(new Duration(days: (dayNr)));
      var nextmanday = thisMonday.add(Duration(days: 7));

      setState(() {
        startdate = thisMonday;
      });
    }
    print(startdate);

    return DateTime(
        date.year, date.month, date.day - (date.weekday - weekday) % 7);
  }

  List check = [true, false, false, false, false, false, false];
  List weeklist = [true, false, false, false];

  bool adddatashow = false;
  bool editdatashow = false;
  int contextindex = 0;

  // @override
  // void initState() {
  //   planfoodprovider =
  //       Provider.of<Planfoodprovider>(context, listen: false);
  //   fetchdata();

  //   super.initState();
  // }

  Future delete(String id) async {
    LikeApi likeApi = LikeApi();
    final response = await likeApi.deleterefoodplan(id);
    print(response);
    if (response['status'] == "success") {
      //await planfoodprovider.finalcalenderList();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      await _foodcategoriesProvider
          .calendarlist(DateFormat("yyyy-MM-dd").format(startdate!).toString());
    } else {
      DialogHelper.showFlutterToast(strMsg: response['error']);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorBlack,
        ),
        backgroundColor: colorWhite,
        centerTitle: true,
        elevation: 0,
      ),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Consumer<PlanFoodcategoriesProvider>(
              builder: (context, planfoodprovider, child) {
              return Padding(
                padding: EdgeInsets.all(2.h),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            height: 5.h,
                            child: ListView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      for (int i = 0;
                                          i < weeklist.length;
                                          i++) {
                                        setState(() {
                                          weeklist[i] = false;
                                        });
                                      }
                                      setState(() {
                                        weeklist[index] = true;
                                      });
                                      // int week = weekname! + 7;

                                      if (index == 0) {
                                        mostRecentWeekday(
                                            DateTime.now(), weekname!);
                                        _foodcategoriesProvider.calendarlist(
                                            DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now())
                                                .toString());
                                        _foodcategoriesProvider
                                            .weeklyingredientlist(
                                                DateFormat("yyyy-MM-dd")
                                                    .format(DateTime.now())
                                                    .toString());
                                      } else if (index == 1) {
                                        mostRecentWeekday(
                                            nextmonday, weekname! + index);
                                        _foodcategoriesProvider.calendarlist(
                                            DateFormat("yyyy-MM-dd")
                                                .format(nextmonday)
                                                .toString());
                                        _foodcategoriesProvider
                                            .weeklyingredientlist(
                                                DateFormat("yyyy-MM-dd")
                                                    .format(nextmonday)
                                                    .toString());
                                      } else if (index == 2) {
                                        mostRecentWeekday(
                                            secmonday, weekname! + index);
                                        _foodcategoriesProvider.calendarlist(
                                            DateFormat("yyyy-MM-dd")
                                                .format(secmonday)
                                                .toString());
                                        _foodcategoriesProvider
                                            .weeklyingredientlist(
                                                DateFormat("yyyy-MM-dd")
                                                    .format(secmonday)
                                                    .toString());
                                      }
                                    },
                                    child: Container(
                                      height: 5.h,
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: weeklist[index]
                                              ? colorSecondry
                                              : Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(6.w),
                                      ),
                                      child: Center(
                                          child: Text(
                                        " Vecka ${weekname! + index}",
                                        style: TextStyle(
                                          color: weeklist[index]
                                              ? colorSecondry
                                              : Colors.black,
                                        ),
                                      )),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          if (!planfoodprovider.weeklyingredientListfetch)
                            SizedBox(
                              height: 80.h,
                              child: LoaderScreen(),
                            ),
                          if (planfoodprovider.weeklyingredientListfetch &&
                              planfoodprovider.weeklyingredientList.isEmpty)
                            NoDataFoundErrorScreens(
                              height: 50.h,
                            ),
                          if (planfoodprovider.weeklyingredientList.isNotEmpty)
                            IngredientListScreens(
                                callback: (value) {
                                  print(value);
                                  if (value != null) {
                                    print(value);
                                    for (int i = 0;
                                        i <
                                            planfoodprovider
                                                .weeklyingredientList.length;
                                        i++) {
                                      if (i == value) {
                                        setState(() {
                                          ingradientslistaddid =
                                              planfoodprovider
                                                  .weeklyingredientList[i]
                                                  .ingradientId
                                                  .toString();
                                          ingradientslistaddname =
                                              planfoodprovider
                                                  .weeklyingredientList[i]
                                                  .ingradientTitle
                                                  .toString();
                                        });
                                      }
                                    }
                                    setState(() {
                                      ingredientaddshow = true;
                                    });
                                  }
                                },
                                weeklyingredientList:
                                    planfoodprovider.weeklyingredientList),
                        ],
                      ),
                    ),
                    if (ingredientaddshow)
                      Center(
                        child: AddIngredientsforweekScreenActivity(
                          ingradientslistid: ingradientslistaddid,
                          ingradientslistname: ingradientslistaddname,
                          callback: (value) async {
                            setState(() {
                              ingredientaddshow = false;
                            });
                            await _foodcategoriesProvider.weeklyingredientlist(
                                DateFormat("yyyy-MM-dd")
                                    .format(startdate!)
                                    .toString());
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),
    );
  }

  _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text(
              "Är du säker på att du vill ta bort måltiden ur matplanen"),
          //'Are you sure you want to delete food plan ingredients.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nej'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ja'),
              onPressed: () {
                delete(id);
              },
            ),
          ],
        );
      },
    );
  }
}
