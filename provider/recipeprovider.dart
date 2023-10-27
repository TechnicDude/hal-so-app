import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/recipebyidmodel.dart';
import 'package:halsogourmet/model/recipemodel.dart';
import 'package:halsogourmet/model/relatedrecipemodel.dart';
import 'package:halsogourmet/model/reviewmodel.dart';
import 'package:halsogourmet/model/subcategorymodel.dart';
import 'package:halsogourmet/model/subsubcategorymodel.dart';

class RecipeProvider extends ChangeNotifier {
  int pageNumrecipe = 1;
  BannerListModel bannerListModel = BannerListModel();
  RecipeModel recipeModel = RecipeModel();
  RecipebyIdModel recipeModelbyid = RecipebyIdModel();
  RelatedrecipeModel relatedrecipeModel = RelatedrecipeModel();

  ReviewModel reviewModel = ReviewModel();
  FoodtypeModel foodtypeModel = FoodtypeModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<RecipeData> _recipelist = [];
  List<RecipeData> get recipeList => _recipelist;

  bool datanotfound = false;
  bool isFirstdatafound = true;
  bool isLoadMoreRunning = false;
  bool hasfirst = true;

  List<RecipeData> _recipelistbyid = [];
  List<RecipeData> get recipeListbyid => _recipelistbyid;
  bool datanotbyidfound = false;

  List<RelatedRecipeData> _reletedrecipelist = [];
  List<RelatedRecipeData> get reletedrecipeList => _reletedrecipelist;
  bool datanotbyrelatedrecipefound = false;

  List<ReviewData> _reviewlist = [];
  List<ReviewData> get reviewList => _reviewlist;

  List<FoodtypeData> _foodtypelist = [];
  List<FoodtypeData> get foodtypeList => _foodtypelist;

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

  Future recipelist(String subcategoryname, int page, String type) async {
    if (page == 1) {
      datanotfound = false;
      isFirstdatafound = true;
    }

    var protein = MyApp.protein != null ? MyApp.protein : "null";
    var fat = MyApp.fat != null ? MyApp.fat : "null";
    var carbohydrate = MyApp.carbohydrate != null ? MyApp.carbohydrate : "null";
    var calorie = MyApp.calorie != null ? MyApp.calorie : "null";

    print("object data");
    var url = APIURL.RECIPE +
        "?$type=" +
        subcategoryname +
        "&limit=7" +
        "&page=$page";
    // +
    // "&protein=$protein" +
    // "&fat=$fat" +
    // "&carbohydrate=$carbohydrate" +
    // "&calorie=$calorie";

    ServiceWithHeader _service = ServiceWithHeader(url);

    final response = await _service.data();
    recipeModel = RecipeModel.fromJson(response);
    if (page == 1) {
      _recipelist = [];
    }

    if (recipeModel.data != null) {
      if (recipeModel.data!.length > 0) {
        print(recipeModel.data!.length);
        for (int i = 0; i < recipeModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _recipelist.add(recipeModel.data![i]);
        }
      } else {
        if (page == 1) {
          datanotfound = true;
        }
        hasfirst = false;
      }
    } else {
      if (page == 1) {
        datanotfound = true;
      }
      hasfirst = false;
    }
    isFirstdatafound = false;
    print(hasfirst);
    print(_recipelist);
    notifyListeners();
    return;
  }

  Future recipelistfoodtype(String subcategoryname, int page) async {
    if (page == 1) {
      datanotfound = false;
      isFirstdatafound = true;
    }
    var protein = MyApp.filterprotein ? MyApp.protein : "null";
    var fat = MyApp.filterfat ? MyApp.fat : "null";
    var carbohydrate = MyApp.filtercarbohydrate ? MyApp.carbohydrate : "null";
    var calorie = MyApp.filtercalorie ? MyApp.calorie : "null";

    print("object data");
    var url = APIURL.RECIPE +
        "?foodtype=" +
        subcategoryname +
        "&limit=7" +
        "&page=$page";
    // +
    // "&protein=$protein";
    // +
    // "&fat=$fat" +
    // "&carbohydrate=$carbohydrate" +
    // "&calorie=$calorie";
    ServiceWithHeader _service = ServiceWithHeader(url);

    final response = await _service.data();
    recipeModel = RecipeModel.fromJson(response);
    if (page == 1) {
      _recipelist = [];
    }

    if (recipeModel.data != null) {
      if (recipeModel.data!.length > 0) {
        print(recipeModel.data!.length);
        for (int i = 0; i < recipeModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _recipelist.add(recipeModel.data![i]);
        }
      } else {
        if (page == 1) {
          datanotfound = true;
        }
        hasfirst = false;
      }
    } else {
      if (page == 1) {
        datanotfound = true;
      }
      hasfirst = false;
    }
    isFirstdatafound = false;

    notifyListeners();
    return;
  }

