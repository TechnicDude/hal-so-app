import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/profileprovider.dart';
import 'package:halsogourmet/screens/profile/editprofile.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/buttonwidgetloader.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/userallreadsubscribe.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/style_file.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileUserProvider _profileuserProvider = ProfileUserProvider();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();

    _profileuserProvider =
        Provider.of<ProfileUserProvider>(context, listen: false);
    _profileuserProvider.profileuserlist(MyApp.userid ?? '');
  }

  String _error = '';

  bool isLoading = false;

  bool setvalue = false;
  bool showsubscribeuser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: colorBlack,
          ),
          backgroundColor: colorSecondry,
          elevation: 0,
        ),
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? InternetNotAvailable()
            : Consumer<ProfileUserProvider>(
                builder: ((context, profileUserProvider, child) {
                print(profileUserProvider.profileuserList);

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: colorSecondry,
                              //  borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 1.h, left: 3.h, right: 2.h),
                              child: profileUserProvider
                                          .profileuserList.length !=
                                      0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                          child: GestureDetector(
                                            onTap: () {}, // Image tapped
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: 5.h,
                                              backgroundImage: profileUserProvider
                                                          .profileuserList[0]
                                                          .userAvatar !=
                                                      null
                                                  ? NetworkImage(
                                                      APIURL.imageurl +
                                                          profileUserProvider
                                                              .profileuserList[
                                                                  0]
                                                              .userAvatar!
                                                      // .replaceAll(
                                                      //     "public/", ""),
                                                      )
                                                  : AssetImage(
                                                      ImageFile.profile,
                                                    ) as ImageProvider,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    profileUserProvider
                                                            .profileuserList
                                                            .isNotEmpty
                                                        ? profileUserProvider
                                                                .profileuserList[
                                                                    0]
                                                                .firstName ??
                                                            ''
                                                        : '',
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: colorWhite,
                                                            fontSize: 18.sp)),
                                                Text(' '),
                                                Text(
                                                    profileUserProvider
                                                            .profileuserList
                                                            .isNotEmpty
                                                        ? profileUserProvider
                                                                .profileuserList[
                                                                    0]
                                                                .lastName ??
                                                            ''
                                                        : '',
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: colorWhite,
                                                            fontSize: 18.sp)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Text(
                                              profileUserProvider
                                                      .profileuserList
                                                      .isNotEmpty
                                                  ? profileUserProvider
                                                          .profileuserList[0]
                                                          .emailAddress ??
                                                      ''
                                                  : '',
                                              style: Style_File.subtitle
                                                  .copyWith(
                                                      color: colorWhite,
                                                      fontSize: 14.sp),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            profileUserProvider
                                                    .profileuserList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          Routes.editProfile,
                                                          arguments: {
                                                            StringFile
                                                                    .profileuserdata:
                                                                profileUserProvider
                                                                    .profileuserList,
                                                          }).then((value) {
                                                        _profileuserProvider
                                                            .profileuserlist(
                                                                MyApp.userid ??
                                                                    '');
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 4.h,
                                                      width: 18.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Redigera profil",
                                                            style: Style_File
                                                                .subtitle
                                                                .copyWith(
                                                                    color:
                                                                        colorBlack,
                                                                    fontSize:
                                                                        16.sp),
                                                          ),
                                                          SizedBox(
                                                            width: 1.w,
                                                          ),
                                                          Icon(
                                                            Icons.edit,
                                                            size: 2.5.h,
                                                            color:
                                                                colorSecondry,
                                                          ),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: colorWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.w),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: colorWhite,
                                                              blurRadius: 1.h,
                                                            ),
                                                          ]),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 3.h, left: 1.5.h, right: 1.5.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.lock_outline,
                                          size: 25.0,
                                          color: colorSecondry,
                                        ),
                                        label: Text("Ändra lösenord",
                                            style: Style_File.title)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  Routes.changePassword);
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 25.0,
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.monetization_on_outlined,
                                          size: 25.0,
                                          color: colorSecondry,
                                        ),
                                        label: Text("Mitt paket",
                                            style: Style_File.title)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (MyApp.subscriptioncheck) {
                                                setState(() {
                                                  showsubscribeuser = true;
                                                });
                                              } else {
                                                Navigator.pushNamed(context,
                                                    Routes.packageScreen);
                                              }
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 25.0,
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     TextButton.icon(
                                //         onPressed: () {},
                                //         icon: Icon(
                                //           Icons.receipt_long,
                                //           size: 25.0,
                                //           color: colorSecondry,
                                //         ),
                                //         label: Text("Fakturaadress",
                                //             //"Billing Address",
                                //             style: Style_File.title)),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.end,
                                //       children: [
                                //         IconButton(
                                //             onPressed: () {
                                //               // Navigator.pushNamed(
                                //               //     context, Routes.billingaddress);
                                //             },
                                //             icon: Icon(
                                //               Icons.arrow_forward_ios,
                                //               size: 25.0,
                                //               color: Colors.grey,
                                //             )),
                                //       ],
                                //     ),
                                //   ],
                                // ),

                                // const Divider(
                                //   color: Colors.grey,
                                //   thickness: 1,
                                // ),
                                if (MyApp.subscriptionapplepay)
                                  if (MyApp.isRecurring)
                                    if (!MyApp.subscriptionDeleted)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          !isLoading
                                              ? TextButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons
                                                        .remove_shopping_cart_outlined,
                                                    size: 25.0,
                                                    color: colorSecondry,
                                                  ),
                                                  label: Text(
                                                      "prenumeration avslutad", // UNSUBSCRIBE
                                                      style: Style_File.title))
                                              : ButtonWidgetLoader(),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.INFO,
                                                  btnOkColor: colorPrimary,
                                                  borderSide: BorderSide(
                                                      color: colorSecondry,
                                                      width: 0.1.h),
                                                  buttonsBorderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2)),
                                                  headerAnimationLoop: false,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  // title: 'Delete Account',
                                                  title:
                                                      'Prenumeration avslutad',
                                                  desc:
                                                      'Är du säker på att avsluta din prenumeration?',
                                                  //'Are you sure want to delete your account?',
                                                  showCloseIcon: true,
                                                  // btnCancelOnPress: () {
                                                  //   Navigator.pop(context);
                                                  // },
                                                  btnOkOnPress: () {
                                                    setState(() {
                                                      _error = '';
                                                    });
                                                    if (isLoading) {
                                                      return;
                                                    }
                                                    deletesub();
                                                  },
                                                )..show();
                                              },
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25.0,
                                                color: Colors.grey,
                                              )),
                                        ],
                                      ),
                                if (MyApp.subscriptionapplepay)
                                  if (MyApp.isRecurring)
                                    if (!MyApp.subscriptionDeleted)
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    !isLoading
                                        ? TextButton.icon(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.delete,
                                              size: 25.0,
                                              color: colorSecondry,
                                            ),
                                            label: Text(
                                                "Avsluta abonnemang", // UNSUBSCRIBE
                                                style: Style_File.title))
                                        : ButtonWidgetLoader(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.INFO,
                                                btnOkColor: colorPrimary,
                                                borderSide: BorderSide(
                                                    color: colorSecondry,
                                                    width: 0.1.h),
                                                buttonsBorderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(2)),
                                                headerAnimationLoop: false,
                                                animType: AnimType.BOTTOMSLIDE,
                                                // title: 'Delete Account',
                                                title: 'Radera konto',
                                                desc:
                                                    'bortÄr du säker på att du vill ta  ditt konto?',
                                                //'Are you sure want to delete your account?',
                                                showCloseIcon: true,
                                                // btnCancelOnPress: () {
                                                //   Navigator.pop(context);
                                                // },
                                                btnOkOnPress: () {
                                                  setState(() {
                                                    _error = '';
                                                  });
                                                  if (isLoading) {
                                                    return;
                                                  }

                                                  deleteAccount(
                                                      profileUserProvider
                                                          .profileuserList[0].id
                                                          .toString(),
                                                      context);
                                                },
                                              )..show();
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 25.0,
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.logout_outlined,
                                          size: 25.0,
                                          color: colorSecondry,
                                        ),
                                        label: Text("Logga ut",
                                            style: Style_File.title)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.INFO,
                                                btnOkColor: colorSecondry,
                                                borderSide: BorderSide(
                                                    color: colorSecondry,
                                                    width: 0.1.h),
                                                buttonsBorderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(2)),
                                                headerAnimationLoop: false,
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: 'Logga ut',
                                                desc:
                                                    'Är du säker på att du vill logga ut från Halsogourmet?',
                                                showCloseIcon: true,
                                                // btnCancelOnPress: () {
                                                //   Navigator.pop(context);
                                                // },
                                                btnOkOnPress: () {
                                                  if (MyApp.userid == null) {
                                                    Navigator.pushNamed(context,
                                                        Routes.loginScreen);
                                                  } else {
                                                    MyApp.logout();

                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pushNamedAndRemoveUntil(
                                                            Routes.loginScreen,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }
                                                },
                                              )..show();
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 25.0,
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showsubscribeuser)
                      Center(child: UserAllReadSubscribe(
                        callback: (value) {
                          setState(() {
                            showsubscribeuser = false;
                          });
                        },
                      )),
                  ],
                );
              })));
  }

  Future deletesub() async {
    final String url =
        'https://api.stripe.com/v1/subscriptions/${MyApp.stripeSubscriptionId}';
    print(url);
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    try {
      if (response.statusCode == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.splashScreen, (route) => false);
        DialogHelper.showFlutterToast(
            strMsg: "avslutad prenumeration framgångsrikt");
        return json.decode(response.body);
      } else {
        print(json.decode(response.body));
        throw 'Det gick inte att registrera sig som kund.';
      }
    } catch (e) {}
  }
}

Widget accountTextUI(
  BuildContext context,
  IconData icon1,
  String title,
  IconData icon2,
  String navigation, {
  Object? arguments,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton.icon(
          onPressed: () {},
          icon: Icon(
            icon1,
            size: 25.0,
            color: colorSecondry,
          ),
          label: Text(title, style: Style_File.title)),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () => navigation,
              //onPressed: () {},
              icon: Icon(
                icon2,
                size: 25.0,
                color: Colors.grey,
              )),
        ],
      ),
    ],
  );
}

deleteAccount(String ids, BuildContext context) async {
  var data = {
    'id': ids,
  };

  LoginApi registerresponse = LoginApi(data);
  final response = await registerresponse.deleteaccount(ids);
  if (response['status'].toString() == "success") {
    MyApp.logout();

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        Routes.loginScreen, (Route<dynamic> route) => false);
    DialogHelper.showFlutterToast(strMsg: response['message'].toString());
  } else {
    DialogHelper.showFlutterToast(strMsg: response['message'].toString());
  }
}
