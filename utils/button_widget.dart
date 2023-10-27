import 'package:flutter/material.dart';
import 'package:halsogourmet/utils/style_file.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'colors.dart';

class ButtonWidget extends StatefulWidget {
  final String? text;
  final Function()? onTap;
  const ButtonWidget({
    Key? key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          alignment: Alignment.center,
          height: 5.h,
          // width: 90.w,
          decoration: BoxDecoration(
            color: colorSecondry,
            borderRadius: BorderRadius.circular(2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(-1, 3),
              )
            ],
          ),

          child: Center(
              child: Padding(
            padding: EdgeInsets.only(left: 2.w, right: 2.w),
            child: Text(
              widget.text ?? '',
              style: Style_File.title.copyWith(color: colorWhite),
            ),
          )),
        ));
  }
}
