class WeeklyingredientModel {
  String? status;
  String? message;
  List<WeeklyingredientData>? data;

  WeeklyingredientModel({this.status, this.message, this.data});

  WeeklyingredientModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WeeklyingredientData>[];
      json['data'].forEach((v) {
        data!.add(new WeeklyingredientData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeeklyingredientData {
  String? ingradientAmount;
  int? ingradientId;
  String? ingradientTitle;
  int? refrigeratorAmount;
  String? calculatedAmount;

  WeeklyingredientData(
      {this.ingradientAmount, this.ingradientId, this.ingradientTitle});

  WeeklyingredientData.fromJson(Map<String, dynamic> json) {
    ingradientAmount = json['ingradientAmount'].toString();
    ingradientId = json['ingradientId'];
    ingradientTitle = json['ingradientTitle'];
    refrigeratorAmount = json['refrigeratorAmount'];
    calculatedAmount = json['calculatedAmount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ingradientAmount'] = this.ingradientAmount;
    data['ingradientId'] = this.ingradientId;
    data['ingradientTitle'] = this.ingradientTitle;
    data['refrigeratorAmount'] = this.refrigeratorAmount;
    data['calculatedAmount'] = this.calculatedAmount;

    return data;
  }
}
