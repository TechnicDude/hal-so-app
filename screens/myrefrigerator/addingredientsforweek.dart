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

class AddIngredientsforweekScreenActivity extends StatefulWidget {
  final String ingradientslistname;
  final String ingradientslistid;
  final Function? callback;

  const AddIngredientsforweekScreenActivity({
    super.key,
    required this.ingradientslistname,
    required this.ingradientslistid,
    this.callback,
  });

  @override
  State<AddIngredientsforweekScreenActivity> createState() =>
      _AddIngredientsforweekScreenActivityState();
}

class _AddIngredientsforweekScreenActivityState
    extends State<AddIngredientsforweekScreenActivity> {
  TextEditingController _ingrediwntseditingController = TextEditingController();
  TextEditingController _userEditTextController = TextEditingController();

  String data = '';

  addingredients() async {
    if (_ingrediwntseditingController.text.isNotEmpty) {
      var body = {
        "userId": MyApp.userid,
        "ingradientId": widget.ingradientslistid,
        "quantity": _ingrediwntseditingController.text,
      };

      LoginApi loginApi = new LoginApi(body);
      final response = await loginApi.addingredient();
      if (response['status'].toString() == 'success') {
        DialogHelper.showFlutterToast(strMsg: response['message']);
        widget.callback!("ok");
      } else {
        print(response);
        DialogHelper.showFlutterToast(strMsg: response['error']);
        widget.callback!("ok");
      }
    } else {
      print("Stig på mängd");
      DialogHelper.showFlutterToast(strMsg: 'Stig på mängd');
    }
  }

  @override
  void initState() {
    // _ingrediwntseditingController.text =

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
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
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
                      "Tillsätt ingrediense",
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
                  "Ingredienser",
                  // "Ingredients",
                  style: Style_File.title,
                ),

                // _customDropDownPrograms(context,);

                SizedBox(
                  height: 2.h,
                ),
                Text(widget.ingradientslistname),

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
                  hinttext: 'mängd (g)',
                  icon: Icons.kitchen,
                  textEditingController: _ingrediwntseditingController,
                ),
                SizedBox(
                  height: 2.h,
                ),
                ButtonWidget(
                  text: 'Skicka in',
                  onTap: () {
                    addingredients();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    IngradientsModelData? item,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.title ?? ''),
      ),
    );
  }

  Widget _customDropDownPrograms(
      BuildContext context, IngradientsModelData? item) {
    return Container(
        child: (item == null)
            ? const ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text("Search Programs",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(235, 158, 158, 158))),
              )
            : ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  item.title ?? '',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5, color: Colors.black),
                )));
  }
}
