import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/screens/package/consumable_store.dart';
import 'package:halsogourmet/screens/package/paymetutils.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// TODO: Please Add your iOS product ID here

class Payment extends StatefulWidget {
  final PackageData packagedata;

  const Payment({
    super.key,
    required this.packagedata,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  bool showpop = false;
  bool paymentbutton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), child: AppBarScreens()),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Padding(
              padding: EdgeInsets.all(2.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Välj din prenumerationsplan",
                      //"Choose Your Subscription Plan",
                      style: Style_File.title
                          .copyWith(color: colorBlack, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    ListView.builder(
                        itemCount: widget.packagedata.prices!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                            child: InkWell(
                              onTap: () async {
                                //  Navigator.pushNamed(context, Routes.billingaddress);

                                if (paymentbutton) {
                                  setState(() {
                                    paymentbutton = false;
                                  });
                                  // if (Platform.isAndroid) {
                                  // await PaymentUtils().makePayment(
                                  //     ((widget.packagedata.prices![index]
                                  //                 .perMonthPrice!) *
                                  //             (widget.packagedata.prices![index]
                                  //                 .tenure!))
                                  //         .toString(),
                                  //     ((widget.packagedata.perMonthPrice!) *
                                  //             (widget.packagedata.prices![index]
                                  //                 .tenure!))
                                  //         .toString(),
                                  //     widget.packagedata.id.toString(),
                                  //     widget.packagedata,
                                  //     widget.packagedata.prices![index],
                                  //     context);
                                  Navigator.pushNamed(
                                      context, Routes.billingaddress,
                                      arguments: {
                                        StringFile.package: widget.packagedata,
                                        StringFile.index: index
                                      });
                                  delayedNumber();
                                  setState(() {
                                    paymentbutton = true;
                                  });
                                  // } else {
                                  //   Navigator.pushNamed(
                                  //       context, Routes.paymetIosuiScreen,
                                  //       arguments: {
                                  //         StringFile.package: widget.packagedata,
                                  //         StringFile.index: index,
                                  //         StringFile.appleproductid: widget
                                  //             .packagedata
                                  //             .prices![index]
                                  //             .appleProductID
                                  //             .toString()
                                  //       }).then((value) {
                                  //     setState(() {
                                  //       paymentbutton = true;
                                  //     });
                                  //   });
                                  // }
                                }
                              },
                              child: Container(
                                height: 15.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  gradient: (index % 2 == 0)
                                      ? LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            const Color(0xFFd98ff9),
                                            const Color(0xFF9554fc),
                                          ],
                                        )
                                      : LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            const Color(0xFFf9ad96),
                                            const Color(0xFFf77795),
                                          ],
                                        ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 1.h,
                                      bottom: 1.h,
                                      left: 4.h,
                                      right: 2.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.packagedata.prices![index].tenure.toString()} Månad",
                                            //"MONTHLY",
                                            style: Style_File.title.copyWith(
                                                color: colorWhite,
                                                fontSize: 17.sp),
                                          ),
                                          // Icon(
                                          //   Icons.circle_outlined,
                                          //   color: colorBlack,
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   "${widget.packagedata.prices![index].tenure.toString()} Month",
                                              //   // "1 Month",
                                              //   style: Style_File.title
                                              //       .copyWith(color: colorBlack),
                                              // ),

                                              Text(
                                                "${((widget.packagedata.prices![index].perMonthPrice!) * (widget.packagedata.prices![index].tenure!)).toString()} kr",
                                                // "1 Month",
                                                style: Style_File.title
                                                    .copyWith(
                                                        color: colorBlack,
                                                        fontSize: 18.sp),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              if (widget.packagedata
                                                      .prices![index].discount
                                                      .toString() !=
                                                  '0')
                                                Text(
                                                  "${((widget.packagedata.perMonthPrice!) * (widget.packagedata.prices![index].tenure!)).toString()} kr",
                                                  style: Style_File.title
                                                      .copyWith(
                                                          color: colorGrey,
                                                          fontSize: 15.sp,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              if (widget
                                                      .packagedata
                                                      .prices![index]
                                                      .discountType!
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'flat')
                                                if (widget.packagedata
                                                        .prices![index].discount
                                                        .toString() !=
                                                    '0')
                                                  Text(
                                                    "${widget.packagedata.prices![index].discount.toString()} per/month flat",
                                                    style: Style_File.subtitle
                                                        .copyWith(
                                                      color: colorBlack,
                                                    ),
                                                  ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              if (widget
                                                      .packagedata
                                                      .prices![index]
                                                      .discountType
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'percentage')
                                                Text(
                                                  "${widget.packagedata.prices![index].discount.toString()} %",
                                                  style: Style_File.subtitle
                                                      .copyWith(
                                                    color: colorBlack,
                                                  ),
                                                ),
                                            ],
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
                    if (Platform.isIOS)
                      Text(
                        "  • Payment will be charged to iTunes Account at confirmation of purchase. \n  • Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. \n  • Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. \n  • Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. \n  • No cancellation of the current subscription is allowed during active subscription period. \n  • Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.",
                        style: Style_File.subtitle.copyWith(fontSize: 14.sp),
                        // textAlign: TextAlign.center,
                      ),
                    if (Platform.isIOS)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.webViewScreensShow,
                                    arguments: {
                                      StringFile.url:
                                          "https://halsogourmet.com/terms-conditions/"
                                    });
                              },
                              child: Text(
                                "Terms of Use ",
                                style: Style_File.subtitle
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.webViewScreensShow,
                                    arguments: {
                                      StringFile.url:
                                          "https://halsogourmet.com/privacy-policy/"
                                    });
                              },
                              child: Text(
                                "Privacy policy",
                                style: Style_File.subtitle
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
    );
  }

  Future delayedNumber() async {
    await Future.delayed(const Duration(seconds: 10)).whenComplete(() {
      setState(() {
        paymentbutton = true;
      });
    });
  }
}
