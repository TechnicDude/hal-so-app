import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/calendarsDateModel.dart';
import 'package:halsogourmet/model/weeklyingredientmodel.dart';

class PlanFoodcategoriesProvider extends ChangeNotifier {
  List<CalendarsDateModel> _calendardata = [];
  List<CalendarsDateModel> get calendarList => _calendardata;

  WeeklyingredientModel weeklyingredientModel = WeeklyingredientModel();
  List<WeeklyingredientData> _weeklyingredientlist = [];
  List<WeeklyingredientData> get weeklyingredientList => _weeklyingredientlist;
  bool weeklyingredientListfetch = false;

  // Future calendarlist(String date) async {
  //   var url = APIURL.Calendarsdate + date;
  //   ServiceWithHeader _service = new ServiceWithHeader(url);
  //   final response = await _service.data();
  //   _finalcalenderList = [];
  //   var responsecalendar = response['data'];
  //   assert(responsecalendar is List);
  //   for (int i = 0; i < responsecalendar.length; i++) {
  //     var calendarloop = responsecalendar[i];
  //     _calendardata = [];

  //     assert(calendarloop is List);
  //     for (int j = 0; j < calendarloop.length; j++) {
  //       _calendardata.add(CalendarsDateModel.fromJson(calendarloop[j]));
  //     }
  //     if (_calendardata.isNotEmpty) {
  //       FinalCalendarsDateModel datafinal =
  //           FinalCalendarsDateModel(calendarrecipes: _calendardata);
  //       _finalcalenderList.add(datafinal);
  //     }
  //   }

  //   notifyListeners();
  //   return;
  // }

  Future calendarlist(String date) async {
    var url = APIURL.Calendarsdate + date;
    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();
    _calendardata = [];
    var responsecalendar = response['data'];
    assert(responsecalendar is List);
    for (int i = 0; i < responsecalendar.length; i++) {
      _calendardata.add(CalendarsDateModel.fromJson(responsecalendar[i]));
    }

    notifyListeners();
    return;
  }

  Future weeklyingredientlist(String date) async {
    print("object data");

    var url = APIURL.WeeklyIngredient + date;

    ServiceWithHeader _service = ServiceWithHeader(url);
    final response = await _service.data();
    weeklyingredientModel = WeeklyingredientModel.fromJson(response);

    _weeklyingredientlist = [];
    if (weeklyingredientModel.data != null) {
      if (weeklyingredientModel.data!.length > 0) {
        print(weeklyingredientModel.data!.length);
        for (int i = 0; i < weeklyingredientModel.data!.length; i++) {
          _weeklyingredientlist.add(weeklyingredientModel.data![i]);
        }
      }
    }
    weeklyingredientListfetch = true;
    notifyListeners();
    return;
  }
}
