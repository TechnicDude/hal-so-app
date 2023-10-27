import 'package:halsogourmet/api/likeapi.dart';
import 'package:halsogourmet/main.dart';
import 'package:halsogourmet/utils/string_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocDb {
  LocDb._internal();
  static final LocDb _db = LocDb._internal();
  factory LocDb() {
    return _db;
  }
  bool loginapp = false;

  Future<bool> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    MyApp.AUTH_TOKEN_VALUE = preferences.getString(StringFile.authtoken);
    MyApp.userid = preferences.getString(StringFile.userid);
    MyApp.email_VALUE = preferences.getString(StringFile.email);

    if (MyApp.userid == null || MyApp.userid == false) {
      print("object check");
      return false;
    } else {
      LikeApi registerresponse = LikeApi();
      final response = await registerresponse.meapi();
      print(response);
      if (response['status'].toString().toLowerCase() == "error") {
        MyApp.logout();
        return false;
      } else {
        var subscriptioncheck = response['user']['isSubscription'];
        if (subscriptioncheck == 0) {
          MyApp.subscriptioncheck = false;
        } else {
          MyApp.subscriptioncheck = true;
          MyApp.subscriptionstartdate =
              response['user']['subscription']['subscriptionStart'];
          MyApp.subscriptionenddate =
              response['user']['subscription']['expire'];
          MyApp.isRecurring = response['user']['subscription']['isRecurring'];
          MyApp.stripeSubscriptionId = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? ""
              : response['user']['subscription']['stripeSubscriptionId']
                  .toString();
          MyApp.subscriptionDeleted = response['user']['subscription']
                          ['subscriptionDeleted']
                      .toString() ==
                  "null"
              ? false
              : true;
          MyApp.subscriptionapplepay = response['user']['subscription']
                          ['stripeSubscriptionId']
                      .toString() ==
                  "null"
              ? false
              : true;
        }
        return true;
      }

      // print("object check 1");
    }
  }
}
