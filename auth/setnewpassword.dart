import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/auth/login.dart';
import 'package:halsogourmet/screens/home/homescreen.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/mainbar.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/buttonwidgetloader.dart';
import '../utils/dialog_helper.dart';
import 'app_validator.dart';

class SetnewPassword extends StatefulWidget {
  final String? id;
  final String? password;
  final String? userid;
  final String? pagetype;
  final String? otp;
  final String? email;
  const SetnewPassword(
      {Key? key,
      this.id,
      this.password,
      this.pagetype,
      this.email,
      this.userid,
      this.otp})
      : super(key: key);

  @override
  State<SetnewPassword> createState() => _SetnewPasswordState();
}

class _SetnewPasswordState extends State<SetnewPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  late ScaffoldMessengerState scaffoldMessenger;

  bool isLoading = false;

  bool _obscureText = true;
  bool _obscureText1 = true;

  String _error = '';

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

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
              MainBar(text: "Ange nytt lösenord"),
              SizedBox(
                height: 4.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormScreen(
                      textEditingController: passwordController,
                      hinttext: "nytt lösenord",
                      suffixIcon: true,
                      icon: Icons.lock,
                      obscure: _obscureText,
                      onPressed: _toggle,
                      validator: AppValidator.passwordValidator,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormScreen(
                      textEditingController: confirm_passwordController,
                      hinttext: "Bekräfta nytt lösenord",
                      suffixIcon: true,
                      icon: Icons.lock,
                      obscure: _obscureText1,
                      onPressed: _toggle1,
                      validator: AppValidator.confirm_passwordValidator,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Text(
                  _error,
                  style: Style_File.subtitle
                      .copyWith(color: colorPrimary, fontSize: 15.sp),
                ),
              ),
              SizedBox(
                height: .5.h,
              ),
              !isLoading
                  ? ButtonWidget(
                      text: 'BEKRÄFTA',
                      onTap: () {
                        setState(() {
                          _error = '';
                        });
                        if (isLoading) {
                          return;
                        }

                        resetPassword(passwordController.text,
                            confirm_passwordController.text);
                      },
                    )
                  : ButtonWidgetLoader(),
              SizedBox(height: 5.h),
              _isValid
                  ? const Text(
                      'Ange lösenord framgångsrikt!',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Amazon',
                        fontSize: 15,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  resetPassword(String newpassword, String confirmpassword) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        if (passwordController.text == confirm_passwordController.text) {
          var data = {
            'otp': widget.otp.toString().trim(),
            'newPassword': newpassword.toString().trim(),
            'email': widget.email.toString().trim(),
          };

          LoginApi registerresponse = LoginApi(data);
          var response = await registerresponse.forgetpassword();

          print(response);

          setState(() {
            isLoading = false;
          });

          if (response['status'].toString() == 'success') {
            setState(() {
              isLoading = false;
            });

            DialogHelper.showFlutterToast(
                strMsg: "Användare Nytt lösenord uppdaterat!!");
            Navigator.pushReplacementNamed(context, Routes.loginScreen);

            // Navigator.pop(context);
          } else {
            DialogHelper.showFlutterToast(
                strMsg: "The Lösenord and confirm Lösenord must be match.");
          }
        } else {
          setState(() {
            _error = "Bekräfta lösenord måste stämma";
            isLoading = false;
          });
          DialogHelper.showFlutterToast(
              strMsg: "Bekräfta lösenord måste stämma");
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
