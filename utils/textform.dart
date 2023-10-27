import 'package:flutter/material.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'colors.dart';

class TextFormScreen extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinttext;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool obscure;
  final bool obscure1;
  final bool suffixIcon;
  final Widget? suffixIconWidget;
  final void Function()? onPressed;
  final TextInputType? keyboardType;

  TextFormScreen({
    Key? key,
    required this.textEditingController,
    required this.hinttext,
    required this.icon,
    this.obscure = true,
    this.obscure1 = true,
    this.validator,
    this.readOnly = false,
    this.suffixIcon = false,
    this.suffixIconWidget,
    this.onPressed,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 6.h,
      child: TextFormField(
        controller: textEditingController,
        readOnly: readOnly,
        obscureText: suffixIcon ? obscure : false,
        // obscureText1: suffixIcon ? obscure : false,
        keyboardType: keyboardType ?? TextInputType.text,
        style: Style_File.detailstitle
            .copyWith(fontWeight: FontWeight.w400, color: colorGrey),
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(fontSize: 14.sp, fontFamily: 'Amazon'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(2.w),
            )),
            prefixIcon: Icon(
              icon,
              size: 3.h,
              color: colorBlack.withOpacity(0.6),
            ),
            suffixIcon: suffixIcon
                ? suffixIconWidget ??
                    IconButton(
                        onPressed: onPressed,
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          //   obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: colorBlack,
                        ))
                : null),
        validator: validator,
      ),
    );
  }
}
