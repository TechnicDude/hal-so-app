import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserAllReadSubscribe extends StatelessWidget {
  final Function? callback;
  const UserAllReadSubscribe({this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            height: 30.h,
            width: 90.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2.h)),
              border: Border.all(color: colorWhite, width: 0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1, 2),
                ),
              ],
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFFf9ad96),
                    const Color(0xFFf77795),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      color: colorWhite,
                      onPressed: () {
                        callback!("ok");
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  "Premie Tillgång",
                  // "Premium Access",
                  style: Style_File.title
                      .copyWith(color: Colors.white, fontSize: 20.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "du har redan prenumerationspaket",
                  // "This Recipe is premium Access",
                  style: Style_File.title
                      .copyWith(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Start datum",
                      style: Style_File.title.copyWith(color: Colors.white),
                    ),
                    Text(
                      DateFormat("dd-MM-yyyy hh:mm").format(
                        DateTime.parse(MyApp.subscriptionstartdate),
                      ),
                      style: Style_File.title.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Slutdatum",
                      style: Style_File.title.copyWith(color: Colors.white),
                    ),
                    Text(
                      DateFormat("dd-MM-yyyy hh:mm").format(
                        DateTime.parse(MyApp.subscriptionenddate),
                      ),
                      style: Style_File.title.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    callback!("ok");
                  },
                  child: Container(
                    height: 5.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(color: colorSecondry, width: 0.1),
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xFFd98ff9),
                            const Color(0xFF9554fc),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Center(
                      child: Text(
                        "ok",
                        // "Buy Now",
                        style: Style_File.title
                            .copyWith(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
