import 'package:halsogourmet/api/api.dart';
import 'package:halsogourmet/api/network.dart';

class PaymentApi {
  final Map<String, dynamic> body;
  PaymentApi(this.body);

  // Future likealbum() async {
  //   Service service = Service(APIURL.LIKE);
  //   var data = await service.formdata();
  //   return data;
  // }

  Future subscriptionscreate() async {
    var url = APIURL.createsubscriptions;
    ServiceWithHeaderWithbody service = ServiceWithHeaderWithbody(url, body);
    var data = await service.postdatawithoutbody();
    return data;
  }
}
