import 'package:flutter/cupertino.dart';
import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/model/notificationmodel.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel notificationModel = NotificationModel();

  List<NotificationData> _notificationlist = [];
  List<NotificationData> get notificationList => _notificationlist;
  bool datanotfound = false;

//path

  Future notificationlist() async {
    print("object data");
    //  var url = APIURL.NOTIFICATION;

    var url = APIURL.NOTIFICATION;
    //+ text;

    ServiceWithHeader _service = ServiceWithHeader(url);
    final response = await _service.data();
    notificationModel = NotificationModel.fromJson(response);

    _notificationlist = [];
    if (notificationModel.data != null) {
      if (notificationModel.data!.length > 0) {
        print(notificationModel.data!.length);
        for (int i = 0; i < notificationModel.data!.length; i++) {
          _notificationlist.add(notificationModel.data![i]);
        }
      }
    }
    datanotfound = true;
    notifyListeners();
    return;
  }
}
