import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/introductionvideosModel.dart';

class VideoProvider extends ChangeNotifier {
  IntroductionvideosModel _getvideoall = IntroductionvideosModel();
  IntroductionvideosModel get getvideolall => _getvideoall;

  List<IntroductionvideosDataModel> _getvideolist = [];
  List<IntroductionvideosDataModel> get getvideolist => _getvideolist;

  Future introductionvideolist() async {
    ServiceWithHeader _service =
        new ServiceWithHeader(APIURL.introductionvideos);
    final response = await _service.data();
    _getvideoall = IntroductionvideosModel.fromJson(response);
    _getvideolist = [];
    if (_getvideoall.data != null) {
      if (_getvideoall.data!.isNotEmpty) {
        for (int i = 0; i < _getvideoall.data!.length; i++) {
          _getvideolist.add(_getvideoall.data![i]);
        }
      }
    }
    print(_getvideolist.length);
    notifyListeners();
    return;
  }
}
