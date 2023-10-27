import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/favoriterecipemodel.dart';

class FavoriterecipeProvider extends ChangeNotifier {
  FovoriterecipeModel fovoriterecipeModel = FovoriterecipeModel();

  List<FovoriteData> _fovoriterecipelist = [];
  List<FovoriteData> get fovoriterecipeList => _fovoriterecipelist;

  bool datanotfound = false;

  Future foodcategorylist() async {
    print("object data");
    // var url = APIURL.FAVORITE;
    var url = APIURL.FEVBYUSER;

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    fovoriterecipeModel = FovoriterecipeModel.fromJson(response);

    _fovoriterecipelist = [];
    if (fovoriterecipeModel.data != null) {
      if (fovoriterecipeModel.data!.length > 0) {
        print(fovoriterecipeModel.data!.length);

        for (int i = 0; i < fovoriterecipeModel.data!.length; i++) {
          _fovoriterecipelist.add(fovoriterecipeModel.data![i]);
        }
      }
    }
    datanotfound = true;
    notifyListeners();
    return;
  }
}
