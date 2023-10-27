import 'package:flutter/cupertino.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainBar extends StatelessWidget {
  final String? image;
  final String? text;
  const MainBar({
    Key? key,
    this.image,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 3.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(
                  ImageFile.logo,
                  height: 12.h,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 3.5.h,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            text!,
            style:
                Style_File.title.copyWith(color: colorSecondry, fontSize: 3.h),
          ),
        ]),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }
}
