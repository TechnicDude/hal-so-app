import 'package:flutter/material.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InternetNotAvailable extends StatelessWidget {
  double? height;
  InternetNotAvailable({Key? key, double? height});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height != null ? height : 55.h,
        width: 50.w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageFile.nointernet,
                  color: colorGrey.withOpacity(0.3)),
              Text(
                'Ingen internetanslutning!',
                style: Style_File.title.copyWith(
                    color: colorGrey.withOpacity(0.5), fontSize: 16.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
