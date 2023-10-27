import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/mainbar.dart';
import 'package:halsogourmet/utils/socialbutton.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../utils/buttonwidgetloader.dart';
import '../utils/dialog_helper.dart';
import 'app_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final String _userEmail = '';
  final String _password = '';
  String _error = '';

  bool isLoading = false;
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Future<void> _handleSignOut() => googleSignIn.disconnect();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    print("googleAuth $googleAuth");
    log(googleAuth!.idToken.toString());

    googlelogin(googleAuth.idToken.toString());
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final AccessToken accessToken = loginResult.accessToken!;
    final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  googlelogin(String token) async {
    var data = {
      'token': token,
    };
    print(data.toString());
    LoginApi registerresponse = LoginApi(data);
    final response = await registerresponse.googlesocialmedialogin();

    if (response['status'] == 'success') {
      Map<String, dynamic> res = response['user'];

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var subscriptioncheck = response['user']['isSubscription'];
      log(subscriptioncheck.toString());
      if (subscriptioncheck.toString() == '0') {
        setState(() {
          MyApp.subscriptioncheck = false;
        });
      } else {
        setState(() {
          MyApp.subscriptioncheck = true;
          MyApp.subscriptionstartdate =
              response['user']['subscription']['subscriptionStart'];
          MyApp.subscriptionenddate =
              response['user']['subscription']['expire'];
          MyApp.isRecurring = response['user']['subscription']['isRecurring'];
          MyApp.stripeSubscriptionId = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? ""
              : response['user']['subscription']['stripeSubscriptionId']
                  .toString();
          MyApp.subscriptionDeleted = response['user']['subscription']
                          ['subscriptionDeleted']
                      .toString() ==
                  "null"
              ? false
              : true;
          MyApp.subscriptionapplepay = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? false
              : true;
        });
      }
      log(MyApp.subscriptioncheck.toString());
      MyApp.userid = res['id'].toString();
      MyApp.email_VALUE = res['emailAddress'].toString();
      MyApp.AUTH_TOKEN_VALUE = response['accessToken'].toString();
      sharedPreferences.setString(StringFile.userid, res['id'].toString());
      sharedPreferences.setString(
          StringFile.email, res['emailAddress'].toString());
      sharedPreferences.setString(
          StringFile.authtoken, response['accessToken'].toString());
      String? token;
      try {
        token = (await FirebaseMessaging.instance.getToken())!;
        print(token);
      } catch (e) {
        print(e);
      }
      var body = {"facId": token};
      LoginApi responsefcmtoken = LoginApi(body);
      final responsefcmtokenreturn = await responsefcmtoken.factokenregister();
      print(responsefcmtokenreturn);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.bottomNav, (route) => false);
      DialogHelper.showFlutterToast(strMsg: "Login Successful");
    }
  }

  facebooklogin(String token) async {
    var data = {
      'token': token,
    };
    print(data.toString());
    LoginApi registerresponse = LoginApi(data);
    final response = await registerresponse.facebooksocialmedialogin();

    if (response['status'] == 'success') {
      Map<String, dynamic> res = response['user'];

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      MyApp.userid = res['id'].toString();
      MyApp.email_VALUE = res['emailAddress'].toString();
      MyApp.AUTH_TOKEN_VALUE = response['accessToken'].toString();
      sharedPreferences.setString(StringFile.userid, res['id'].toString());
      sharedPreferences.setString(
          StringFile.email, res['emailAddress'].toString());
      sharedPreferences.setString(
          StringFile.authtoken, response['accessToken'].toString());
      String? token;
      try {
        token = (await FirebaseMessaging.instance.getToken())!;
        print(token);
      } catch (e) {
        print(e);
      }
      var body = {"facId": token};
      LoginApi responsefcmtoken = LoginApi(body);
      final responsefcmtokenreturn = await responsefcmtoken.factokenregister();
      print(responsefcmtokenreturn);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.bottomNav, (route) => false);
      DialogHelper.showFlutterToast(strMsg: "Login Successful");
    }
  }

  applelogin(String token) async {
    var data = {
      'token': token,
    };
    print(data.toString());
    LoginApi registerresponse = LoginApi(data);
    final response = await registerresponse.appleocialmedialogin();

    if (response['status'] == 'success') {
      Map<String, dynamic> res = response['user'];

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var subscriptioncheck = response['user']['isSubscription'];
      log(subscriptioncheck.toString());
      if (subscriptioncheck.toString() == '0') {
        setState(() {
          MyApp.subscriptioncheck = false;
        });
      } else {
        setState(() {
          MyApp.subscriptioncheck = true;
          MyApp.subscriptionstartdate =
              response['user']['subscription']['subscriptionStart'];
          MyApp.subscriptionenddate =
              response['user']['subscription']['expire'];
          MyApp.isRecurring = response['user']['subscription']['isRecurring'];
          MyApp.stripeSubscriptionId = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? ""
              : response['user']['subscription']['stripeSubscriptionId']
                  .toString();
          MyApp.subscriptionDeleted = response['user']['subscription']
                          ['subscriptionDeleted']
                      .toString() ==
                  "null"
              ? false
              : true;
          MyApp.subscriptionapplepay = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? false
              : true;
        });
      }
      log(MyApp.subscriptioncheck.toString());
      MyApp.userid = res['id'].toString();
      MyApp.email_VALUE = res['emailAddress'].toString();
      MyApp.AUTH_TOKEN_VALUE = response['accessToken'].toString();
      sharedPreferences.setString(StringFile.userid, res['id'].toString());
      sharedPreferences.setString(
          StringFile.email, res['emailAddress'].toString());
      sharedPreferences.setString(
          StringFile.authtoken, response['accessToken'].toString());
      String? token;
      try {
        token = (await FirebaseMessaging.instance.getToken())!;
        print(token);
      } catch (e) {
        print(e);
      }
      var body = {"facId": token};
      LoginApi responsefcmtoken = LoginApi(body);
      final responsefcmtokenreturn = await responsefcmtoken.factokenregister();
      print(responsefcmtokenreturn);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.bottomNav, (route) => false);
      DialogHelper.showFlutterToast(strMsg: "Login Successful");
    }
  }

  bool setvalue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0.h, left: 2.0.h, right: 2.0.h),
          child: Column(
            children: <Widget>[
              const MainBar(text: "Logga in"),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      hinttext: 'Lösenord',
                      icon: Icons.lock,
                      textEditingController: passwordController,
                      validator: AppValidator.passwordValidator,
                      suffixIcon: true,
                      obscure: _obscureText,
                      onPressed: _toggle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Text("Glöm lösenord?",
                            style: Style_File.title.copyWith(fontSize: 15.sp)),
                        onTap: () => {
                          Navigator.pushNamed(context, Routes.forgetPassword),
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                _error,
                style: Style_File.subtitle
                    .copyWith(color: Colors.red, fontSize: 15.sp),
              ),
              SizedBox(
                height: 3.h,
              ),

              // Provider.of<InternetConnectionStatus>(context) ==
              //         InternetConnectionStatus.disconnected
              //     ? InternetNotAvailable()
              //     :

              !isLoading
                  ? ButtonWidget(
                      text: 'Logga in',
                      onTap: () {
                        if (isLoading) {
                          return;
                        }
                        login(emailController.text, passwordController.text);
                      },
                    )
                  : ButtonWidgetLoader(),
              SizedBox(
                height: 5.h,
              ),
              RichText(
                text: TextSpan(
                  text: "Har du inte ett konto ?",
                  style: Style_File.subtitle.copyWith(
                    color: colorGrey,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: " skapa nu",
                        style: Style_File.subtitle.copyWith(
                            color: colorBlack, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, Routes.signupScreen)),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                "--------------------------Eller logga in med--------------------------",
                style: Style_File.subtitle,
              ),
              SizedBox(
                height: 3.h,
              ),
              if (!Platform.isIOS)
                SocialButton(
                  image: ImageFile.fb,
                  text: 'Logga in med Facebook',
                  onPressed: () async {
                    final userCredential = await signInWithFacebook();
                    // here you will have your Firebase user in:
                    // userCredential.user

                    // log(await userCredential.user!.getIdToken());
                    final idToken = await userCredential.user!.getIdToken();
                    print("idToken $idToken");
                    print(userCredential.user!);
                    facebooklogin(idToken.toString());
                  },
                ),
              if (Platform.isIOS)
                SocialButton(
                  image: ImageFile.applelogo,
                  text: 'Logga in med Apple',
                  onPressed: () async {
                    isLoading = true;
                    final credentials = SignInWithApple.channel;
                    print("credentials $credentials");
                    final credential =
                        await SignInWithApple.getAppleIDCredential(scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ], state: 'state');
                    // log(credential.identityToken.toString());
                    applelogin(credential.identityToken.toString());
                  },
                ),
              SocialButton(
                image: ImageFile.google,
                text: 'Logga in med Google',
                boxcolor: Colors.white,
                textcolor: Colors.black,
                onPressed: () {
                  isLoading = true;
                  signInWithGoogle();
                },
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

  login(email, password) async {
    setState(() {
      isLoading = true;
    });

    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        print("object");
        var data = {
          'email': email.toString().trim(),
          'password': password.toString().trim()
        };
        print(data.toString());
        LoginApi registerresponse = LoginApi(data);
        final response = await registerresponse.login();

        if (response['status'].toString().toLowerCase() == "success") {
          Map<String, dynamic> res = response['user'];

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var subscriptioncheck = response['user']['isSubscription'];
          log(subscriptioncheck.toString());
          if (subscriptioncheck.toString() == '0') {
            setState(() {
              MyApp.subscriptioncheck = false;
            });
          } else {
            setState(() {
              MyApp.subscriptioncheck = true;
              MyApp.subscriptionstartdate =
                  response['user']['subscription']['subscriptionStart'];
              MyApp.subscriptionenddate =
                  response['user']['subscription']['expire'];
              MyApp.isRecurring =
                  response['user']['subscription']['isRecurring'];
              MyApp.stripeSubscriptionId = response['user']['subscription']
                              ['stripeSubscriptionId']
                          .toString() ==
                      "null"
                  ? ""
                  : response['user']['subscription']['stripeSubscriptionId']
                      .toString();
              MyApp.subscriptionDeleted = response['user']['subscription']
                              ['subscriptionDeleted']
                          .toString() ==
                      "null"
                  ? false
                  : true;
              MyApp.subscriptionapplepay = response['user']['subscription']
                              ['stripeSubscriptionId']
                          .toString() ==
                      "null"
                  ? false
                  : true;
            });
          }
          log(MyApp.subscriptioncheck.toString());

          MyApp.userid = res['id'].toString();
          MyApp.email_VALUE = res['emailAddress'].toString();
          MyApp.AUTH_TOKEN_VALUE = response['accessToken'].toString();
          sharedPreferences.setString(StringFile.userid, res['id'].toString());
          sharedPreferences.setString(
              StringFile.email, res['emailAddress'].toString());
          sharedPreferences.setString(
              StringFile.authtoken, response['accessToken'].toString());
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
          DialogHelper.showFlutterToast(strMsg: "Inloggningen lyckades");
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            _error = response['error'].toString();
            isLoading = false;
          });

          if (_error == "Emailet har inte verifierats")
            Navigator.pushNamed(context, Routes.otpVerify, arguments: {
              StringFile.pagetype: StringFile.signup,
              StringFile.email: email,
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
