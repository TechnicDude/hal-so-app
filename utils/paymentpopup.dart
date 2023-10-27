import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentpopupScreen extends StatelessWidget {
  final Function? callback;

  const PaymentpopupScreen({
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 2.w, right: 2.w),
        child: Container(
          height: 50.h,
          width: 100.w,
          padding: EdgeInsets.only(left: 2.w, right: 2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: const Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "Payment",
                    style: Style_File.detailstitle,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "ABC",
                        style: Style_File.subtitle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // SingleChildScrollView(
                  //   child: Text(
                  //     notificationData!.userQuery!.message!,
                  //     style: Style_File.subtitle,
                  //   ),
                  // )
                ],
              ),
              Positioned(
                top: -2.h,
                right: -1.w,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: IconButton(
                    color: colorWhite,
                    onPressed: () {
                      callback!("ok");
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
