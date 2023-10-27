import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/planprovider.dart';
import 'package:halsogourmet/screens/mealplan/ingredientlist.dart';
import 'package:halsogourmet/screens/myrefrigerator/addingredients.dart';
import 'package:halsogourmet/screens/myrefrigerator/addingredientsforweek.dart';
import 'package:halsogourmet/screens/myrefrigerator/editingredients.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({
    // super.key
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO: implement initState
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
      print(startdate!);
      //await planfoodprovider.finalcalenderList();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      for (int i = 0; i < check.length; i++) {
        if (check[i]) {
          await _foodcategoriesProvider.calendarlist(DateFormat("yyyy-MM-dd")
              .format(startdate!.add(Duration(days: i)))
              .toString());
        }
      }
    } else {
      DialogHelper.showFlutterToast(strMsg: response['error']);
    }
    Navigator.pop(context);
  }

  String ingradientslistaddid = '';
  String ingradientslistaddname = '';

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
              return Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected
                  ? InternetNotAvailable()
                  : Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  height: 5.h,
                                  //color: Colors.yellow,

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
                                              _foodcategoriesProvider
                                                  .calendarlist(DateFormat(
                                                          "yyyy-MM-dd")
                                                      .format(DateTime.now())
                                                      .toString());
                                              _foodcategoriesProvider
                                                  .weeklyingredientlist(
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(
                                                              DateTime.now())
                                                          .toString());
                                            } else if (index == 1) {
                                              mostRecentWeekday(nextmonday,
                                                  weekname! + index);
                                              _foodcategoriesProvider
                                                  .calendarlist(
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
                                              _foodcategoriesProvider
                                                  .calendarlist(
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
                                if (!ingredientsshow)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Datum",
                                        style: Style_File.title.copyWith(
                                            color: colorBlack, fontSize: 18.sp),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                if (!ingredientsshow)
                                  Container(
                                    height: 12.h,
                                    //color: Colors.yellow,
                                    child: ListView.builder(
                                        itemCount: 7,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(2.h),
                                            child: InkWell(
                                              onTap: () {
                                                for (int i = 0;
                                                    i < check.length;
                                                    i++) {
                                                  setState(() {
                                                    check[i] = false;
                                                  });
                                                }
                                                setState(() {
                                                  check[index] = true;
                                                });
                                                weekNumbers(startdate!.add(
                                                    Duration(days: index)));

                                                _foodcategoriesProvider
                                                    .calendarlist(
                                                  DateFormat(
                                                    "yyyy-MM-dd",
                                                  )
                                                      .format(
                                                        startdate!.add(Duration(
                                                            days: index)),
                                                      )
                                                      .toString(),
                                                );
                                                _foodcategoriesProvider
                                                    .weeklyingredientlist(
                                                        DateFormat(
                                                  "yyyy-MM-dd",
                                                )
                                                            .format(startdate!
                                                                .add(Duration(
                                                                    days:
                                                                        index)))
                                                            .toString());
                                              },
                                              child: Container(
                                                height: 10.h,
                                                width: 4.2.h,
                                                decoration: BoxDecoration(
                                                  color: check[index]
                                                      ? colorSecondry
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.w),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 1.5.h),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          DateFormat('EE', "sv")
                                                              .format(startdate!
                                                                  .add(new Duration(
                                                                      days:
                                                                          index)))
                                                              .toString(),
                                                          style: Style_File
                                                              .title
                                                              .copyWith(
                                                                  color: check[
                                                                          index]
                                                                      ? colorWhite
                                                                      : Colors
                                                                          .black,
                                                                  fontSize:
                                                                      16.sp),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.2.h),
                                                          child: Container(
                                                            height: 3.h,
                                                            width: 3.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: colorWhite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.h),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                startdate!
                                                                    .add(Duration(
                                                                        days:
                                                                            index))
                                                                    .day
                                                                    .toString(),
                                                                style: Style_File.title.copyWith(
                                                                    color: check[
                                                                            index]
                                                                        ? colorSecondry
                                                                        : Colors
                                                                            .black,
                                                                    fontSize:
                                                                        16.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                               
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          ingredientsshow = false;
                                          cooksshow = true;
                                        });
                                      },
                                      child: Container(
                                        width: 100.w / 2.5,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.w),
                                            border: Border.all(
                                              color: cooksshow
                                                  ? colorSecondry
                                                  : colorBlack,
                                            )),
                                        child: Center(
                                          child: Text(
                                            "Måltid",
                                            style: Style_File.title.copyWith(
                                                color: cooksshow
                                                    ? colorSecondry
                                                    : colorBlack,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          ingredientsshow = true;
                                          cooksshow = false;
                                        });
                                      },
                                      child: Container(
                                        width: 100.w / 2.5,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.w),
                                            border: Border.all(
                                              color: ingredientsshow
                                                  ? colorSecondry
                                                  : colorBlack,
                                            )),
                                        child: Center(
                                          child: Text(
                                            "Ingredienser",
                                            style: Style_File.title.copyWith(
                                                color: ingredientsshow
                                                    ? colorSecondry
                                                    : colorBlack,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                if (cooksshow)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                                  Routes.addinGredientsplan)
                                              .then((value) {
                                            _foodcategoriesProvider
                                                .calendarlist(
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(startdate!)
                                                        .toString());
                                            _foodcategoriesProvider
                                                .weeklyingredientlist(
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(startdate!)
                                                        .toString());
                                          });
                                        },
                                        child: Container(
                                          width: 40.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.w),
                                              border: Border.all(
                                                  color: colorSecondry)),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 6.w,
                                                  color: colorSecondry,
                                                ),
                                                Text(
                                                  "Lägg till Ingredienser",
                                                  style: Style_File.title
                                                      .copyWith(
                                                          color: colorSecondry,
                                                          fontSize: 14.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                if (cooksshow &&
                                    planfoodprovider.calendarList.length == 0)
                                  NoDataFoundErrorScreens(
                                    height: 50.h,
                                  ),
                                if (cooksshow)
                                  Container(
                                    child: ListView.builder(
                                        itemCount: planfoodprovider
                                            .calendarList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      planfoodprovider
                                                          .calendarList[index]
                                                          .foodtypeName!,
                                                      style: Style_File.title
                                                          .copyWith(
                                                              color: colorBlack,
                                                              fontSize: 16.sp),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(
                                                    itemCount: planfoodprovider
                                                        .calendarList[index]
                                                        .items!
                                                        .length,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                        top: 2.h, bottom: 2.h),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, indexs) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.all(1.h),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (planfoodprovider
                                                                .calendarList[
                                                                    index]
                                                                .items![indexs]
                                                                .recipes!
                                                                .isNotEmpty)
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                Routes
                                                                    .foodDetails,
                                                                arguments: {
                                                                  StringFile.foodtypeId: planfoodprovider
                                                                      .calendarList[
                                                                          index]
                                                                      .items![
                                                                          indexs]
                                                                      .recipeId
                                                                      .toString(),
                                                                  StringFile
                                                                      .foodtypeName: planfoodprovider
                                                                          .calendarList[
                                                                              index]
                                                                          .items![
                                                                              indexs]
                                                                          .recipes![
                                                                              0]
                                                                          .title ??
                                                                      '',
                                                                  StringFile.quantity: planfoodprovider
                                                                      .calendarList[
                                                                          index]
                                                                      .items![
                                                                          indexs]
                                                                      .quantity
                                                                      .toString(),
                                                                },
                                                              ).then(
                                                                  (value) => {
                                                                        //  _favoriterecipeProvider.foodcategorylist()
                                                                        // planfoodprovider
                                                                        //     .finalcalenderList[index]
                                                                        //     .calendarrecipes![indexs],
                                                                        planfoodprovider.calendarlist(DateFormat("yyyy-MM-dd")
                                                                            .format(startdate!)
                                                                            .toString()),
                                                                        _foodcategoriesProvider.weeklyingredientlist(DateFormat("yyyy-MM-dd")
                                                                            .format(startdate!)
                                                                            .toString()),
                                                                      });
                                                          },
                                                          child: Slidable(
                                                            actionPane:
                                                                SlidableDrawerActionPane(),
                                                            actionExtentRatio:
                                                                0.25,
                                                            secondaryActions: <
                                                                Widget>[
                                                              IconSlideAction(
                                                                caption:
                                                                    "Delete",
                                                                onTap: () {
                                                                  _dialogBuilder(
                                                                      context,
                                                                      planfoodprovider
                                                                          .calendarList[
                                                                              index]
                                                                          .items![
                                                                              indexs]
                                                                          .id
                                                                          .toString());
                                                                },
                                                                iconWidget:
                                                                    Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 6.h,
                                                                ),
                                                                // color: colorlightGrey,
                                                              ),
                                                            ],
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: indexs %
                                                                                  2 ==
                                                                              0
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black,
                                                                          blurRadius:
                                                                              .5,
                                                                        ),
                                                                      ],
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(8
                                                                              .w),
                                                                          bottomLeft: Radius.circular(8
                                                                              .w),
                                                                          bottomRight: Radius.circular(4
                                                                              .w),
                                                                          topRight:
                                                                              Radius.circular(4.w))),
                                                              child: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                children: [
                                                                  Positioned(
                                                                    top: 1.h,
                                                                    left: -4.w,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          10.h,
                                                                      width:
                                                                          10.h,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: colorGrey,
                                                                          // borderRadius:
                                                                          //     BorderRadius.circular(4.w),

                                                                          image: planfoodprovider.calendarList[index].items![indexs].type!.toLowerCase() == "ingradient"
                                                                              ? DecorationImage(
                                                                                  image: (
                                                                                          // planfoodprovider.calendarList[index].items![indexs].recipes
                                                                                          planfoodprovider.calendarList[index].items![indexs].ingradient!.isEmpty || planfoodprovider.calendarList[index].items![indexs].ingradient![0].image!.isEmpty)
                                                                                      ? AssetImage(
                                                                                          ImageFile.meat,
                                                                                        )
                                                                                      : NetworkImage(APIURL.imageurl + planfoodprovider.calendarList[index].items![indexs].ingradient![0].image!.toString()) as ImageProvider,
                                                                                  fit: BoxFit.fill)
                                                                              : DecorationImage(
                                                                                  image: (
                                                                                          // planfoodprovider.calendarList[index].items![indexs].recipes
                                                                                          planfoodprovider.calendarList[index].items![indexs].recipes!.isEmpty || planfoodprovider.calendarList[index].items![indexs].recipes![0].recipeimage!.isEmpty)
                                                                                      ? AssetImage(
                                                                                          ImageFile.meat,
                                                                                        )
                                                                                      : NetworkImage(APIURL.imageurl + planfoodprovider.calendarList[index].items![indexs].recipes![0].recipeimage![0].image.toString()) as ImageProvider,
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
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            20.w,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              12.h,
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsets.only(
                                                                                top: 1.h,
                                                                                bottom: 1.h,
                                                                                left: 1.h,
                                                                                right: 1.h),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 30.w,
                                                                                        child: Text(planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].title! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].title.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: Style_File.title.copyWith(fontSize: 16.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                                                                                      ),
                                                                                      // SizedBox(
                                                                                      //   width:
                                                                                      //       10.w,
                                                                                      // ),
                                                                                      Spacer(),
                                                                                      Icon(
                                                                                        Icons.local_fire_department_rounded,
                                                                                        size: 25,
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                      Flexible(
                                                                                        child: Text("${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].calorie! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].calorie.toString()} kcal ", style: Style_File.title.copyWith(fontSize: 14.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Protein",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: Colors.grey),
                                                                                        ),
                                                                                        Text(
                                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].protein! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].protein.toString()} g",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 3.w,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 2.5.h,
                                                                                      width: .5.w,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 3.w,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Kolhydrater",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: Colors.grey),
                                                                                        ),
                                                                                        Text(
                                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].carbohydrate! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].carbohydrate.toString()} g",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 3.w,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 2.5.h,
                                                                                      width: .5.w,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 3.w,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Fett",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: Colors.grey),
                                                                                        ),
                                                                                        Text(
                                                                                          "${planfoodprovider.calendarList[index].items![indexs].recipes!.isNotEmpty ? planfoodprovider.calendarList[index].items![indexs].recipes![0].fat! : planfoodprovider.calendarList[index].items![indexs].ingradient![0].fat.toString()} g",
                                                                                          //  "${((int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString()) + int.parse(planfoodprovider.finalcalenderList[index].calendarrecipes![indexs].recipes![0].prepareTime.toString())).toString())} min",
                                                                                          style: Style_File.title.copyWith(fontSize: 13.sp, color: indexs % 2 == 0 ? Colors.white : Colors.black),
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
                                                        ),
                                                      );
                                                    }),
                                                Center(
                                                  child: Text(
                                                    "${planfoodprovider.calendarList[index].calorie} kcal kalori . ",
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: Colors.grey,
                                                            fontSize: 15.sp),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    "${planfoodprovider.calendarList[index].protein} g Protein . ${planfoodprovider.calendarList[index].carbohydrate} g  Kolhydrater . ${planfoodprovider.calendarList[index].fat} g Fett",
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: Colors.grey,
                                                            fontSize: 15.sp),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ),

                                // if (!ingredientsshow)
                                //   Center(
                                //     child: Text(
                                //       "82 g Kolhydrater . 17 g Fett. 52 g  Protein",
                                //       style: Style_File.title.copyWith(color: Colors.grey),
                                //     ),
                                //   ),

                                // if (ingredientsshow)
                                //   Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       InkWell(
                                //         onTap: () {
                                //           Navigator.pushNamed(
                                //                   context, Routes.myrefrigeratoringredients)
                                //               .then((value) {
                                //             _foodcategoriesProvider.weeklyingredientlist(
                                //                 DateFormat("yyyy-MM-dd")
                                //                     .format(startdate!)
                                //                     .toString());
                                //           });
                                //         },
                                //         child: Container(
                                //           width: 40.w,
                                //           height: 4.h,
                                //           decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(2.w),
                                //               border: Border.all(color: colorSecondry)),
                                //           child: Row(
                                //             mainAxisAlignment: MainAxisAlignment.center,
                                //             children: [
                                //               Icon(
                                //                 Icons.add,
                                //                 size: 6.w,
                                //                 color: colorSecondry,
                                //               ),
                                //               Flexible(
                                //                 child: Text(
                                //                   //Add Refrigerator
                                //                   "Lägg till kylskåp",
                                //                   style: Style_File.title.copyWith(
                                //                       color: colorSecondry,
                                //                       fontSize: 14.sp),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),

                                if (ingredientsshow &&
                                    planfoodprovider
                                        .weeklyingredientList.isEmpty)
                                  NoDataFoundErrorScreens(
                                    height: 50.h,
                                  ),

                                if (ingredientsshow &&
                                    planfoodprovider
                                        .weeklyingredientList.isNotEmpty)
                                  IngredientListScreens(
                                      callback: (value) {
                                        if (value != null) {
                                          for (int i = 0;
                                              i <
                                                  planfoodprovider
                                                      .weeklyingredientList
                                                      .length;
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
                                          planfoodprovider.weeklyingredientList)
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
                                  await _foodcategoriesProvider
                                      .weeklyingredientlist(
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
          title: const Text('Radera'),
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
