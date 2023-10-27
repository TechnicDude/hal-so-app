import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/api/loginapi.dart';
import 'package:halsogourmet/auth/locdb.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/screens/package/consumable_store.dart';
import 'package:halsogourmet/screens/package/paymetutils.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/image_file.dart';
import 'package:halsogourmet/utils/internet_not_connected.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pay/pay.dart' as pay;
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

// const _paymentItems = [
//   pay.PaymentItem(
//     label: 'Total',
//     amount: '0.01',
//     status: pay.PaymentItemStatus.final_price,
//   ),
// ];

class PaymetIosuiScreen extends StatefulWidget {
  final PackageData packagedata;
  final int index;
  final String productidios;
  const PaymetIosuiScreen({
    super.key,
    required this.packagedata,
    required this.index,
    required this.productidios,
  });

  @override
  State<PaymetIosuiScreen> createState() => _PaymetIosuiScreenState();
}

class _PaymetIosuiScreenState extends State<PaymetIosuiScreen> {
  final bool _kAutoConsume = true;

  String _kConsumableId = '';
  // final String _kUpgradeId = 'upgrade';
  // final String _kSubscriptionId = 'HA23PAKsub';
  // final String _kGoldSubscriptionId = 'subscription_gold';
//  List<String> _kProductIds = <String>[
//   // _kConsumableId,
//   // _kUpgradeId,
//   _kSubscriptionId,
//   _kSubscriptionId,
//   // _kGoldSubscriptionId,
// ];

