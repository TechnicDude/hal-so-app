import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/subcategorymodel.dart';
import 'package:halsogourmet/model/subsubcategorymodel.dart';

class FoodsubsubcategoriesProvider extends ChangeNotifier {
  BannerListModel bannerListModel = BannerListModel();
  SubsubcategoryModel subsubcategoryModel = SubsubcategoryModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<SubsubcategoryData> _foodsubsubcategorieslist = [];
  List<SubsubcategoryData> get foodsubsubcategoriesList =>
      _foodsubsubcategorieslist;

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

  Future foodsubsubcategorieslist(String subcategoryname) async {
    datanotfound = false;
    print("object data");
    var protein = MyApp.filterprotein ? MyApp.protein : "null";
    var fat = MyApp.filterfat ? MyApp.fat : "null";
    var carbohydrate = MyApp.filtercarbohydrate ? MyApp.carbohydrate : "null";
    var calorie = MyApp.filtercalorie ? MyApp.calorie : "null";
    var url = APIURL.FOODSUBSUBCATEGORY + "?subCategoryId=" + subcategoryname;
    // +
    // "&protein=$protein";
    // +
    // "&fat=$fat" +
    // "&carbohydrate=$carbohydrate" +
    // "&calorie=$calorie";

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    subsubcategoryModel = SubsubcategoryModel.fromJson(response);

    _foodsubsubcategorieslist = [];
    if (subsubcategoryModel.data != null) {
      if (subsubcategoryModel.data!.length > 0) {
        print(subsubcategoryModel.data!.length);

        // _categorylist.addAll(mainmodeldata.data.categoryList);

        for (int i = 0; i < subsubcategoryModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _foodsubsubcategorieslist.add(subsubcategoryModel.data![i]);
        }
      } else {
        datanotfound = true;
      }
    }

    notifyListeners();

    return;
  }
}
