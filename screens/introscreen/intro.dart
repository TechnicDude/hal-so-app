import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/screens/home/healtschoolvideoplay.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/playvideoyoutube.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../auth/login.dart';
import '../../page_routes/routes.dart';
import '../../utils/colors.dart';
import '../../utils/style_file.dart';
import 'introvideo.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecondry,
      body: Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visibility(
              //   visible: Provider.of<InternetConnectionStatus>(context) ==
              //       InternetConnectionStatus.disconnected,
              //   child: InternetNotAvailable(),
              // ),
              // Provider.of<InternetConnectionStatus>(context) ==
              //         InternetConnectionStatus.disconnected
              //     ? Center(
              //         child: Text(
              //           'Not connected',
              //           style: Style_File.title
              //               .copyWith(color: colorGrey, fontSize: 16.sp),
              //         ),
              //       )
              //     :

              Container(
                  height: 24.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorGrey,
                      width: 1.h,
                    ),
                  ),
                  //child: HealthSchoolVideoPlay(),
                  child: PalyVideoYoutubeScreen(
                    url: 'https://www.youtube.com/watch?v=7YtPDwk8QaY',
                  )
                  //VideoApp(),
                  ),
              SizedBox(
                height: 10.h,
              ),
              Text("Koka ris enkelt Isak",
                  style: Style_File.title
                      .copyWith(color: colorWhite, fontSize: 18.sp)),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Laga recept med videor enligt dina krav.",
                textAlign: TextAlign.center,
                style: Style_File.subtitle
                    .copyWith(color: colorWhite, fontSize: 16.sp),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                },
                child: Container(
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(10.h),
                    border: Border.all(
                      color: Colors.white10,
                      width: 1.h,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: colorBlack,
                    size: 5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                },
                child: Text(
                  "Hoppa över",
                  style: Style_File.intosubtitle,
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
