class BannerfoodtypeModel {
  String? status;
  String? message;
  int? total;
  List<Data>? data;

  BannerfoodtypeModel({this.status, this.message, this.total, this.data});

  BannerfoodtypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? fors;
  int? relatedId;
  Null? imageType;
  String? image;
  String? createdAt;
  String? status;

  Data(
      {this.id,
      this.fors,
      this.relatedId,
      this.imageType,
      this.image,
      this.createdAt,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fors = json['fors'];
    relatedId = json['relatedId'];
    imageType = json['imageType'];
    image = json['image'];
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fors'] = this.fors;
    data['relatedId'] = this.relatedId;
    data['imageType'] = this.imageType;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
