import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/auth/app_validator.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/profilemodel.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/buttonwidgetloader.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final List<ProfileUserData>? profileuserdata;
  const EditProfile({Key? key, this.profileuserdata}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (widget.profileuserdata!.isNotEmpty) {
      firstnameController.text = widget.profileuserdata![0].firstName ?? '';
      lastnameController.text = widget.profileuserdata![0].lastName ?? '';
      emailController.text = widget.profileuserdata![0].emailAddress ?? '';
      mobileController.text = widget.profileuserdata![0].phoneNumber.toString();
    }
    super.initState();
  }

  Future submitupdate() async {
    if (imagefiles != null) {
      var url = Uri.parse(APIURL.USERPROFILEUPDATE + MyApp.userid!);
      print(url);

      final request = new http.MultipartRequest('PUT', url);
      Map<String, String> headers = {
        "Authorization": 'Bearer ${MyApp.AUTH_TOKEN_VALUE?.trim()}'
      };
      print(imagefiles!.path);
      request.headers.addAll(headers);
      print(request.headers);

      final file =
          await http.MultipartFile.fromPath('userAvatar', imagefiles!.path);

      request.files.add(file);

      request.fields['firstName'] = firstnameController.text;
      request.fields['lastName'] = lastnameController.text;
      request.fields['phoneNumber'] = mobileController.text;
      request.fields['emailAddress'] = emailController.text;
      // request.fields['id'] = MyApp.userid!;
      print(request);
      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        var out = jsonDecode(response.body);
        if (out['status'] == "success") {
          DialogHelper.showFlutterToast(strMsg: out['message']);
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }
    } else {
      var data = {
        'firstName': firstnameController.text,
        'lastName': lastnameController.text,
        'phoneNumber': mobileController.text,
        'emailAddress': emailController.text,
        // "id": MyApp.userid,
      };
      print(data.toString());

      LoginApi registerresponse = LoginApi(data);

      final response = await registerresponse.updateprofile();

      print(response);
      if (response['status'] == "success") {
        DialogHelper.showFlutterToast(strMsg: response['message']);
        Navigator.pop(context);
      }
    }
  }

  final ImagePicker imgpicker = ImagePicker();
  XFile? imagefiles;

  openImages() async {
    try {
      final XFile? image =
          await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture

      if (image != null) {
        imagefiles = image;
        setState(() {});
      } else {
        print("Ingen bild är vald.");
        DialogHelper.showFlutterToast(strMsg: 'Ingen bild är vald');
      }
    } catch (e) {
      print("Fel vid val av fil.");
      DialogHelper.showFlutterToast(strMsg: 'Fel vid val av fil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorSecondry,
        centerTitle: true,
        title: Text(
          "Min Profil",
          style: Style_File.title.copyWith(color: colorWhite, fontSize: 18.sp),
        ),
      ),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Padding(
              padding: EdgeInsets.only(top: 4.h, left: 2.h, right: 2.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Center(
                    //   child: CircleAvatar(
                    //     radius: 40,
                    //     backgroundColor: colorGrey,
                    //     backgroundImage:
                    //         // imagefiles != null
                    //         //     ? FileImage(File(imagefiles!.path))
                    //         //     : widget.profileuserdata![0].photo != null
                    //         //         ? NetworkImage(imageurlproile +
                    //         //             widget.profileuserdata![0].photo.toString())
                    //         //         :
                    //         AssetImage(
                    //       ImageFile.profile,
                    //     ) as ImageProvider,
                    //     child: Align(
                    //       alignment: Alignment.bottomRight,
                    //       child: InkWell(
                    //         onTap: () {
                    //           // _editProfileController.showPopupMenu();
                    //           // openImages();
                    //         },
                    //         child: CircleAvatar(
                    //           radius: 2.h,
                    //           backgroundColor: colorSecondry,
                    //           child: Icon(
                    //             Icons.edit,
                    //             color: Colors.white,
                    //             size: 15,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Center(
                      child: CircleAvatar(
                        radius: 6.h,
                        backgroundImage: imagefiles != null
                            ? FileImage(File(imagefiles!.path))
                            : widget.profileuserdata![0].userAvatar != null
                                ? NetworkImage(APIURL.imageurl +
                                    widget.profileuserdata![0].userAvatar
                                        .toString())
                                : AssetImage(ImageFile.profile
                                    // "assets/images/profile.png",
                                    ) as ImageProvider,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              //  _editProfileController.showPopupMenu();
                              openImages();
                            },
                            child: CircleAvatar(
                              radius: 2.h,
                              backgroundColor: colorSecondry,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 2.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 3.h,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Förnamn",
                                  style: Style_File.title
                                      .copyWith(color: colorGrey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TextFormScreen(
                              hinttext: 'Förnamn*',
                              icon: Icons.account_circle,
                              textEditingController: firstnameController,
                              validator: AppValidator.nameValidator,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Efternamn",
                                  style: Style_File.title
                                      .copyWith(color: colorGrey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TextFormScreen(
                              hinttext: 'Efternamn*',
                              icon: Icons.account_circle,
                              textEditingController: lastnameController,
                              validator: AppValidator.lastnameValidator,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "E-postadress",
                                  style: Style_File.title
                                      .copyWith(color: colorGrey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TextFormScreen(
                              hinttext: 'E-postadress*',
                              icon: Icons.mail,
                              textEditingController: emailController,
                              validator: AppValidator.emailValidator,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Telefonnummer",
                                  style: Style_File.title
                                      .copyWith(color: colorGrey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TextFormScreen(
                              hinttext: 'Telefonnummer*',
                              icon: Icons.phone_android_rounded,
                              textEditingController: mobileController,
                              validator: AppValidator.mobileValidator,
                            ),
                          ],
                        )),

                    SizedBox(
                      height: 5.h,
                    ),

                    !isLoading
                        ? ButtonWidget(
                            text: 'Uppdatera',
                            onTap: () {
                              if (isLoading) {
                                return;
                              }

                              update(
                                firstnameController.text,
                                lastnameController.text,
                                emailController.text,
                                mobileController.text,
                              );

                              submitupdate();
                            },
                          )
                        : ButtonWidgetLoader(),

                    SizedBox(
                      height: 4.h,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  update(firstname, lastname, email, mobile) async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      // DialogHelper.showFlutterToast(strMsg: "Profile Update Successfully!");
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
