import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/subcategorymodel.dart';

class FoodsubcategoriesProvider extends ChangeNotifier {
  BannerListModel bannerListModel = BannerListModel();
  SubcategoryModel subcategoryModel = SubcategoryModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<SubcategoryData> _foodsubcategorieslist = [];
  List<SubcategoryData> get foodsubcategoriesList => _foodsubcategorieslist;
  bool datanotfound = false;

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

  Future foodsubcategorieslist(String subcategoryname, String type) async {
    datanotfound = false;
    print("object data");
    var protein = MyApp.filterprotein ? MyApp.protein : "null";
    var fat = MyApp.filterfat ? MyApp.fat : "null";
    var carbohydrate = MyApp.filtercarbohydrate ? MyApp.carbohydrate : "null";
    var calorie = MyApp.filtercalorie ? MyApp.calorie : "null";
    var url = APIURL.FOODSUBCATEGORY + "?$type=" + subcategoryname;
    // +
    // "&protein=$protein";
    // +
    // "&fat=$fat" +
    // "&carbohydrate=$carbohydrate" +
    // "&calorie=$calorie";
    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    subcategoryModel = SubcategoryModel.fromJson(response);

    _foodsubcategorieslist = [];
    if (subcategoryModel.data != null) {
      if (subcategoryModel.data!.length > 0) {
        print(subcategoryModel.data!.length);

        // _categorylist.addAll(mainmodeldata.data.categoryList);

        for (int i = 0; i < subcategoryModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _foodsubcategorieslist.add(subcategoryModel.data![i]);
        }
      } else {
        datanotfound = true;
      }
    }
    datanotfound = true;
    notifyListeners();
    return;
  }
}
