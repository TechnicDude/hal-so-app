import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/foodcategoryprovider.dart';
import 'package:halsogourmet/provider/packageprovider.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';
import 'package:halsogourmet/utils/nodatafounerror.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PackageScreen extends StatefulWidget {
  bool datanotfound = false;
  PackageScreen({
    super.key,
  });

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  PackageProvider packageProvider = PackageProvider();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    packageProvider = Provider.of<PackageProvider>(context, listen: false);
    packageProvider.packagedatalist();

    // getalldata();
    print("userid ${MyApp.userid}");
    print(MyApp.userid);
    print(MyApp.AUTH_TOKEN_VALUE);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), child: AppBarScreens()),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Consumer<PackageProvider>(
              builder: (context, packageProvider, child) {
              if (packageProvider.packagedataList.isNotEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Bli premiummedlem",
                      // "Get Subscription Package Plan",
                      style: Style_File.title
                          .copyWith(color: colorBlack, fontSize: 18.sp),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(),
                        height: 25.h,
                        width: 40.h,
                        child: Image.asset(
                          ImageFile.package,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ListView.builder(
                        itemCount: packageProvider.packagedataList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 85.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.h),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                      gradient: (index / 2 == 0)
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
                                      padding: EdgeInsets.all(1.h),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.pushNamed(
                                          //     context, Routes.payment,
                                          //     arguments: {
                                          //       StringFile.package:
                                          //           packageProvider
                                          //               .packagedataList[index],
                                          //     });

                                          Navigator.pushNamed(context,
                                              Routes.webViewScreensShowPayment,
                                              arguments: {
                                                StringFile.url:
                                                    // "https://payment.halsogourmet.com?token=eyJpZCI6NjUsInVzZXJJZCI6IkhTQTIzNzU1MDIiLCJlbWFpbEFkZHJlc3MiOiJyaXdvbW9uNDgxQHJpZHRlYW0uY29tIiwidXNlclR5cGUiOiJDdXN0b21lciIsInVzZXJSb2xlIjoiQ3VzdG9tZXIiLCJleHBpcmVzSW4iOjE2OTE3MzgzMzAsImlhdCI6MTY4OTc3MTU1M30.SIUdG1KvPqyIWyVPTcFPPPlK8sVO3FiEmZVdK4-BQ68"
                                                    // "https://halsogourmet.com",
                                                    "https://payment.halsogourmet.com/?token=${MyApp.AUTH_TOKEN_VALUE}&priceId=1"
                                              });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.stars,
                                                  color: colorWhite,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Expanded(
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      Text(
                                                        packageProvider
                                                            .packagedataList[
                                                                index]
                                                            .title!,
                                                        style: Style_File.title
                                                            .copyWith(
                                                                color:
                                                                    colorWhite),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (packageProvider
                                                    .packagedataList[index]
                                                    .prices!
                                                    .isEmpty)
                                                  Text(
                                                    "Free",
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: colorWhite),
                                                  ),
                                                if (packageProvider
                                                    .packagedataList[index]
                                                    .prices!
                                                    .isNotEmpty)
                                                  Text(
                                                    "Premie",
                                                    style: Style_File.title
                                                        .copyWith(
                                                            color: colorWhite),
                                                  ),
                                                SizedBox(
                                                  width: 10.w,
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
                            ),
                          );
                        }),
                  ],
                );
              } else {
                return NoDataFoundErrorScreens(
                  height: 50.h,
                );
                //   LoaderScreen();
              }
            }),
    );
  }
}
