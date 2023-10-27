import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/auth/login.dart';
import 'package:halsogourmet/provider/dashboardprovider.dart';
import 'package:halsogourmet/provider/favoriterecipeprovider.dart';
import 'package:halsogourmet/provider/planprovider.dart';
import 'package:halsogourmet/provider/profileprovider.dart';
import 'package:halsogourmet/provider/subcategoryprovider.dart';
import 'package:halsogourmet/screens/calories/caloriesscreen.dart';
import 'package:halsogourmet/screens/dises/beaf/beafscreen.dart';
import 'package:halsogourmet/screens/dises/beaf/beafui.dart';
import 'package:halsogourmet/screens/dises/protein/protein.dart';
import 'package:halsogourmet/screens/home/favoriterecipescreen.dart';
import 'package:halsogourmet/screens/homelunch/breakfast.dart';
import 'package:halsogourmet/screens/mealplan/foodrecipe.dart';
import 'package:halsogourmet/screens/mealplan/plan.dart';
import 'package:halsogourmet/utils/showExitPopup.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/colors.dart';
import '../profile/profile.dart';
import 'homescreen.dart';

class BottomNav extends StatefulWidget {
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  var selectedPage = [
    ChangeNotifierProvider<DashBoradProvider>(
        create: (BuildContext context) => DashBoradProvider(),
        child: HomeScreen()),
    ChangeNotifierProvider<PlanFoodcategoriesProvider>(
        create: (BuildContext context) => PlanFoodcategoriesProvider(),
        child: PlanScreen()),
    ChangeNotifierProvider<FavoriterecipeProvider>(
        create: (BuildContext context) => FavoriterecipeProvider(),
        child: FavoriteRecipeScreen(
          type: '',
        )),
    ChangeNotifierProvider<ProfileUserProvider>(
        create: (BuildContext context) => ProfileUserProvider(),
        child: ProfileScreen()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        body: SafeArea(child: selectedPage[selectedIndex]),
        bottomNavigationBar: CurvedNavigationBar(
          // height: 75,
          backgroundColor: colorWhite,
          buttonBackgroundColor: colorGrey,
          color: colorSecondry,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 25,
              color: colorWhite,
            ),
            Icon(
              Icons.calendar_month_rounded,
              size: 25,
              color: colorWhite,
            ),
            Icon(
              Icons.favorite,
              size: 25,
              color: colorWhite,
            ),
            Icon(
              Icons.account_circle_sharp,
              size: 25,
              color: colorWhite,
            ),
          ],
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }
}
