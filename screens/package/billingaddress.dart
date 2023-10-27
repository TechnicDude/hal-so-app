// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:halsogourmet/auth/app_validator.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/screens/package/input_formatters.dart';
import 'package:halsogourmet/screens/package/my_strings.dart';
import 'package:halsogourmet/screens/package/payment_card.dart';
import 'package:halsogourmet/screens/package/paymetutils.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/button_widget.dart';
import 'package:halsogourmet/utils/buttonwidgetloader.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:halsogourmet/utils/textform.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class Billingaddress extends StatefulWidget {
  final PackageData packagedata;
  final int index;

  const Billingaddress({
    super.key,
    required this.packagedata,
    required this.index,
  });
  @override
  State<Billingaddress> createState() => _BillingaddressState();
}

class _BillingaddressState extends State<Billingaddress> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  TextEditingController billingaddressController = TextEditingController();

  String couponcodemassage = "";

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // ignore: unused_field
  var _card = new PaymentCard();
  var _paymentCard = new PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  String amount = "";

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    amount = ((widget.packagedata.prices![widget.index].perMonthPrice!) *
            (widget.packagedata.prices![widget.index].tenure!))
        .toString();
    super.initState();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  bool showpop = false;
  bool paymentbutton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBarScreens(
            text: "Fakturaadress",
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
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
                          "namn",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormScreen(
                      hinttext: 'namn*',
                      icon: Icons.account_circle,
                      textEditingController: nameController,
                      validator: AppValidator.emptyfieldValidator,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "kortnummer",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter()
                      ],
                      controller: numberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        )),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardUtils.getCardIcon(_paymentCard.type),
                        ),
                        // icon: CardUtils.getCardIcon(_paymentCard.type),
                        hintText: 'kortnummer',
                        // labelText: 'Number',
                      ),
                      onSaved: (String? value) {
                        print('onSaved = $value');
                        print('Num controller has = ${numberController.text}');
                        _paymentCard.number =
                            CardUtils.getCleanedNumber(value!);
                      },
                      validator: CardUtils.validateCardNum,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Stiga på CVV",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        )),
                        fillColor: Colors.white,
                        filled: true,
                        // icon: ,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/card_cvv.png',
                            width: 30.0,
                            color: Colors.grey[600],
                          ),
                        ),

                        hintText: 'Stiga på CVV',
                      ),
                      validator: CardUtils.validateCVV,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _paymentCard.cvv = int.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Utgångsdatum",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter()
                      ],
                      decoration: InputDecoration(
                        // border: const UnderlineInputBorder(),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        )),
                        fillColor: Colors.white,

                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/calender.png',
                            width: 30.0,
                            color: Colors.grey[600],
                          ),
                        ),

                        hintText: 'MM/YY',
                        // labelText: 'Utgångsdatum',
                      ),
                      validator: CardUtils.validateDate,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        print(value);
                        setState(() {
                          List<int> expiryDate =
                              CardUtils.getExpiryDate(value!);
                          _paymentCard.month = expiryDate[0];
                          _paymentCard.year = expiryDate[1];
                          print(expiryDate.toString());
                        });
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Adress",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormScreen(
                      hinttext: 'Adress*',
                      icon: Icons.home_work_sharp,
                      textEditingController: addressController,
                      validator: AppValidator.emptyfieldValidator,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Pinkod",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormScreen(
                      hinttext: 'Pinkod*',
                      icon: Icons.power_input_outlined,
                      textEditingController: pincodeController,
                      validator: AppValidator.emptyfieldValidator,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Stad",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormScreen(
                      hinttext: 'Stad*',
                      icon: Icons.location_city,
                      textEditingController: cityController,
                      validator: AppValidator.emptyfieldValidator,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Land",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormScreen(
                      hinttext: 'Land*',
                      icon: Icons.public,
                      textEditingController: countryController,
                      validator: AppValidator.emptyfieldValidator,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "kupong",
                          style: Style_File.title.copyWith(color: colorGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 50.w,
                                child: TextFormScreen(
                                  hinttext: 'kupong',
                                  icon: Icons.account_circle,
                                  textEditingController: couponController,
                                ),
                              ),
                              Text(
                                couponcodemassage,
                                style: Style_File.subtitle
                                    .copyWith(color: Colors.red),
                              )
                            ],
                          ),
                          ButtonWidget(
                            text: 'kontrollera',
                            onTap: () async {
                              setState(() {
                                couponcodemassage = "";
                              });
                              createPaymentMethod(couponController.text);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              !isLoading
                  ? ButtonWidget(
                      text: 'Skicka in $amount kr',
                      onTap: () async {
                        if (isLoading) {
                          return;
                        }
                        update(
                          nameController.text,
                          addressController.text,
                          pincodeController.text,
                          cityController.text,
                          countryController.text,
                        );
                      },
                    )
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

  Future createPaymentMethod(
    String couponnumber,
  ) async {
    print(couponnumber);
    try {
      final String url = 'https://api.stripe.com/v1/coupons/$couponnumber';
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data['amount_off']);
        if (data['amount_off'].toString() != "null") {
          double offamount = double.parse(data['amount_off'].toString()) / 100;
          String amountdata =
              ((widget.packagedata.prices![widget.index].perMonthPrice!) *
                      (widget.packagedata.prices![widget.index].tenure!))
                  .toString();
          double remainamount = double.parse(amountdata) - offamount;
          setState(() {
            amount = remainamount.toString();
          });
        }
      } else {
        String amountdata =
            ((widget.packagedata.prices![widget.index].perMonthPrice!) *
                    (widget.packagedata.prices![widget.index].tenure!))
                .toString();
        setState(() {
          amount = amountdata.toString();
          couponcodemassage = "Kupongkoden är inte giltig";
        });
        print(json.decode(response.body));
        throw 'Failed to create PaymentMethod.';
      }
    } catch (e) {}
  }

  update(
    name,
    address,
    pincode,
    city,
    country,
  ) async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final FormState form = _formKey.currentState!;
      form.save();
      if (paymentbutton) {
        log(_paymentCard.month.toString());
        setState(() {
          paymentbutton = false;
        });

        // if (Platform.isAndroid) {
        String address = addressController.text +
            ' ' +
            cityController.text +
            '   ' +
            pincodeController.text;

        await PaymentUtils().makePayment(
            ((widget.packagedata.prices![widget.index].perMonthPrice!) *
                    (widget.packagedata.prices![widget.index].tenure!))
                .toString(),
            ((widget.packagedata.perMonthPrice!) *
                    (widget.packagedata.prices![widget.index].tenure!))
                .toString(),
            widget.packagedata.id.toString(),
            widget.packagedata,
            widget.packagedata.prices![widget.index],
            address,
            widget.packagedata.prices![widget.index].stripeProductID.toString(),
            cityController.text,
            countryController.text,
            addressController.text,
            pincodeController.text,
            '',
            MyApp.email_VALUE.toString(),
            nameController.text,
            widget.packagedata.prices![widget.index].isRecurring.toString(),
            numberController.text,
            _paymentCard.cvv.toString(),
            _paymentCard.month.toString(),
            _paymentCard.year.toString(),
            couponController.text,
            context);
        delayedNumber();
        setState(() {
          isLoading = false;
        });
        // } else {
        //   Navigator.pushNamed(context, Routes.paymetIosuiScreen, arguments: {
        //     StringFile.package: widget.packagedata,
        //     StringFile.index: widget.index,
        //   }).then((value) {
        //     setState(() {
        //       paymentbutton = true;
        //     });
        //   });
        // }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future delayedNumber() async {
    await Future.delayed(const Duration(seconds: 10)).whenComplete(() {
      setState(() {
        paymentbutton = true;
      });
    });
  }
}
