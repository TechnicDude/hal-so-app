import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/createcaloriefiltersModel.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';

class FoodcategoriesProvider extends ChangeNotifier {
  BannerListModel bannerListModel = BannerListModel();

  FoodcategoryModel foodcategoryModel = FoodcategoryModel();
  CreatecaloriefiltersModel createcaloriefiltersModel =
      CreatecaloriefiltersModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<FoodcategoryData> _foodcategorieslist = [];
  List<FoodcategoryData> get foodcategoriesList => _foodcategorieslist;

  bool datanotfound = false;

  Future createcaloriefilters(String date, String id) async {
    ServiceWithHeader _service = new ServiceWithHeader(
        APIURL.caloriefilters + "?date=$date&foodTypeId=$id");
    final response = await _service.data();
    createcaloriefiltersModel = CreatecaloriefiltersModel.fromJson(response);

    notifyListeners();
    return;
  }

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

  Future foodcategorylist(String subcategoryname) async {
    print("object data");
    var protein = MyApp.filterprotein ? MyApp.protein : "null";
    var fat = MyApp.filterfat ? MyApp.fat : "null";
    var carbohydrate = MyApp.filtercarbohydrate ? MyApp.carbohydrate : "null";
    var calorie = MyApp.filtercalorie ? MyApp.calorie : "null";
    var url = APIURL.FOODCATEGORY + "?foodType=" + subcategoryname
        // +
        // "&protein=$protein"
        // +
        // "&fat=$fat" +
        // "&carbohydrate=$carbohydrate" +
        // "&calorie=$calorie";
        ;

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    foodcategoryModel = FoodcategoryModel.fromJson(response);

    _foodcategorieslist = [];
    if (foodcategoryModel.data != null) {
      if (foodcategoryModel.data!.length > 0) {
        print(foodcategoryModel.data!.length);

        // _categorylist.addAll(mainmodeldata.data.categoryList);

        for (int i = 0; i < foodcategoryModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _foodcategorieslist.add(foodcategoryModel.data![i]);
        }
      }
    }
    datanotfound = true;
    notifyListeners();
    return;
  }
}
