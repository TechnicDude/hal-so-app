import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/screens/splash.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/buttonwidgetloader.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/mainbar.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatefulWidget {
  final String? id;
  final String? email;
  final String? userid;
  final String? pagetype;
  const OtpVerify({Key? key, this.id, this.email, this.pagetype, this.userid})
      : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String _finalotp = '';
  String _error = '';

  forgotPassword(String email) async {
    var data = {
      'email': email,
    };
    print(email.toString());
    LoginApi registerresponse = LoginApi(data);
    final response = await registerresponse.sentotp();
    if (response['status'].toString() == "success") {
      // Navigator.pushNamed(context, Routes.otpVerify, arguments: {
      //   StringFile.email: email,
      //   StringFile.pagetype: StringFile.forgot_password,
      //   // StringFile.id: response['user']['id'],
      // });
      DialogHelper.showFlutterToast(strMsg: "success");
    } else {
      setState(() {
        _error = response['_error'].toString();
        isLoading = false;
      });
    }
  }

  Future<void> fetchdata() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (_finalotp.length == 6) {
        var data = {
          'email': widget.email.toString().trim(),
          'otp': _finalotp.toString().trim(),
        };
        LoginApi registerresponse = LoginApi(data);
        var response;
        if (widget.pagetype == StringFile.forgot_password) {
          response = await registerresponse.verifyOtp();

          print(response);
          print(data.toString());
          if (response['status'].toString().toLowerCase() == "success") {
            Navigator.pushNamed(context, Routes.setnewPassword, arguments: {
              StringFile.email: widget.email,
              StringFile.id: widget.id,
              StringFile.otp: _finalotp,
            });
            DialogHelper.showFlutterToast(
                strMsg: "Otp Verification Done Successfully");
            setState(() {
              isLoading = false;
            });
          } else {
            DialogHelper.showFlutterToast(strMsg: "Registration Failed!");
            setState(() {
              _error = response['error'];
            });
          }
        } else {
          print("object data new");
          // response = await registerresponse.forgetverifyOtp();
          response = await registerresponse.verifyOtp();
          print(response);
          print(data.toString());
          if (response['status'].toString().toLowerCase() == "success") {
            Map<String, dynamic> res = response['user'];
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            MyApp.userid = res['id'].toString();
            MyApp.email_VALUE = widget.email;
            MyApp.AUTH_TOKEN_VALUE = response['accessToken'].toString();

            sharedPreferences.setString(
                StringFile.userid, res['id'].toString());

            sharedPreferences.setString(
                StringFile.email, widget.email.toString());
            sharedPreferences.setString(
                StringFile.authtoken, response['accessToken'].toString());

            DialogHelper.showFlutterToast(strMsg: response['message']);
            String? token;
            try {
              token = (await FirebaseMessaging.instance.getToken())!;
              print(token);
            } catch (e) {
              print(e);
            }
            var body = {"facId": token};
            LoginApi responsefcmtoken = LoginApi(body);
            final responsefcmtokenreturn =
                await responsefcmtoken.factokenregister();
            print(responsefcmtokenreturn);
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.bottomNav, (route) => false);
          } else {
            print(response);
            DialogHelper.showFlutterToast(strMsg: response['error']);
            setState(() {
              _error = response['error'].toString();
              isLoading = false;
            });
          }
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      DialogHelper().shoppopDialog(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

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
                text: "Ange din OTP",
              ),
              SizedBox(
                height: 5.h,
              ),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                cursorColor: colorBlack,
                animationType: AnimationType.fade,
                pastedTextStyle: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    disabledColor: colorWhite,
                    borderRadius: BorderRadius.circular(1.h),
                    fieldHeight: 100.w / 8,
                    fieldWidth: 100.w / 8,
                    activeFillColor: colorWhite,
                    inactiveColor: colorGrey,
                    inactiveFillColor: colorWhite,
                    selectedFillColor: colorWhite,
                    selectedColor: colorSecondry,
                    activeColor: colorSecondry),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                onCompleted: (v) {
                  print("Completed");
                  _finalotp = v;
                  print(_finalotp);
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    // currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  return true;
                },
              ),
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: Text(
                  _error,
                  style: Style_File.subtitle
                      .copyWith(color: colorPrimary, fontSize: 15.sp),
                ),
              ),
              Center(
                child: Text(
                  "Ett email är skickat till din e-post adress med en engångskod.",
                  style: Style_File.subtitle,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "OTP inte mottagen?",
                    style: Style_File.subtitle
                        .copyWith(color: colorGrey, fontSize: 15.sp),
                    children: <TextSpan>[
                      TextSpan(
                          text: " Skicka igen",
                          style: Style_File.subtitle.copyWith(
                              color: colorBlack,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              forgotPassword(widget.email!);
                            }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              !isLoading
                  ? ButtonWidget(
                      text: 'VERIFY',
                      onTap: () {
                        setState(() {
                          _error = '';
                        });

                        fetchdata();
                      })
                  : ButtonWidgetLoader(),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
