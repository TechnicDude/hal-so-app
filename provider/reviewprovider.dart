import 'package:flutter/material.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/bannermodel.dart';
import 'package:halsogourmet/model/foodcategorymodel.dart';
import 'package:halsogourmet/model/fooftypemodel.dart';
import 'package:halsogourmet/model/reviewmodel.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewModel reviewModel = ReviewModel();

  List<ReviewData> _reviewlist = [];
  List<ReviewData> get reviewList => _reviewlist;

  Future reviewlist(String reviewid) async {
    print("object data");
    var url = APIURL.Review + "?foodType=" + reviewid;

    ServiceWithHeader _service = new ServiceWithHeader(url);
    final response = await _service.data();

    reviewModel = ReviewModel.fromJson(response);

    _reviewlist = [];
    if (reviewModel.data != null) {
      if (reviewModel.data!.length > 0) {
        print(reviewModel.data!.length);

        for (int i = 0; i < reviewModel.data!.length; i++) {
          _reviewlist.add(reviewModel.data![i]);
        }
        notifyListeners();
      }
    }

    return;
  }
}
