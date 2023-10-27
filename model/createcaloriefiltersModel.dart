class CreatecaloriefiltersModel {
  String? status;
  String? message;
  CreatecaloriefiltersModelData? data;

  CreatecaloriefiltersModel({this.status, this.message, this.data});

  CreatecaloriefiltersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new CreatecaloriefiltersModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CreatecaloriefiltersModelData {
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;

  CreatecaloriefiltersModelData(
      {this.calorie, this.protein, this.fat, this.carbohydrate});

  CreatecaloriefiltersModelData.fromJson(Map<String, dynamic> json) {
    calorie = json['calorie'].toString();
    protein = json['protein'].toString();
    fat = json['fat'].toString();
    carbohydrate = json['carbohydrate'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calorie'] = this.calorie;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrate'] = this.carbohydrate;
    return data;
  }
}
