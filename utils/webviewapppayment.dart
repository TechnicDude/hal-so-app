import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../auth/locdb.dart';

class WebViewScreensShowPayment extends StatefulWidget {
  final String url;
  WebViewScreensShowPayment({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreensShowPayment> createState() =>
      _WebViewScreensShowPaymentState();
}

class _WebViewScreensShowPaymentState extends State<WebViewScreensShowPayment> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () async {
              refresScreen(context);
              //Navigator.pushNamed(context, Routes.splashScreen);
              //await LocDb().isLoggedIn();
              //ServiceWithHeader service = ServiceWithHeader(APIURL.ME);
              //var data = await service.datame();
              //  var subscriptioncheck = response['user']['isSubscription'];
              //  return data;
              //Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: colorBlack,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorWhite,
        title: Text(
          "Fakturaadress",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
          ),
          if (loadingPercentage < 100)
            Center(
              child: CircularProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
            ),
        ],
      ),
    );
  }

  Future refresScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      MyApp.subscriptioncheck = true;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.splashScreen, (route) => false);
    });
  }
}
