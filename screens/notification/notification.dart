import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/notificationprovider.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/networkimageload.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationScreen extends StatefulWidget {
//  final String text;
  const NotificationScreen({
    super.key,
    //  required this.text,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationProvider notificationProvider = NotificationProvider();
  bool searchshow = false;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.notificationlist();
    //widget.text);

    super.initState();
  }

  String searchString = '';

  Future delete(String id) async {
    LikeApi likeApi = LikeApi();
    final response = await likeApi.deleterefrigeratoringradients(id);
    if (response['status'] == "success") {
      await notificationProvider.notificationlist();
      DialogHelper.showFlutterToast(strMsg: response['message']);
      Navigator.pop(context);
    } else {
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
            text: "Notiser",
          )),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
              if (notificationProvider.datanotfound) {
                if (notificationProvider.notificationList.isNotEmpty) {
                  return Column(
                    children: [
                      ListView.builder(
                          itemCount:
                              notificationProvider.notificationList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 2.h, left: 2.h, right: 2.h),
                              child: InkWell(
                                onTap: () async {
                                  if (notificationProvider
                                          .notificationList[index].path ==
                                      "package") {
                                    Navigator.pushNamed(
                                            context, Routes.packageScreen)
                                        .then((value) {
                                      notificationProvider.notificationlist();
                                    });
                                  }
                                  LikeApi likeApi = LikeApi();
                                  final response = await likeApi
                                      .notificationread(notificationProvider
                                          .notificationList[index].id
                                          .toString());
                                },
                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[
                                    Container(
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(1,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: IconSlideAction(
                                        // caption: "Edit",
                                        onTap: () {
                                          _dialogBuilder(
                                              context,
                                              notificationProvider
                                                  .notificationList[index].id
                                                  .toString());
                                        },
                                        iconWidget: Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 4.h,
                                          ),
                                        ),
                                        // color: Colors.green,
                                      ),
                                    ),
                                  ],
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: notificationProvider
                                                      .notificationList[index]
                                                      .readStatus
                                                      .toString() ==
                                                  "false"
                                              ? Colors.grey.withOpacity(.2)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(1,
                                                  2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(0.2.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 6.h,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.w),
                                                  child: Image.asset(
                                                    "assets/images/logo.png",
                                                  ),

                                                  // child: NetWorkImageScreen(
                                                  //   image: APIURL.imageurl +
                                                  //       (notificationProvider
                                                  //           .notificationList[index]
                                                  //           .image!),
                                                  // )
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      notificationProvider
                                                          .notificationList[
                                                              index]
                                                          .title
                                                          .toString(),

                                                      // 'Facebook Gillar notification center',
                                                      style: Style_File.title
                                                          .copyWith(
                                                              color:
                                                                  colorBlack),
                                                    ),
                                                    Text(
                                                      notificationProvider
                                                          .notificationList[
                                                              index]
                                                          .subTitle
                                                          .toString(),
                                                      //  'The base use cases for GetSocial Notifications API is to build notify',
                                                      style: Style_File.subtitle
                                                          .copyWith(
                                                              color:
                                                                  colorBlack),
                                                    ),
                                                    SizedBox(
                                                      height: 1.0.h,
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'yyyy-MM-dd  kk:mm')
                                                          .format(DateTime.parse(
                                                              notificationProvider
                                                                  .notificationList[
                                                                      index]
                                                                  .createdAt
                                                                  .toString()))
                                                          .toString(),
                                                      //  'The base use cases for GetSocial Notifications API is to build notify',
                                                      style: Style_File.subtitle
                                                          .copyWith(
                                                              color: colorGrey,
                                                              fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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

  _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Radera'), // delete
          content: const Text(
              'Är du säker på att du vill tömma kylskåpets ingredienser?'),
          //   'Are you sure you want to delete refrigerator ingredients.
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
