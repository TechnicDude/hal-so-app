import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/healthschoolmodel.dart';

class HealthschoolProvider extends ChangeNotifier {
  BannerListModel bannerListModel = BannerListModel();
  HealthschoolModel healthschoolModel = HealthschoolModel();

  List<BannerData> _bannerlist = [];
  List<BannerData> get bannerList => _bannerlist;

  List<HealthschoolData> _healthschoollist = [];
  List<HealthschoolData> get healthschoolList => _healthschoollist;
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

  Future healthschoollist() async {
    print("object data");
    var url = APIURL.HEALTHSCHOOL ;
    ServiceWithHeader _service =  ServiceWithHeader(url);
    final response = await _service.data();
    healthschoolModel = HealthschoolModel.fromJson(response);

    _healthschoollist = [];
    if (healthschoolModel.data != null) {
      if (healthschoolModel.data!.length > 0) {
        print(healthschoolModel.data!.length);
        for (int i = 0; i < healthschoolModel.data!.length; i++) {
          _healthschoollist.add(healthschoolModel.data![i]);
        }
        notifyListeners();
      }
    }
    return;
  }
}
