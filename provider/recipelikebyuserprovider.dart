import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/recipelikebyusermodel.dart';

class RecipelikebyuserProvider extends ChangeNotifier {
  RecipelikebyuserModel recipelikebyuserModel = RecipelikebyuserModel();

  List<RecipelikebyuserData> _recipelikebyuserlist = [];
  List<RecipelikebyuserData> get recipelikebyuserList => _recipelikebyuserlist;

  Future recipelikebyuserlist(
    String user_id,
  ) async {
    // print("object data");
    var data = {
      'id': user_id,
    };
    Service _service = new Service(APIURL.LIKEBYUSER, data);
    final response = await _service.formdata();
    // print(response);
    _recipelikebyuserlist = [];
    recipelikebyuserModel = RecipelikebyuserModel.fromJson(response);
    if (recipelikebyuserModel.data != null) {
      var recipelikebyuser = recipelikebyuserModel.data;

      _recipelikebyuserlist.add(recipelikebyuser!);

      notifyListeners();
    }
  }
}