  List<String> _kiOSProductIds = <String>[];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _kiOSProductIds.add(widget.productidios);
    setState(() {
      _kConsumableId = widget.productidios;
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    print(purchaseUpdated);
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();

    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kiOSProductIds.toSet());
    print("object productDetailResponse $productDetailResponse");
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    log("consumables");
    log(consumables.toString());
    log(consumables.length.toString());
    if (consumables.isNotEmpty) {
      for (int i = (consumables.length - 1); i >= 0; i--) {
        print("object done ");
        try {
          var body = {"appleTransactionId": consumables[i]};
          LoginApi loginApi = LoginApi(body);
          final response = await loginApi.iostransactionsupdateuser();
          print(response.toString());
          if (response['status'] == 'success') {
            LocDb().isLoggedIn();
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.bottomNav, (route) => false);
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // _buildConnectionCheckTile(),
              _buildProductList(),
              // _buildConsumableBox(),
              // _buildRestoreButton(),
            ],
          ),
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        // TODO(goderbauer): Make this const when that's available on stable.
        // ignore: prefer_const_constructors
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), child: AppBarScreens()),
      body: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? InternetNotAvailable()
          : Stack(
              children: stack,
            ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable
              ? Colors.green
              : ThemeData.light().colorScheme.error),
      title:
          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    ListTile productHeader = ListTile(
        title: Text(
      'Your Plan',
      style: Style_File.title,
    ));
    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
          title: Center(
            child: Text(
              productDetails.title,
            ),
          ),
          subtitle: Column(
            children: [
              Text(
                productDetails.description,
              ),
              // previousPurchase != null
              //     ? IconButton(
              //         onPressed: () => confirmPriceChange(context),
              //         icon: const Icon(Icons.upgrade))
              //     :
              TextButton(
                style: TextButton.styleFrom(
                  // backgroundColor: Colors.green[800],
                  // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
                  // ignore: deprecated_member_use
                  primary: Colors.white,
                ),
                onPressed: () async {
                  late PurchaseParam purchaseParam;

                  purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                  );

                  if (productDetails.id == _kConsumableId) {
                    var data = await _inAppPurchase.buyConsumable(
                        purchaseParam: purchaseParam,
                        autoConsume: _kAutoConsume);
                  } else {
                    _inAppPurchase.buyNonConsumable(
                        purchaseParam: purchaseParam);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: colorSecondry,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   ImageFile.applelogo,
                            //   fit: BoxFit.fill,
                            //   width: 10.w,
                            //   height: 10.w,
                            // ),
                            // Icon(
                            //   Icons.apple,
                            //   color: Colors.white,
                            // ),
                            Text(
                              "Continue  ${productDetails.price}",
                              textAlign: TextAlign.center,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              if (Platform.isIOS)
                Text(
                  "  • Payment will be charged to iTunes Account at confirmation of purchase. \n  • Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. \n  • Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. \n  • Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. \n  • No cancellation of the current subscription is allowed during active subscription period. \n  • Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.",
                  style: Style_File.subtitle.copyWith(fontSize: 14.sp),
                  // textAlign: TextAlign.center,
                ),
              if (Platform.isIOS)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.webViewScreensShow, arguments: {
                            StringFile.url:
                                "https://halsogourmet.com/terms-conditions/"
                          });
                        },
                        child: Text(
                          "Terms of Use ",
                          style:
                              Style_File.subtitle.copyWith(color: Colors.blue),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.webViewScreensShow, arguments: {
                            StringFile.url:
                                "https://halsogourmet.com/privacy-policy/"
                          });
                        },
                        child: Text(
                          "Privacy policy",
                          style:
                              Style_File.subtitle.copyWith(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
          // trailing: previousPurchase != null
          //     ? IconButton(
          //         onPressed: () => confirmPriceChange(context),
          //         icon: const Icon(Icons.upgrade))
          //     : TextButton(
          //         style: TextButton.styleFrom(
          //           backgroundColor: Colors.green[800],
          //           // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
          //           // ignore: deprecated_member_use
          //           primary: Colors.white,
          //         ),
          //         onPressed: () {
          //           late PurchaseParam purchaseParam;

          //           purchaseParam = PurchaseParam(
          //             productDetails: productDetails,
          //           );

          //           if (productDetails.id == _kConsumableId) {
          //             _inAppPurchase.buyConsumable(
          //                 purchaseParam: purchaseParam,
          //                 autoConsume: _kAutoConsume);
          //           } else {
          //             _inAppPurchase.buyNonConsumable(
          //                 purchaseParam: purchaseParam);
          //           }
          //         },
          //         child: Text(productDetails.price),
          //       ),
        );
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...')));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));

    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      const Divider(),
      GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: tokens,
      )
    ]));
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
              // ignore: deprecated_member_use
              primary: Colors.white,
            ),
            onPressed: () {
              _inAppPurchase.restorePurchases();
              log(_inAppPurchase.restorePurchases().toString());
            },
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();

    setState(() {
      log(consumables.toString());
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      log("consumables ${consumables.toString()}");
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
      try {
        var purchaseIDs;
        if (purchaseDetails.purchaseID != null) {
          if (purchaseDetails is AppStorePurchaseDetails) {
            final originalTransaction =
                purchaseDetails.skPaymentTransaction.originalTransaction;
            if (originalTransaction != null) {
              purchaseIDs = originalTransaction.transactionIdentifier!;
              var body = {"appleTransactionId": purchaseIDs.toString()};
              LoginApi loginApi = LoginApi(body);
              final response = await loginApi.iostransactionsupdateuser();
              print(response.toString());
              if (response['status'] == 'success') {
                LocDb().isLoggedIn();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.bottomNav, (route) => false);
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
      try {
        var purchaseIDs;
        if (purchaseDetails.purchaseID != null) {
          if (purchaseDetails is AppStorePurchaseDetails) {
            final originalTransaction =
                purchaseDetails.skPaymentTransaction.originalTransaction;
            if (originalTransaction != null) {
              purchaseIDs = originalTransaction.transactionIdentifier!;
              var body = {"appleTransactionId": purchaseIDs.toString()};
              LoginApi loginApi = LoginApi(body);
              final response = await loginApi.iostransactionsupdateuser();
              print(response.toString());
              if (response['status'] == 'success') {
                LocDb().isLoggedIn();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.bottomNav, (route) => false);
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      try {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          showPendingUI();
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            handleError(purchaseDetails.error!);
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            final bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
              deliverProduct(purchaseDetails);
            } else {
              _handleInvalidPurchase(purchaseDetails);
              return;
            }
          }

          if (purchaseDetails.pendingCompletePurchase) {
            print("purchaseDetails $purchaseDetails");
            print("object ${purchaseDetails.purchaseID}");
            log("object verificationData localVerificationData ${purchaseDetails.verificationData.localVerificationData}");
            log("object verificationData serverVerificationData ${purchaseDetails.verificationData.serverVerificationData}");
            log("object verificationData ${purchaseDetails.verificationData.source}");

            await _inAppPurchase.completePurchase(purchaseDetails);
            try {
              var purchaseIDs;
              if (purchaseDetails.purchaseID != null) {
                if (purchaseDetails is AppStorePurchaseDetails) {
                  final originalTransaction =
                      purchaseDetails.skPaymentTransaction.originalTransaction;
                  if (originalTransaction != null) {
                    purchaseIDs = originalTransaction.transactionIdentifier!;
                    var body = {"appleTransactionId": purchaseIDs.toString()};
                    LoginApi loginApi = LoginApi(body);
                    final response = await loginApi.iostransactionsupdateuser();
                    print(response.toString());
                    if (response['status'] == 'success') {
                      LocDb().isLoggedIn();
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.bottomNav, (route) => false);
                    }
                  }
                }
              }
            } catch (e) {
              print(e);
            }
          }
        }
      } catch (e) {
        print("error $e");
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
