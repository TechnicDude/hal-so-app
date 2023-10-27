import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoDataFoundErrorScreens extends StatelessWidget {
  double? height;
  NoDataFoundErrorScreens({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height != null ? height : 75.h,
        width: 100.w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ingen information hittad",
                // "No Data Found",
                style: Style_File.title
                    .copyWith(color: Colors.grey.shade600, fontSize: 18.sp),
              ),
              SizedBox(
                height: .1.h,
              ),
              Image.asset(
                ImageFile.girlnofound,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