  Future allrecipelist(int page, String foodtype, String search) async {
    if (page == 1) {
      datanotfound = false;
      isFirstdatafound = true;
    }

    var url =
        APIURL.RECIPE + "?refrigerator=$foodtype&page=$page&search=$search";

    ServiceWithHeader _service = ServiceWithHeader(url);

    final response = await _service.data();
    recipeModel = RecipeModel.fromJson(response);
    if (page == 1) {
      _recipelist = [];
    }

    if (recipeModel.data != null) {
      if (recipeModel.data!.length > 0) {
        print(recipeModel.data!.length);
        for (int i = 0; i < recipeModel.data!.length; i++) {
          // print(foodcategoryModel.data![i]);
          _recipelist.add(recipeModel.data![i]);
        }
      } else {
        if (page == 1) {
          datanotfound = true;
        }
        hasfirst = false;
      }
    } else {
      if (page == 1) {
        datanotfound = true;
      }
      hasfirst = false;
    }
    isFirstdatafound = false;
    notifyListeners();
    return;
  }

  Future loadMore(String subcategoryname, String type) async {
    if (hasfirst && isFirstdatafound == false && isLoadMoreRunning == false) {
      isLoadMoreRunning = true; // Display a progress indicator at the bottom

      pageNumrecipe += 1; // Increase _page by 1
      await recipelist(subcategoryname, pageNumrecipe, type);

      isLoadMoreRunning = false;
    }
  }

  Future loadMorefoodtype(String subcategoryname) async {
    if (hasfirst && isFirstdatafound == false && isLoadMoreRunning == false) {
      isLoadMoreRunning = true; // Display a progress indicator at the bottom

      pageNumrecipe += 1; // Increase _page by 1
      await recipelistfoodtype(subcategoryname, pageNumrecipe);

      isLoadMoreRunning = false;
    }
  }

  Future loadMoreallrecipe(String foodtype) async {
    if (hasfirst && isFirstdatafound == false && isLoadMoreRunning == false) {
      isLoadMoreRunning = true; // Display a progress indicator at the bottom

      pageNumrecipe += 1; // Increase _page by 1
      await allrecipelist(pageNumrecipe, foodtype, '');

      isLoadMoreRunning = false;
    }
  }

  Future recipebyid(String recipeid) async {
    datanotfound = false;

    var url = APIURL.RECIPE + recipeid;
    ServiceWithHeader _service = new ServiceWithHeader(url);

    final response = await _service.data();
    recipeModelbyid = RecipebyIdModel.fromJson(response);
    _recipelistbyid = [];
    if (recipeModelbyid.data != null) {
      // print(recipeModelbyid.data!.length);
      // for (int i = 0; i < recipeModelbyid.data!.length; i++) {
      // print(foodcategoryModel.data![i]);

      _recipelistbyid.add(recipeModelbyid.data!);
      // }

    }
    notifyListeners();
    return;
  }

  Future reletedrecipelist(String relatedrecipeid) async {
    datanotfound = false;
    print("object data");
    var url = APIURL.RelatedRecipe + relatedrecipeid;
    ServiceWithHeader _service = new ServiceWithHeader(url);

    final response = await _service.data();
    relatedrecipeModel = RelatedrecipeModel.fromJson(response);
    _reletedrecipelist = [];
    if (relatedrecipeModel.data != null) {
      if (relatedrecipeModel.data!.length > 0) {
        print(relatedrecipeModel.data!.length);
        for (int i = 0; i < relatedrecipeModel.data!.length; i++) {
          // _reletedrecipelist.add(relatedrecipeModel.data!);
          _reletedrecipelist.add(relatedrecipeModel.data![i]);
        }
      } else {
        datanotbyrelatedrecipefound = true;
      }
    }
    notifyListeners();
    return;
  }

  Future reviewlist(String reviewid) async {
    var url = APIURL.Review + "/$reviewid";

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    reviewModel = ReviewModel.fromJson(response);

    _reviewlist = [];
    if (reviewModel.data != null) {
      if (reviewModel.data!.length > 0) {
        for (int i = 0; i < reviewModel.data!.length; i++) {
          _reviewlist.add(reviewModel.data![i]);
        }
        notifyListeners();
      }
    }

    return;
  }

  Future calendarfoodtypes() async {
    var url = APIURL.foodtypescalendar;

    ServiceWithoutbody _service = new ServiceWithoutbody(url);
    final response = await _service.data();

    foodtypeModel = FoodtypeModel.fromJson(response);

    _foodtypelist = [];
    if (foodtypeModel.data != null) {
      if (foodtypeModel.data!.length > 0) {
        for (int i = 0; i < foodtypeModel.data!.length; i++) {
          _foodtypelist.add(foodtypeModel.data![i]);
        }
      }
    }

    notifyListeners();
    return;
  }
}
