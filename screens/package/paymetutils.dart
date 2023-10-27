// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:halsogourmet/api/payment.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/dialog_helper.dart';
import 'package:http/http.dart' as http;

class PaymentUtils {
  Map<String, dynamic>? paymentIntent;
  var _customer;
  String subid = "";
  makePayment(
      String amount,
      String total,
      String packageID,
      PackageData packageData,
      Prices price,
      String billingAddress,
      String productid,
      String city,
      String country,
      String line,
      String postalcode,
      String state,
      String useremail,
      String username,
      String isRecurring,
      String cardnumber,
      String cvv,
      String months,
      String cardyear,
      String couponcode,
      BuildContext context) async {
    subid = "";
    // var body = {
    //   "packageId": packageID,
    //   "priceId": price.id,
    // };
    // PaymentApi paymentApi = PaymentApi(body);
    // final response = await paymentApi.subscriptionscreate();
    // print(response);
    try {
      await subscriptions(
          productid,
          amount,
          city,
          country,
          line,
          postalcode,
          state,
          useremail,
          username,
          isRecurring,
          cardnumber,
          cvv,
          months,
          cardyear,
          billingAddress,
          total,
          amount,
          couponcode,
          context);
      log("_customer $_customer");
      if (isRecurring != 'true') {
        if (_customer!.isNotEmpty) {
          paymentIntent = await createPaymentIntent(
              amount,
              'SEK',
              price.id.toString(),
              packageID,
              total,
              amount,
              billingAddress,
              productid,
              _customer['id']);

          //STEP 2: Initialize Payment Sheet

          await Stripe.instance
              .initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                      // customFlow: true,
                      customerId: _customer['id'],
                      paymentIntentClientSecret: paymentIntent![
                          'client_secret'], //Gotten from payment intent
                      // applePay:
                      //     const PaymentSheetApplePay(merchantCountryCode: '+46'),
                      style: ThemeMode.dark,
                      merchantDisplayName: 'Hälsogourmet'))
              .then((value) => {
                    // print(value.);
                  });
          // await Stripe.instance.presentPaymentSheet();

          //STEP 3: Display Payment sheet
          displayPaymentSheet(context);
        } else {
          subscriptions(
              productid,
              amount,
              city,
              country,
              line,
              postalcode,
              state,
              useremail,
              username,
              isRecurring,
              cardnumber,
              cvv,
              months,
              cardyear,
              billingAddress,
              total,
              amount,
              couponcode,
              context);
        }
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Betalning genomförd!"),
                    ],
                  ),
                ));
        print(paymentIntent);
        log(paymentIntent.toString());

        paymentIntent = null;
        paymentsbutton(context);
      }).onError((error, stackTrace) {
        print(paymentIntent);
        log(paymentIntent.toString());
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print(paymentIntent);
      log(paymentIntent.toString());
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Betalning misslyckades"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>> _createCustomer(
    String city,
    String country,
    String line,
    String postalcode,
    String state,
    String useremail,
    String username,
  ) async {
    final String url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'description': username,
        'email': useremail,
        'address[city]': city,
        'address[country]': country,
        'address[line1]': line,
        'address[postal_code]': postalcode,
        'address[state]': state,
        // 'coupon': '38MRHW3s',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Det gick inte att registrera sig som kund.';
    }
  }

  createPaymentIntent(
    String amount,
    String currency,
    String priceId,
    String packageID,
    String totalAmount,
    String paidAmount,
    String billingAddress,
    String productid,
    String customerid,
  ) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'customer': customerid,
        'metadata[priceId]': priceId,
        'metadata[userID]': MyApp.userid,
        'metadata[packageID]': packageID,
        'metadata[totalAmount]': (int.parse(totalAmount) * 100).toString(),
        'metadata[paidAmount]': (int.parse(paidAmount) * 100).toString(),
        'metadata[billingAddress]': billingAddress,
        'automatic_payment_methods[enabled]': 'true',
      };
      if (subid != "") {
        body['metadata[stripeSubscriptionId]'] = subid;
      }

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log("message createpayment ${response.body}");

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Map<String, dynamic>> _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to create PaymentMethod.';
    }
  }

  Future<Map<String, dynamic>> _updateCustomer(
      String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Det gick inte att uppdatera kunden.';
    }
  }

  Future<Map<String, dynamic>> _createSubscriptions(
      String customerId,
      String currency,
      String priceid,
      String packageID,
      String totalAmount,
      String paidAmount,
      String billingAddress,
      String couponcode,
      BuildContext context) async {
    final String url = 'https://api.stripe.com/v1/subscriptions';

    Map<String, dynamic> body = {
      'customer': customerId,

      'metadata[priceId]': priceid,
      'metadata[userID]': MyApp.userid,
      'metadata[packageID]': packageID,
      'metadata[totalAmount]': (int.parse(totalAmount) * 100).toString(),
      'metadata[paidAmount]': (int.parse(paidAmount) * 100).toString(),
      'metadata[billingAddress]': billingAddress,

      // 'items[0][currency]': currency,
      // 'items[0][product]': productid,
      // 'items[0][recurring][interval]': 'day',
    };
    if (couponcode != '') {
      body['coupon'] = couponcode;
    }
    if (priceid != '') {
      body['items[0][price]'] = priceid;
    } else {}
    print(url);
    print(body);

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body);
    if (response.statusCode == 200) {
      log(response.body);
      var getdata = json.decode(response.body);
      if (getdata['status'] == 'active') {
        paymentsbutton(context);
        DialogHelper.showFlutterToast(strMsg: "Login Successful");
      }
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Det gick inte att registrera sig som prenumerant.';
    }
  }

  Future<Map<String, dynamic>> _createprice(String amount, String currency,
      String productid, String isRecurring) async {
    final String url = 'https://api.stripe.com/v1/prices';

    Map<String, dynamic> body = {
      'unit_amount': (int.parse(amount) * 100).toString(),
      'currency': currency,
      'product': productid,
    };
    if (isRecurring.toString().toLowerCase() == "true") {
      body['recurring[interval]'] = 'month';
    }

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body);
    if (response.statusCode == 200) {
      log(response.body);
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Det gick inte att registrera sig som prenumerant.';
    }
  }

  Future<void> subscriptions(
      String productid,
      String amount,
      String city,
      String country,
      String line,
      String postalcode,
      String state,
      String useremail,
      String username,
      String isRecurring,
      String cardnumber,
      String cvc,
      String cardmonth,
      String cardyears,
      String billingAddress,
      String totalAmount,
      String paidAmount,
      String couponcode,
      BuildContext context) async {
    _customer = await _createCustomer(
        city, country, line, postalcode, state, useremail, username);
    log("message _customer $_customer");

    var _createprices;
    if (isRecurring == 'true') {
      final _paymentMethod = await _createPaymentMethod(
          number: cardnumber,
          expMonth: cardmonth,
          expYear: cardyears,
          cvc: cvc);
      // log("message _paymentMethod $_paymentMethod");
      final _attachPayment =
          await _attachPaymentMethod(_paymentMethod['id'], _customer['id']);
      // log("message _attachPayment$_attachPayment");
      final _updatecou =
          await _updateCustomer(_paymentMethod['id'], _customer['id']);
      // log("message _updatecou$_updatecou");\
      _createprices = await _createprice(amount, 'SEK', productid, isRecurring);
    }

    if (isRecurring == 'true') {
      final _createSubscription = await _createSubscriptions(
          _customer['id'],
          'SEK',
          _createprices['id'],
          productid,
          totalAmount,
          paidAmount,
          billingAddress,
          couponcode,
          context);
      subid = _createSubscription['id'];
      log("message subid $subid");
      log("message  _createSubscription$_createSubscription");
    }
  }

  Future<Map<String, dynamic>> _attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to attach PaymentMethod.';
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future paymentsbutton(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      MyApp.subscriptioncheck = true;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.splashScreen, (route) => false);
    });
  }
}
