import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/mainbar.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/buttonwidgetloader.dart';
import '../utils/dialog_helper.dart';
import 'app_validator.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String _error = '';

  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  bool setvalue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0.h, left: 2.0.h, right: 2.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                ),
                color: Colors.black,
              ),
              MainBar(
                text: "Glöm lösenord",
              ),

              SizedBox(
                height: 4.h,
              ),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormScreen(
                      hinttext: 'Ange ditt e-post-ID eller mobilnummer',
                      icon: Icons.mail,
                      textEditingController: emailController,
                      validator: AppValidator.emailValidator,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Text(
                  "Ange e-post-ID eller mobilnummer. vi skickar dig en OTP via e-post/SMS",
                  style: Style_File.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),

              Center(
                child: Text(
                  _error,
                  style: Style_File.subtitle
                      .copyWith(color: Colors.red, fontSize: 15.sp),
                ),
              ),

              SizedBox(
                height: 3.h,
              ),

              !isLoading
                  ? ButtonWidget(
                      text: 'SKICKA FÖRFRÅGAN',
                      onTap: () {
                        setState(() {
                          _error = '';
                        });
                        if (isLoading) {
                          return;
                        }

                        forgotPassword(emailController.text);
                      },
                    )
                  : ButtonWidgetLoader(),

              // ButtonWidget(
              //   text: 'SUBMIT REQUEST',
              //
              //   onTap: () {
              //     if (isLoading) {
              //       return;
              //     }
              //     forgotPassword(emailController.text);
              //    // Navigator.pushNamed(context, Routes.otpVerify);
              //
              //   //  Navigator.push(context,
              //       //  MaterialPageRoute(builder: (context) => OtpVerify()));
              //   },
              // ),
              SizedBox(
                height: 5.h,
              ),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Kom ihåg Dina Lösenord",
                    style: Style_File.subtitle.copyWith(
                      color: colorGrey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: " Logga in",
                          style: Style_File.subtitle.copyWith(
                              color: colorBlack, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, Routes.loginScreen)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  forgotPassword(String email) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        var data = {
          'email': email.toString().trim(),
        };
        print(email.toString());
        LoginApi registerresponse = LoginApi(data);
        final response = await registerresponse.sentotp();
        if (response['status'].toString() == "success") {
          Navigator.pushNamed(context, Routes.otpVerify, arguments: {
            StringFile.email: email,
            StringFile.pagetype: StringFile.forgot_password,
            // StringFile.id: response['user']['id'],
          });
        } else {
          print(response);
          setState(() {
            _error = response['error'].toString();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });

      DialogHelper().shoppopDialog(context);
    }
  }
}
