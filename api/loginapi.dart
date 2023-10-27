import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';
import 'package:halsogourmet/main.dart';

class LoginApi {
  final Map<String, dynamic> body;
  LoginApi(this.body);

  Future register() async {
    Service service = new Service(APIURL.REGISTRATION, body);
    var data = await service.formdata();
    return data;
  }

  // Future verify() async {
  //   Service service = new Service(VERIFY, body);
  //   var data = await service.formdata();
  //   return data;
  // }

  Future login() async {
    Service service = new Service(APIURL.LOGIN, body);
    var data = await service.formdata();
    return data;
  }

  Future socialmedialogin() async {
    Service service = new Service(APIURL.socialmediaLOGIN, body);
    var data = await service.formdata();
    return data;
  }

  Future googlesocialmedialogin() async {
    Service service = new Service(APIURL.googlesocialmediaLOGIN, body);
    var data = await service.formdata();
    return data;
  }

  Future facebooksocialmedialogin() async {
    Service service = new Service(APIURL.facebooksocialmediaLOGIN, body);
    var data = await service.formdata();
    return data;
  }

  Future appleocialmedialogin() async {
    Service service = new Service(APIURL.applesocialmediaLOGIN, body);
    var data = await service.formdata();
    return data;
  }

  Future verifyOtp() async {
    Service service = new Service(APIURL.VERIFYOTP, body);
    var data = await service.formdata();

    return data;
  }

  Future factokenregister() async {
    ServiceWithHeaderWithbody service =
        ServiceWithHeaderWithbody(APIURL.registerfcmtoken, body);
    var data = await service.postdatawithoutbody();

    return data;
  }

  Future addingredient() async {
    ServiceWithHeaderWithbody service =
        ServiceWithHeaderWithbody(APIURL.refrigeratoringradients, body);
    var data = await service.postdatawithoutbody();

    return data;
  }

  Future addingredientcalander() async {
    ServiceWithHeaderWithbody service =
        ServiceWithHeaderWithbody(APIURL.CalendarsAdd, body);
    var data = await service.postdatawithoutbody();

    return data;
  }

  Future editingredient(String id) async {
    var url = APIURL.refrigeratoringradients + "/$id";
    ServiceWithHeaderWithbody service = ServiceWithHeaderWithbody(url, body);
    var data = await service.putdatawithoutbody();

    return data;
  }

  Future forgetverifyOtp() async {
    Service service = new Service(APIURL.FORGETVERIFYOTP, body);
    var data = await service.formdata();

    return data;
  }

  Future sentotp() async {
    Service service = new Service(APIURL.FORGETVERIFYOTP, body);
    var data = await service.formdata();

    return data;
  }

  Future forgetpassword() async {
    Service service = new Service(APIURL.FORGETPASSWORD, body);
    var data = await service.formdata();

    return data;
  }

  Future iostransactionsupdateuser() async {
    ServiceWithHeaderWithbody service =
        new ServiceWithHeaderWithbody(APIURL.transactionsupdateuser, body);
    var data = await service.postdatawithoutbody();
    return data;
  }

  Future setnewpassword() async {
    Service service = Service(APIURL.SETNEWPASSWORD, body);
    var data = await service.formdata();
    return data;
  }

  Future caloriefilters() async {
    var url = APIURL.caloriefilters;
    ServiceWithHeader service = ServiceWithHeader(url);
    var data = await service.postdatawithoutbody();

    return data;
  }

  Future changepassword() async {
    ServiceWithHeaderWithbody service =
        ServiceWithHeaderWithbody(APIURL.CHANGEPASSWORD, body);
    var data = await service.postdatawithoutbody();
    return data;
  }

  Future userprofile() async {
    Service service = new Service(APIURL.USERPROFILE, body);
    var data = await service.formdata();
    return data;
  }

  Future updateprofile() async {
    var url = APIURL.USERPROFILEUPDATE + MyApp.userid!;
    ServicePUT service = new ServicePUT(url, body);
    var data = await service.formdata();
    return data;
  }

  Future bannerfoodtype() async {
    var url = APIURL.BANNERURL + MyApp.userid!;
    ServicePUT service = new ServicePUT(url, body);
    var data = await service.formdata();
    return data;
  }

  Future sentreview() async {
    ServiceWithHeaderWithbody service =
        new ServiceWithHeaderWithbody(APIURL.Reviews, body);
    var data = await service.postdatawithoutbody();
    return data;
  }

  Future planadd() async {
    ServiceWithHeaderWithbody service =
        new ServiceWithHeaderWithbody(APIURL.CalendarsAdd, body);
    var data = await service.postdatawithoutbody();

    return data;
  }

  Future transaction() async {
    Service service = Service(APIURL.TRANSACTION, body);
    var data = await service.formdata();
    return data;
  }

  Future deleteaccount(String id) async {
    ServiceWithDelete service = ServiceWithDelete(
      APIURL.deleteaccount + id,
    );
    var data = await service.data();
    return data;
  }
}
