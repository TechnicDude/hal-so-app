import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/myaddingredientsprovider.dart';
import 'package:halsogourmet/screens/myrefrigerator/addingredients.dart';
import 'package:halsogourmet/screens/myrefrigerator/editingredients.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyrefrigeratoringredientsScreenActivity extends StatefulWidget {
  const MyrefrigeratoringredientsScreenActivity({super.key});

  @override
  State<MyrefrigeratoringredientsScreenActivity> createState() =>
      _MyrefrigeratoringredientsScreenActivityState();
}

class _MyrefrigeratoringredientsScreenActivityState
    extends State<MyrefrigeratoringredientsScreenActivity> {
  bool adddatashow = false;
  bool editdatashow = false;
  int contextindex = 0;
  MyaddingredientsProvider _myaddingredientsProvider =
      MyaddingredientsProvider();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _myaddingredientsProvider =
        Provider.of<MyaddingredientsProvider>(context, listen: false);
    fetchdata();

    super.initState();
  }

  fetchdata() async {
    await _myaddingredientsProvider.ingradientslist();
    await _myaddingredientsProvider.myingradientsdatalist();
  }

  Future delete(String id) async {
    LikeApi likeApi = LikeApi();
    final response = await likeApi.deleterefrigeratoringradients(id);
    if (response['status'] == "success") {
      await _myaddingredientsProvider.myingradientsdatalist();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      Navigator.pop(context);
    } else {
      await _myaddingredientsProvider.myingradientsdatalist();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarScreens(
          text: "I mitt kylskåp",
          //"Mina kylskåpsingredienser",
        ),
      ),
      floatingActionButton: adddatashow
          ? Container()
          : 
          
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      adddatashow = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorSecondry,
                        borderRadius: BorderRadius.circular(2.w)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          Text(
                            'Lägg till ingredienser',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.allrecipe,
                        arguments: {StringFile.filtteroption: "true"});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2.w)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Sök",
                            //'Search',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   left: 10,
                //   bottom: 20,
                //   child: FloatingActionButton.extended(
                //     onPressed: () {},
                //     label: const Text('Tillsätt ingredienser'),
                //     icon: const Icon(Icons.add_circle),
                //     backgroundColor: colorSecondry,
                //   ),
                // ),
                // Positioned(
                //   bottom: 20,
                //   right: 10,
                //   child: FloatingActionButton.extended(
                //     onPressed: () {
                //       Navigator.pushNamed(context, Routes.allrecipe,
                //           arguments: {StringFile.filtteroption: "true"});
                //     },
                //     label: const Text('Submit'),
                //     // icon: const Icon(Icons.add_circle),
                //     backgroundColor: Colors.red,
                //   ),
                // ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Consumer<MyaddingredientsProvider>(
              builder: (context, myaddingredientsProvider, child) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 2.h, left: 2.h, right: 2.h, bottom: 10.h),
                child: Stack(
                  children: [
                    if (!myaddingredientsProvider.showdata)
                      SizedBox(
                        height: 100.h,
                        child: LoaderScreen(),
                      ),
                    if (myaddingredientsProvider.showdata)
                      if (myaddingredientsProvider
                          .getrefrigeratoringradientsModelDatalist.isEmpty)
                        SizedBox(
                          height: 100.h,
                          child: NoDataFoundErrorScreens(),
                        ),
                    if (myaddingredientsProvider.showdata)
                      if (myaddingredientsProvider
                          .getrefrigeratoringradientsModelDatalist.isNotEmpty)
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: myaddingredientsProvider
                                .getrefrigeratoringradientsModelDatalist.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 2.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8.h,
                                          width: 11.w,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.w),
                                                bottomLeft:
                                                    Radius.circular(4.w)),
                                          ),

                                          // child: IconButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       contextindex = index;
                                          //       adddatashow = false;
                                          //       editdatashow = true;
                                          //     });
                                          //   },
                                          //   icon: Icon(
                                          //     Icons.edit,
                                          //     color: Colors.white,
                                          //   ),
                                          // ),

                                          child: IconSlideAction(
                                            // caption: "Edit",
                                            onTap: () {
                                              setState(() {
                                                contextindex = index;
                                                adddatashow = false;
                                                editdatashow = true;
                                              });
                                            },
                                            iconWidget: Center(
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 4.h,
                                              ),
                                            ),
                                            // color: Colors.green,
                                          ),
                                        ),
                                        Container(
                                          height: 8.h,
                                          width: 11.w,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.w),
                                                bottomLeft:
                                                    Radius.circular(4.w)),
                                          ),
                                          child: IconSlideAction(
                                            // caption: "Edit",
                                            onTap: () {
                                              _dialogBuilder(
                                                  context,
                                                  myaddingredientsProvider
                                                      .getrefrigeratoringradientsModelDatalist[
                                                          index]
                                                      .id
                                                      .toString());
                                            },
                                            iconWidget: Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 4.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 1.h, bottom: 1.h),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 90.w,
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: .5,
                                              blurRadius: .5,
                                              // offset: Offset(-.5,
                                              //     .5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 2.h,
                                            right: 2.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      myaddingredientsProvider
                                                          .getrefrigeratoringradientsModelDatalist[
                                                              index]
                                                          .ingradient!
                                                          .title!,
                                                      style: Style_File.title,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "${myaddingredientsProvider.getrefrigeratoringradientsModelDatalist[index].quantity.toString()} g",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Text(
                                                    DateFormat("dd-MM-yyyy")
                                                        .format(DateTime.parse(
                                                            myaddingredientsProvider
                                                                .getrefrigeratoringradientsModelDatalist[
                                                                    index]
                                                                .createdAt!))
                                                        .toString(),
                                                    style: Style_File.subtitle,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                    SizedBox(
                      height: 2.h,
                    ),
                    if (adddatashow)
                      Center(
                        child: AddIngredientsScreenActivity(
                            callback: (value) {
                              setState(() {
                                adddatashow = false;
                                myaddingredientsProvider
                                    .myingradientsdatalist();
                              });
                            },
                            ingradientslist:
                                myaddingredientsProvider.ingradientsModellist),
                      ),
                    if (editdatashow)
                      Center(
                        child: EditIngredientsScreenActivity(
                            callback: (value) {
                              setState(() {
                                adddatashow = false;
                                editdatashow = false;
                                myaddingredientsProvider
                                    .myingradientsdatalist();
                              });
                            },
                            ingradientId: myaddingredientsProvider
                                .getrefrigeratoringradientsModelDatalist[
                                    contextindex]
                                .ingradientId
                                .toString(),
                            Id: myaddingredientsProvider
                                .getrefrigeratoringradientsModelDatalist[
                                    contextindex]
                                .id
                                .toString(),
                            quantity: myaddingredientsProvider
                                .getrefrigeratoringradientsModelDatalist[
                                    contextindex]
                                .quantity
                                .toString(),
                            ingradientslist: myaddingredientsProvider
                                .getrefrigeratoringradientsModelDatalist[
                                    contextindex]
                                .ingradient!
                                .title!),
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
          title: const Text('Radera'), // delete
          content: const Text(
              "Är du säker på att du vill tömma kylskåpets ingredienser?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
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
