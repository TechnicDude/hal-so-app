import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/ingradientsModel.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:search_choices/search_choices.dart';

class AddIngredientsScreenActivity extends StatefulWidget {
  final List<IngradientsModelData> ingradientslist;
  final Function? callback;

  const AddIngredientsScreenActivity({
    super.key,
    required this.ingradientslist,
    this.callback,
  });

  @override
  State<AddIngredientsScreenActivity> createState() =>
      _AddIngredientsScreenActivityState();
}

class _AddIngredientsScreenActivityState
    extends State<AddIngredientsScreenActivity> {
  TextEditingController _ingrediwntseditingController = TextEditingController();
  TextEditingController _userEditTextController = TextEditingController();
  List<IngradientsModelData>? _selectedItemUser;
  String? selectedValueSingleDialog;

  String data = '';
  String ingradientId = '';

  Future<List<IngradientsModelData>> getData(filter) async {
    var _selectedItemUser = widget.ingradientslist;
    return _selectedItemUser;
  }

  addingredients() async {
    if (selectedValueSingleDialog != null) {
      // if (_ingrediwntseditingController.text.isNotEmpty) {
      var body = {
        "userId": MyApp.userid,
        "ingradientId": ingradientId,
        "quantity": _ingrediwntseditingController.text.isNotEmpty
            ? _ingrediwntseditingController.text
            : '0',
      };

      LoginApi loginApi = new LoginApi(body);
      final response = await loginApi.addingredient();
      if (response['status'].toString() == 'success') {
        DialogHelper.showFlutterToast(strMsg: response['message']);
        widget.callback!("ok");
      } else {
        print(response);
        DialogHelper.showFlutterToast(strMsg: response['error']);
      }
    } else {
      print("Stig på mängd");
      DialogHelper.showFlutterToast(strMsg: 'Stig på mängd');
    }
    // } else {
    //   print("Vänligen välj en");
    //   DialogHelper.showFlutterToast(strMsg: 'Vänligen välj en');
    // }
  }

  List<DropdownMenuItem> items = [];

  @override
  void initState() {
    // _ingrediwntseditingController.text =
    _selectedItemUser = widget.ingradientslist;

    for (int i = 0; i < _selectedItemUser!.length; i++) {
      items.add(DropdownMenuItem(
        value: _selectedItemUser![i].title,
        child: Text(_selectedItemUser![i].title.toString()),
      ));
    }

    super.initState();
  }

  bool isPressed = false;
  TextEditingController sercheditcontroler = TextEditingController();
  String searchString = '';
  bool searchshow = false;

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
            ),
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
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
                      //"Add Ingredients",
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
                  style: Style_File.title,
                ),
                SizedBox(
                  height: 2.h,
                ),

                SearchChoices.single(
                  items: items,
                  value: selectedValueSingleDialog,
                  hint: "Välj en", //"Select one",
                  searchHint: "Välj en",
                  // clearIcon:Icon(Icons.),

                  onChanged: (value) {
                    setState(() {
                      selectedValueSingleDialog = value;
                    });
                    for (int i = 0; i < _selectedItemUser!.length; i++) {
                      if (value == _selectedItemUser![i].title) {
                        setState(() {
                          ingradientId = _selectedItemUser![i].id.toString();
                        });
                      }
                    }
                  },
                  isExpanded: true,
                ),

                SizedBox(
                  height: 2.h,
                ),

                // DropdownSearch<IngradientsModelData>(
                //   items: _selectedItemUser!,
                //   // isFilteredOnline: true,
                //   dropdownBuilder: _customDropDownPrograms,
                //   // dropdownBuilder: (context, selectedItem) {
                //   //   if (selectedItem != null) {
                //   //     return Text(
                //   //       selectedItem.title ?? "",
                //   //       // style: TextStyle(
                //   //       //   color: Colors.green,
                //   //       // ),
                //   //     );
                //   //   } else {
                //   //     return Text("");
                //   //   }
                //   // },

                //   onChanged: (value) {
                //     print(value);
                //     ingradientId = value!.id.toString();
                //     // _selectedItemUser = value;
                //   },
                //   //  compareFn: (i, s) => i.isEqual(s),
                //   compareFn: (IngradientsModelData item,
                //       IngradientsModelData selectedItem) {
                //     print("item $item");
                //     print(" selectedItem $selectedItem");
                //     return item.id == selectedItem.id;
                //   },

                //   // asyncItems: (String? filter) =>data,
                //   popupProps: PopupProps.menu(
                //     // title: Text('fit to a specific width and height'),
                //     showSearchBox: true,
                //     fit: FlexFit.loose,
                //     constraints: BoxConstraints.tightFor(
                //       width: 100.w,
                //       height: 50.h,
                //     ),
                //     searchFieldProps: TextFieldProps(
                //       controller: _userEditTextController,
                //       decoration: InputDecoration(
                //         suffixIcon: IconButton(
                //           icon: Icon(Icons.clear),
                //           onPressed: () {
                //             _userEditTextController.clear();
                //           },
                //         ),
                //       ),
                //     ),

                //     itemBuilder: (ctx, item, isSelected) {
                //       return ListTile(
                //         selected: isSelected,
                //         title: Text(item.title!),

                //         // onTap: () => myKey.currentState?.popupValidate([item]),
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(
                //   height: 2.h,
                // ),
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
                ),
                SizedBox(
                  height: 10.h,
                ),
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
              borderRadius: BorderRadius.circular(1.h),
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
