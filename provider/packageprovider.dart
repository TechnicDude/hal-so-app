import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/packagemodel.dart';

class PackageProvider extends ChangeNotifier {
  PackageModel packageModel = PackageModel();

  List<PackageData> _packagedatalist = [];
  List<PackageData> get packagedataList => _packagedatalist;

  bool datanotfound = false;

  Future packagedatalist() async {
    print("object data");
    var url = APIURL.PACKAGE;
    // + "?foodType=" + subcategoryname;

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();
    packageModel = PackageModel.fromJson(response);

    _packagedatalist = [];
    if (packageModel.data != null) {
      if (packageModel.data!.length > 0) {
        print(packageModel.data!.length);

        for (int i = 0; i < packageModel.data!.length; i++) {
          _packagedatalist.add(packageModel.data![i]);
        }
        notifyListeners();
      }
    }
    return;
  }
}
