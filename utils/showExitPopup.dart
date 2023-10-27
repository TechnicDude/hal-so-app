import 'dart:io';
import 'package:flutter/material.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you sure want to exit app",
                  style: Style_File.detailstitle.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text(
                          "Yes",
                            style: Style_File.detailstitle
                              .copyWith(fontSize: 16.sp, color: colorWhite),
                        ),
                        style: ElevatedButton.styleFrom(primary: colorPrimary),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No",
                          style: Style_File.detailstitle
                              .copyWith(fontSize: 16.sp, color: colorWhite)),
                      style: ElevatedButton.styleFrom(
                        primary: colorBlack,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
