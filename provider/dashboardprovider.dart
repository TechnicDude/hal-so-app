import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';

class DashBoradProvider extends ChangeNotifier {
  BannerListModel bannerListModel = BannerListModel();
  FoodtypeModel foodtypeModel = FoodtypeModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<FoodtypeData> _foodtypelist = [];
  List<FoodtypeData> get foodtypeList => _foodtypelist;

  bool datanotfound = false;
  String countnotification = "0";
  Future bannerlist(String bannertype) async {
    ServiceWithoutbody _service =
        new ServiceWithoutbody(APIURL.BANNERURL + bannertype);
    final response = await _service.data();
    bannerListModel = BannerListModel.fromJson(response);
    if (bannerListModel.data != null) {
      if (bannerListModel.data!.isNotEmpty) {
        _bannerlist = [];
        for (int i = 0; i < bannerListModel.data!.length; i++) {
          _bannerlist.add(bannerListModel.data![i]);
        }
      }
    }
    notifyListeners();
    return;
  }

  Future foodtypelist() async {
    ServiceWithHeader _service = new ServiceWithHeader(APIURL.foodtype);
    final response = await _service.datawithoutheader();

    foodtypeModel = FoodtypeModel.fromJson(response);
    if (foodtypeModel.data != null) {
      if (foodtypeModel.data!.isNotEmpty) {
        _foodtypelist = [];
        for (int i = 0; i < foodtypeModel.data!.length; i++) {
          _foodtypelist.add(foodtypeModel.data![i]);
        }
      }
    }
    notifyListeners();
    return;
  }

  Future notificationcount() async {
    ServiceWithHeader _service =
        new ServiceWithHeader(APIURL.notificationcount);
    final response = await _service.datame();

    if (response['status'] == "success") {
      countnotification = response['data'].toString();
    }

    notifyListeners();
    return;
  }
}
