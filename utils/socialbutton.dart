import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialButton extends StatefulWidget {
  final String? image;
  final String? text;
  final Color? boxcolor;
  final Color? textcolor;
  final Function()? onPressed;
  const SocialButton({
    Key? key,
    this.image,
    this.text,
    this.onPressed,
    this.boxcolor,
    this.textcolor,
  }) : super(key: key);

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 5.h,
          decoration: BoxDecoration(
              color: widget.boxcolor ?? Colors.black,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(2.w)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.image ?? '',
                height: 3.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                widget.text ?? '',
                style: Style_File.subtitle.copyWith(
                    color: widget.textcolor ?? Colors.white, fontSize: 15.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
