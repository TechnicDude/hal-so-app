import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/auth/changepassword.dart';
import 'package:halsogourmet/auth/forgetpassword.dart';
import 'package:halsogourmet/auth/login.dart';
import 'package:halsogourmet/auth/otpverification.dart';
import 'package:halsogourmet/auth/register.dart';
import 'package:halsogourmet/auth/setnewpassword.dart';
import 'package:halsogourmet/model/packagemodel.dart';
import 'package:halsogourmet/page_routes/routes.dart';
import 'package:halsogourmet/provider/foodcategoryprovider.dart';
import 'package:halsogourmet/provider/globalSearchprovider.dart';
import 'package:halsogourmet/provider/healthschoolprovider.dart';
import 'package:halsogourmet/provider/notificationprovider.dart';
import 'package:halsogourmet/provider/packageprovider.dart';
import 'package:halsogourmet/provider/myaddingredientsprovider.dart';
import 'package:halsogourmet/provider/planprovider.dart';
import 'package:halsogourmet/provider/profileprovider.dart';
import 'package:halsogourmet/provider/recipeprovider.dart';
import 'package:halsogourmet/provider/subcategoryprovider.dart';
import 'package:halsogourmet/provider/subsubcategoryprovider.dart';
import 'package:halsogourmet/provider/videoprovider.dart';
import 'package:halsogourmet/screens/details/watchvideo.dart';
import 'package:halsogourmet/screens/dises/meat/meatscreen.dart';
import 'package:halsogourmet/screens/home/allrecipe.dart';
import 'package:halsogourmet/screens/home/globalsearch.dart';
import 'package:halsogourmet/screens/home/healthschoolvideo.dart';
import 'package:halsogourmet/screens/home/healtschoolvideoplay.dart';
import 'package:halsogourmet/screens/home/homescreen.dart';
import 'package:halsogourmet/screens/introscreen/onboard.dart';
import 'package:halsogourmet/screens/mealplan/addingredientsplan.dart';
import 'package:halsogourmet/screens/mealplan/foodrecipe.dart';
import 'package:halsogourmet/screens/mealplan/ingredientlist.dart';
import 'package:halsogourmet/screens/mealplan/plan.dart';
import 'package:halsogourmet/screens/mealplan/planscreen.dart';
import 'package:halsogourmet/screens/myrefrigerator/myrefrigeratoringredients.dart';
import 'package:halsogourmet/screens/notification/notification.dart';
import 'package:halsogourmet/screens/package/billingaddress.dart';
import 'package:halsogourmet/screens/package/package.dart';
import 'package:halsogourmet/screens/package/payment.dart';
import 'package:halsogourmet/screens/package/paymentiosscreen.dart';
import 'package:halsogourmet/screens/profile/editprofile.dart';
import 'package:halsogourmet/screens/splash.dart';
import 'package:halsogourmet/utils/inroductionvideoscreen.dart';
import 'package:halsogourmet/utils/premiumpopup.dart';
import 'package:halsogourmet/utils/scheduleok.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:halsogourmet/utils/webviewapp.dart';
import 'package:halsogourmet/utils/webviewapppayment.dart';
import 'package:provider/provider.dart';
import '../screens/calories/caloriesscreen.dart';
import '../screens/details/fooddetails.dart';
import '../screens/dises/beaf/beafscreen.dart';
import '../screens/dises/protein/protein.dart';
import '../screens/home/bottomnav.dart';
import '../screens/homelunch/breakfast.dart';
import '../screens/introscreen/intro.dart';
import '../screens/profile/profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    Widget widgetScreen;
    switch (settings.name) {
      case Routes.splashScreen:
        widgetScreen = SplashScreen();
        break;
      case Routes.onBoard:
        widgetScreen = OnBoard();
        break;
      case Routes.homeScreen:
        widgetScreen = HomeScreen();
        break;
      case Routes.loginScreen:
        widgetScreen = LoginScreen();
        break;
      case Routes.signupScreen:
        widgetScreen = SignupScreen();
        break;
      case Routes.forgetPassword:
        widgetScreen = ForgetPassword();
        break;
      case Routes.otpVerify:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = OtpVerify(
          pagetype: args[StringFile.pagetype],
          email: args[StringFile.email],
        );
        break;
      case Routes.setnewPassword:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = SetnewPassword(
          userid: args[StringFile.userid],
          email: args[StringFile.email],
          otp: args[StringFile.otp],
        );
        break;

      case Routes.bottomNav:
        widgetScreen = BottomNav();
        break;
      // case Routes.breakfastScreen:
      //   widgetScreen = BreakfastScreen();
      //   break;

      case Routes.breakfastScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<FoodcategoriesProvider>(
          create: (BuildContext context) => FoodcategoriesProvider(),
          child: BreakfastScreen(
            foodtypeName: args[StringFile.foodtypeName],
            foodtypeId: args[StringFile.foodtypeId],
          ),
        );
        break;

      // case Routes.categoryScreen:
      //   widgetScreen = ChangeNotifierProvider<CategoriesProvider>(
      //       create: (BuildContext context) => CategoriesProvider(),
      //       child: CategoryScreen());
      //   break;
      // case Routes.lunchScreen:
      //   widgetScreen = LunchScreen();
      //   break;
      // case Routes.dinnerScreen:
      //   widgetScreen = DinnerScreen();
      //   break;
      case Routes.introScreen:
        widgetScreen = IntroScreen();
        break;

      case Routes.proteinScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<FoodsubcategoriesProvider>(
          create: (BuildContext context) => FoodsubcategoriesProvider(),
          child: ProteinScreen(
            foodtypeName: args[StringFile.foodtypeName],
            foodtypeId: args[StringFile.foodtypeId],
            type: args[StringFile.screenname],
            bannername: args[StringFile.bannertypes],
          ),
        );
        break;
      // case Routes.proteinScreen:
      //   widgetScreen = ProteinScreen();
      //   break;

      case Routes.meatScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<FoodsubsubcategoriesProvider>(
          create: (BuildContext context) => FoodsubsubcategoriesProvider(),
          child: MeatScreen(
            foodtypeName: args[StringFile.foodtypeName],
            foodtypeId: args[StringFile.foodtypeId],
          ),
        );
        break;

      case Routes.beafScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<RecipeProvider>(
          create: (BuildContext context) => RecipeProvider(),
          child: BeafScreen(
            foodtypeName: args[StringFile.foodtypeName],
            foodtypeId: args[StringFile.foodtypeId],
            isAnyCategory: args[StringFile.isAnyCategory],
            type: args[StringFile.screenname],
            bannername: args[StringFile.bannertypes],
          ),
        );
        break;
      case Routes.allrecipe:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<RecipeProvider>(
          create: (BuildContext context) => RecipeProvider(),
          child: AllRecipeScreenActivity(
            filtteropen: args[StringFile.filtteroption],
          ),
        );
        break;

      case Routes.ingredientListScreens:
        widgetScreen = IngredientListScreens();
        break;
      case Routes.myrefrigeratoringredients:
        widgetScreen = ChangeNotifierProvider<MyaddingredientsProvider>(
          create: (BuildContext context) => MyaddingredientsProvider(),
          child: MyrefrigeratoringredientsScreenActivity(),
        );

        break;

      case Routes.foodDetails:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<RecipeProvider>(
          create: (BuildContext context) => RecipeProvider(),
          child: args[StringFile.quantity] != null
              ? FoodDetails(
                  foodtypeName: args[StringFile.foodtypeName],
                  foodtypeId: args[StringFile.foodtypeId],
                  quantity: args[StringFile.quantity],
                  // callback: args[StringFile],

                  // recipedata: [],
                )
              : FoodDetails(
                  foodtypeName: args[StringFile.foodtypeName],
                  foodtypeId: args[StringFile.foodtypeId],

                  // callback: args[StringFile],

                  // recipedata: [],
                ),
        );
        break;

      // case Routes.foodDetails:
      //   widgetScreen = FoodDetails();
      //   break;

      case Routes.caloriesScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<FoodcategoriesProvider>(
          create: (BuildContext context) => FoodcategoriesProvider(),
          child: CaloriesScreen(
            foodtypeName: args[StringFile.foodtypeName],
            foodtypeId: args[StringFile.foodtypeId],
          ),
        );

        break;
      case Routes.profileScreen:
        widgetScreen = ChangeNotifierProvider<ProfileUserProvider>(
            create: (BuildContext context) => ProfileUserProvider(),
            child: ProfileScreen());
        break;

      case Routes.editProfile:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<ProfileUserProvider>(
            create: (BuildContext context) => ProfileUserProvider(),
            child: EditProfile(
              profileuserdata: args[StringFile.profileuserdata],
            ));
        break;

      case Routes.changePassword:
        widgetScreen = ChangePassword();
        break;
      case Routes.foodRecipe:
        widgetScreen = FoodRecipe();
        break;

      case Routes.planScreen:
        widgetScreen = ChangeNotifierProvider<PlanFoodcategoriesProvider>(
            create: (BuildContext context) => PlanFoodcategoriesProvider(),
            child: PlanScreen());
        break;
      case Routes.planshoplistScreen:
        widgetScreen = ChangeNotifierProvider<PlanFoodcategoriesProvider>(
            create: (BuildContext context) => PlanFoodcategoriesProvider(),
            child: PlanShopListScreen());
        break;
      case Routes.paymetIosuiScreen:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = PaymetIosuiScreen(
            packagedata: args[StringFile.package],
            index: args[StringFile.index],
            productidios: args[StringFile.appleproductid]);
        break;

      case Routes.webViewScreensShow:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = WebViewScreensShow(
          url: args[StringFile.url],
        );
        break;

      // case Routes.notificationScreen:
      //   Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
      //   widgetScreen = ChangeNotifierProvider<NotificationProvider>(
      //     create: (BuildContext context) => NotificationProvider(),
      //     child: NotificationScreen(
      //       text: args[StringFile.foodtypeId],
      //     ),
      //   );
      //   break;

      case Routes.notificationScreen:
        widgetScreen = ChangeNotifierProvider<NotificationProvider>(
            create: (BuildContext context) => NotificationProvider(),
            child: NotificationScreen());
        break;

      case Routes.watchVideo:
        widgetScreen = WatchVideo();
        break;
      // case Routes.healthSchoolVideo:
      //   widgetScreen = HealthSchoolVideo();
      //   break;
      case Routes.healthSchoolVideo:
        widgetScreen = ChangeNotifierProvider<HealthschoolProvider>(
            create: (BuildContext context) => HealthschoolProvider(),
            child: HealthSchoolVideo());
        break;

      case Routes.healthSchoolVideoPlay:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<HealthschoolProvider>(
            create: (BuildContext context) => HealthschoolProvider(),
            child: HealthSchoolVideoPlay(
              healthschooldata: args[StringFile.healthschool],
            ));
        break;
      case Routes.globalSearch:
        widgetScreen = ChangeNotifierProvider<GlobalsearchProvider>(
            create: (BuildContext context) => GlobalsearchProvider(),
            child: GlobaSerchScreenActivity());
        break;

      case Routes.packageScreen:
        widgetScreen = ChangeNotifierProvider<PackageProvider>(
            create: (BuildContext context) => PackageProvider(),
            child: PackageScreen());
        break;
      case Routes.videocreensShow:
        widgetScreen = ChangeNotifierProvider<VideoProvider>(
            create: (BuildContext context) => VideoProvider(),
            child: IntroductionVideoScreenActivity());
        break;
      case Routes.payment:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<PackageProvider>(
            create: (BuildContext context) => PackageProvider(),
            child: Payment(
              packagedata: args[StringFile.package],
            ));
        break;

      // case Routes.billingaddress:
      //   widgetScreen = Billingaddress();
      //   break;

      case Routes.billingaddress:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<PackageProvider>(
            create: (BuildContext context) => PackageProvider(),
            child: Billingaddress(
              packagedata: args[StringFile.package],
              index: args[StringFile.index],
            ));
        break;
      // case Routes.payment:
      //   widgetScreen = Payment();
      //   break;

      case Routes.scheduleOK:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = ChangeNotifierProvider<PlanFoodcategoriesProvider>(
            create: (BuildContext context) => PlanFoodcategoriesProvider(),
            child: ScheduleOK(
              dateTime: args[StringFile.datetime],
              foodtypeid: args[StringFile.foodttype],
              date: args[StringFile.date],
            ));

        break;

      case Routes.premiumPopup:
        widgetScreen = PremiumPopup();
        break;

      // case Routes.addinGredientsplan:
      //   widgetScreen = AddinGredientsplan();
      //   break;

      case Routes.addinGredientsplan:
        widgetScreen = ChangeNotifierProvider<MyaddingredientsProvider>(
          create: (BuildContext context) => MyaddingredientsProvider(),
          child: AddinGredientsplan(),
        );
        break;

      case Routes.webViewScreensShowPayment:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        widgetScreen = WebViewScreensShowPayment(
          url: args[StringFile.url],
        );
        break;

      default:
        widgetScreen = SplashScreen();
    }
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => widgetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  }
}
