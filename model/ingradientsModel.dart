class IngradientsModel {
  String? status;
  String? message;
  int? total;
  List<IngradientsModelData>? data;

  IngradientsModel({this.status, this.message, this.total, this.data});

  IngradientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <IngradientsModelData>[];
      json['data'].forEach((v) {
        data!.add(new IngradientsModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IngradientsModelData {
  int? id;
  String? title;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;
  String? createdAt;
  String? status;
  String? image;
  String? type;

  IngradientsModelData({
    this.id,
    this.title,
    this.calorie,
    this.protein,
    this.fat,
    this.carbohydrate,
    this.createdAt,
    this.status,
    this.image,
    this.type,
  });

  IngradientsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    calorie = json['calorie'];
    protein = json['protein'];
    fat = json['fat'];
    carbohydrate = json['carbohydrate'];
    createdAt = json['createdAt'];
    status = json['status'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['calorie'] = this.calorie;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrate'] = this.carbohydrate;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    data['image'] = this.image;
    data['type'] = this.type;
    return data;
  }
}
