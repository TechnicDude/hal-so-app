import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/auth/locdb.dart';
import 'package:halsogourmet/firebase_options.dart';
import 'package:halsogourmet/page_routes/route_generate.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/utils/firebasenotificationutils.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  return FirebaseNotificationUtils().showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHKEY']!;

  Stripe.merchantIdentifier = 'merchant.com.halsogourmet';
  await Stripe.instance.applySettings();

  LocDb().loginapp = await LocDb().isLoggedIn();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static String? userid;
  static String? AUTH_TOKEN_VALUE;
  static String? email_VALUE;
  static String? protein;
  static String? calorie;
  static String? fat;
  static String? carbohydrate;
  static String? remaincalorie;
  static DateTime? Date;
  static bool filterdate = false;
  static bool filterprotein = false;
  static bool filtercalorie = false;
  static bool filterfat = false;
  static bool filtercarbohydrate = false;
  static bool subscriptioncheck = false;
  static String subscriptionstartdate = '';
  static String subscriptionenddate = '';
  static String stripeSubscriptionId = '';
  static bool isRecurring = false;
  static bool subscriptionDeleted = false;
  static bool subscriptionapplepay = false;

  static logout() async {
    // googleSignIn.disconnect();
    LikeApi loginApi = LikeApi();
    final response = await loginApi.fcmlogout();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setString(StringFile.onBoard, "0");
    subscriptioncheck = false;
    userid = null;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return StreamProvider<InternetConnectionStatus>(
        initialData: InternetConnectionStatus.connected,
        create: (_) {
          return InternetConnectionChecker().onStatusChange;
        },
        child: const MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('sv', ''),
            Locale('se', ''),
          ],
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splashScreen,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      );
    });
  }
}
