import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/ingradientsModel.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditIngredientsScreenActivity extends StatefulWidget {
  final String? ingradientslist;
  final String? ingradientId;
  final String? Id;
  final Function? callback;
  final String? quantity;
  const EditIngredientsScreenActivity(
      {super.key,
      required this.ingradientslist,
      required this.Id,
      required this.ingradientId,
      this.callback,
      this.quantity});

  @override
  State<EditIngredientsScreenActivity> createState() =>
      _EditIngredientsScreenActivityState();
}

class _EditIngredientsScreenActivityState
    extends State<EditIngredientsScreenActivity> {
  TextEditingController _ingrediwntseditingController = TextEditingController();
  TextEditingController _ingrediwntnameseditingController =
      TextEditingController();
  String data = '';
  String ingradientId = '';

  addingredients() async {
    // if (_ingrediwntseditingController.text.isNotEmpty) {
    var body = {
      "userId": MyApp.userid,
      "ingradientId": widget.ingradientId,
      "quantity": _ingrediwntseditingController.text,
    };
    // print(body);
    LoginApi loginApi = new LoginApi(body);
    final response = await loginApi.editingredient(widget.Id!);
    if (response['status'].toString() == 'success') {
      DialogHelper.showFlutterToast(strMsg: response['message']);
      widget.callback!("ok");
    } else {
      DialogHelper.showFlutterToast(strMsg: response['message']);
    }
    // } else {
    //   print("Stig på mängd");
    //   DialogHelper.showFlutterToast(strMsg: 'Stig på mängd');
    // }
  }

  @override
  void initState() {
    _ingrediwntseditingController.text = widget.quantity!;
    _ingrediwntnameseditingController.text = widget.ingradientslist!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ), //BoxShadow
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tillsätt ingredienser",
                      // "Add Ingredients",
                      style: Style_File.title,
                    ),
                    IconButton(
                        onPressed: () {
                          widget.callback!("ok");
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Ingrediensens namn",
                  // "Ingredients name",
                  style: Style_File.title,
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFormScreen(
                  hinttext: 'Ingredienser',
                  icon: Icons.kitchen,
                  readOnly: true,
                  textEditingController: _ingrediwntnameseditingController,
                  // suffixIcon: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Mängd (g)",
                  style: Style_File.title,
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFormScreen(
                  keyboardType: TextInputType.number,
                  hinttext: 'Mängd',
                  icon: Icons.kitchen,

                  textEditingController: _ingrediwntseditingController,
                  // suffixIcon: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                ButtonWidget(
                  text: 'Skicka in',
                  onTap: () {
                    addingredients();
                    // setState(() {
                    //   _error = '';
                    // });
                    // print(isLoading);
                    // if (isLoading) {
                    //   return;
                    // }
                    // login(emailController.text, passwordController.text);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
