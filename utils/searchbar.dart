import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinttext;
  //final IconData icon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool obscure;
  final bool obscure1;
  final bool suffixIcon;
  final Widget? suffixIconWidget;
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  SearchBar({
    Key? key,
    required this.textEditingController,
    required this.hinttext,
    //  this.icon,
    this.obscure = true,
    this.obscure1 = true,
    this.validator,
    this.readOnly = false,
    this.suffixIcon = false,
    this.suffixIconWidget,
    this.onPressed,
    this.keyboardType,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 5.h,
      child: TextFormField(
        controller: textEditingController,
        readOnly: readOnly,
        // obscureText: suffixIcon ? obscure : false,
        // obscureText1: suffixIcon ? obscure : false,

        style: Style_File.detailstitle.copyWith(
            fontWeight: FontWeight.w400, color: colorGrey, fontSize: 16.sp),

        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorPrimary),
                borderRadius: BorderRadius.all(Radius.circular(4.w))),
            suffixIcon: suffixIcon
                ? suffixIconWidget ??
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      //   obscure1 ? Icons.visibility_off : Icons.visibility,
                      color: colorPrimary,
                    ))
                : null),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
