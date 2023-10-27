import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/socialbutton.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/buttonwidgetloader.dart';
import '../utils/dialog_helper.dart';
import 'app_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';
  String _password = '';
  String _confirmpassword = '';
  String _error = '';
  bool valuedata = false;
  // This function is triggered when the user press the "Sign Up" button
  void _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      debugPrint('Registrera dig framgångsrikt');
      debugPrint(_userEmail);
      debugPrint(_password);
      debugPrint(_confirmpassword);
    }
  }

  bool isLoading = false;
  bool _obscureText = true;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

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
          padding: EdgeInsets.only(top: 2.0.h, left: 2.0.h, right: 2.0.h),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 10.h,
                    // width: 10.w,
                    // color: colorPrimary,
                    child: Column(
                      children: [
                        Image.asset(
                          ImageFile.logo,
                          height: 12.h,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "REGISTRERING",
                  style: Style_File.title
                      .copyWith(color: colorSecondry, fontSize: 3.h),
                ),
              ]),
              SizedBox(
                height: 4.h,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormScreen(
                        hinttext: 'Förnamn',
                        icon: Icons.account_circle,
                        textEditingController: firstnameController,
                        validator: AppValidator.nameValidator,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextFormScreen(
                        hinttext: 'Efternamn',
                        icon: Icons.account_circle,
                        textEditingController: lastnameController,
                        validator: AppValidator.lastnameValidator,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextFormScreen(
                        hinttext: 'E-postadress',
                        icon: Icons.mail,
                        textEditingController: emailController,
                        validator: AppValidator.emailValidator,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextFormScreen(
                        hinttext: 'Välj lösenord',
                        icon: Icons.lock,
                        textEditingController: passwordController,
                        // validator: AppValidator.passwordValidator,
                        suffixIcon: true,
                        obscure: _obscureText,
                        onPressed: _toggle,
                        validator: AppValidator.passwordValidator,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextFormScreen(
                        keyboardType: TextInputType.number,
                        hinttext: 'Mobilnummer',
                        icon: Icons.phone_android_rounded,
                        textEditingController: mobileController,
                        validator: AppValidator.mobileValidator,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: this.valuedata,
                            onChanged: (bool? value) {
                              setState(() {
                                this.valuedata = value!;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.webViewScreensShow,
                                  arguments: {
                                    StringFile.url:
                                        "https://halsogourmet.com/terms-conditions/"
                                  });
                            },
                            child: Row(
                              children: [
                                Text(
                                  "jag accepterar ",
                                  style: Style_File.subtitle,
                                ),
                                Text(
                                  "terms of conditions",
                                  style: Style_File.subtitle
                                      .copyWith(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: 5.h,
              ),
              Text(
                _error,
                style: Style_File.subtitle
                    .copyWith(color: Colors.red, fontSize: 15.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              !isLoading
                  ? ButtonWidget(
                      text: 'REGISTRERA',
                      onTap: () {
                        // setState(() {
                        //   _error = '';
                        // }
                        // );
                        if (isLoading) {
                          return;
                        }

                        signup(
                          firstnameController.text,
                          lastnameController.text,
                          emailController.text,
                          passwordController.text,
                          mobileController.text,
                        );
                      },
                    )
                  : ButtonWidgetLoader(),
              SizedBox(
                height: 4.h,
              ),
              RichText(
                text: TextSpan(
                  text: "Redan medlem",
                  style: Style_File.subtitle.copyWith(
                    color: colorGrey,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Logga in',
                      style: Style_File.subtitle.copyWith(
                          color: colorBlack, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            Navigator.pushNamed(context, Routes.loginScreen),
                    ),
                  ],
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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  signup(firatname, lastname, email, password, mobile) async {
    setState(() {
      isLoading = true;
    });

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (valuedata == true) {
        if (_formKey.currentState!.validate()) {
          var data = {
            'firstName': firatname.toString().trim(),
            'lastName': lastname.toString().trim(),
            'emailAddress': email.toString().trim(),
            'userPassword': password.toString().trim(),
            'phoneNumber': mobile.toString().trim(),
          };
          LoginApi registerresponse = LoginApi(data);
          var response = await registerresponse.register();
          print(response);
          print(data.toString());

          if (response['status'].toString().toLowerCase() == "success") {
            Map<String, dynamic> user = response['data'];

            Navigator.pushNamed(context, Routes.otpVerify, arguments: {
              StringFile.pagetype: StringFile.signup,
              StringFile.email: email,
            });
            setState(() {
              isLoading = false;
            });
            DialogHelper.showFlutterToast(strMsg: "OTP har skickats");
          } else {
            setState(() {
              _error = response['error'].toString() == "null"
                  ? "Något gick fel"
                  : response['error'].toString();
              isLoading = false;
            });
          }

          // DialogHelper.showFlutterToast(strMsg: "Registration Successful");
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          DialogHelper.showFlutterToast(strMsg: "Vänligen acceptera villkoren");
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
