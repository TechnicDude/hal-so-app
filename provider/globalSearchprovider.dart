import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/favoriterecipemodel.dart';
import 'package:halsogourmet/model/globalserchmodel.dart';

class GlobalsearchProvider extends ChangeNotifier {
  GlobalsearchModel globalsearchModel = GlobalsearchModel();

  List<GlobalsearchModelData> _globalsearchModeldata = [];
  List<GlobalsearchModelData> get globalsearchModeldata =>
      _globalsearchModeldata;

  bool datanotfound = false;

  Future globalsearclist(String text) async {
    var url = APIURL.Globalserch + text;

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    globalsearchModel = GlobalsearchModel.fromJson(response);

    _globalsearchModeldata = [];
    if (globalsearchModel.data != null) {
      if (globalsearchModel.data!.length > 0) {
        for (int i = 0; i < globalsearchModel.data!.length; i++) {
          _globalsearchModeldata.add(globalsearchModel.data![i]);
        }
      }
    }
    notifyListeners();
    return;
  }
}
