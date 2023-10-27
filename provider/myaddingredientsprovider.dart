import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/getrefrigeratoringradientsModel.dart';
import 'package:halsogourmet/model/ingradientsModel.dart';

class MyaddingredientsProvider extends ChangeNotifier {
  IngradientsModel ingradientsModel = IngradientsModel();
  List<IngradientsModelData> _ingradientsModellist = [];
  List<IngradientsModelData> get ingradientsModellist => _ingradientsModellist;
  bool datanotfound = false;

  GetrefrigeratoringradientsModel getrefrigeratoringradientsModel =
      GetrefrigeratoringradientsModel();
  List<GetrefrigeratoringradientsModelData>
      _getrefrigeratoringradientsModelDatalist = [];
  List<GetrefrigeratoringradientsModelData>
      get getrefrigeratoringradientsModelDatalist =>
          _getrefrigeratoringradientsModelDatalist;
  bool showdata = false;
  FoodtypeModel foodtypeModel = FoodtypeModel();
  List<FoodtypeData> _foodtypelist = [];
  List<FoodtypeData> get foodtypeList => _foodtypelist;

  Future ingradientslist() async {
    ServiceWithoutbody _service = new ServiceWithoutbody(APIURL.ingradients);
    final response = await _service.data();
    ingradientsModel = IngradientsModel.fromJson(response);
    if (ingradientsModel.data != null) {
      if (ingradientsModel.data!.isNotEmpty) {
        _ingradientsModellist = [];
        for (int i = 0; i < ingradientsModel.data!.length; i++) {
          _ingradientsModellist.add(ingradientsModel.data![i]);
        }
      }
    }
    datanotfound = true;
    notifyListeners();
    return;
  }

  Future myingradientsdatalist() async {
    ServiceWithHeader _service =
        new ServiceWithHeader(APIURL.myrefrigeratoringradients);
    final response = await _service.data();
    _getrefrigeratoringradientsModelDatalist = [];
    getrefrigeratoringradientsModel =
        GetrefrigeratoringradientsModel.fromJson(response);
    if (getrefrigeratoringradientsModel.data != null) {
      if (getrefrigeratoringradientsModel.data!.isNotEmpty) {
        _getrefrigeratoringradientsModelDatalist = [];
        for (int i = 0; i < getrefrigeratoringradientsModel.data!.length; i++) {
          _getrefrigeratoringradientsModelDatalist
              .add(getrefrigeratoringradientsModel.data![i]);
        }
      }
    }

    showdata = true;
    notifyListeners();
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
