import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/ingradientsModel.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddIngredientsCalanderScreenActivity extends StatefulWidget {
  final List<FoodtypeData> foodlist;
  final String ingredientid;
  final String ingredientname;

  final Function? callback;

  const AddIngredientsCalanderScreenActivity({
    super.key,
    required this.foodlist,
    required this.ingredientid,
    required this.ingredientname,
    this.callback,
  });

  @override
  State<AddIngredientsCalanderScreenActivity> createState() =>
      _AddIngredientsCalanderScreenActivityState();
}

class _AddIngredientsCalanderScreenActivityState
    extends State<AddIngredientsCalanderScreenActivity> {
  TextEditingController _ingrediwntseditingController = TextEditingController();
  TextEditingController _ingrediwntsController = TextEditingController();
  String data = '';
  String foodid = '';
  DateTime currentDate = DateTime.now();
  DateTime? finaldatetime;

  addingredients() async {
    var body = {
      "ingradientId": widget.ingredientid,
      "date": DateFormat("yyyy-MM-dd").format(finaldatetime!).toString(),
      "foodTypeId": foodid.toString(),
      "quantity": _ingrediwntsController.text,
      "serving": 1,
      "type": "ingradient"
    };
    // print(body);
    LoginApi loginApi = new LoginApi(body);
    final response = await loginApi.addingredientcalander();
    if (response['status'].toString() == 'success') {
      DialogHelper.showFlutterToast(strMsg: response['message']);
      widget.callback!("ok");
    } else {
      DialogHelper.showFlutterToast(strMsg: response['error']);
      widget.callback!("ok");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _ingrediwntseditingController.text =
            DateFormat("dd-MM-yyyy").format(pickedDate);
        finaldatetime = pickedDate;
      });
    }
  }

  @override
  void initState() {
    // _ingrediwntseditingController.text =

    _ingrediwntseditingController.text =
        DateFormat("dd-MM-yyyy").format(currentDate);
    finaldatetime = currentDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100.w,
        height: 60.h,
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
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Schemalägg ingrediens",
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
                  widget.ingredientname,
                  style: Style_File.title,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Typ av mat",
                  style: Style_File.title,
                ),
                SizedBox(
                  height: 2.h,
                ),
                DropdownSearch<FoodtypeData>(
                  items: widget.foodlist,
                  dropdownBuilder: (context, selectedItem) {
                    if (selectedItem != null) {
                      return Text(
                        selectedItem.foodType ?? "",
                      );
                    } else {
                      return Text("");
                    }
                  },
                  onChanged: (value) {
                    foodid = value!.id.toString();
                  },
                  compareFn: (item, selectedItem) => item.id == selectedItem.id,
                  // asyncItems: (String? filter) =>data,
                  popupProps: PopupProps.menu(
                    // title: Text('fit to a specific width and height'),
                    // showSearchBox: false,
                    fit: FlexFit.loose,
                    constraints: BoxConstraints.tightFor(
                      width: 100.w,
                      height: 20.h,
                    ),

                    itemBuilder: (ctx, item, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        title: Text(item.foodType!),

                        // onTap: () => myKey.currentState?.popupValidate([item]),
                      );
                    },
                  ),
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
                  hinttext: 'Mängd (g)',
                  icon: Icons.kitchen,
                  textEditingController: _ingrediwntsController,
                  // s
                  //
                  //uffixIcon: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text("Datum",
                    style: Style_File.subtitle
                        .copyWith(color: colorBlack, fontSize: 17.sp)),
                SizedBox(
                  height: 5.h,
                  width: 80.w,
                  child: GestureDetector(
                    onTap: (() {
                      _selectDate(context);
                    }),
                    child: TextField(
                      controller: _ingrediwntseditingController,
                      enabled: false,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month),
                          border: InputBorder.none,
                          hintText: 'DD-MM-YYYY',
                          hintStyle:
                              Style_File.subtitle.copyWith(fontSize: 15.sp)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ButtonWidget(
                  text: 'Skicka in',
                  onTap: () {
                    if (_ingrediwntsController.text.isNotEmpty &&
                        foodid != '') {
                      addingredients();
                    } else {
                      DialogHelper.showFlutterToast(
                          strMsg: "Snälla Fyll i alla fält");
                    }

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
