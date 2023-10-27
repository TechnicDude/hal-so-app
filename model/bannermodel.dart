class BannerListModel {
  String? status;
  String? message;
  int? total;
  List<BannerData>? data;

  BannerListModel({this.status, this.message, this.total, this.data});

  BannerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(new BannerData.fromJson(v));
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

class BannerData {
  int? id;
  String? ban;
  int? relatedId;
  Null? imageType;
  String? image;
  String? createdAt;
  String? status;

  BannerData(
      {this.id,
      this.ban,
      this.relatedId,
      this.imageType,
      this.image,
      this.createdAt,
      this.status});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ban = json['for'];
    relatedId = json['relatedId'];
    imageType = json['imageType'];
    image = json['image'];
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['for'] = this.ban;
    data['relatedId'] = this.relatedId;
    data['imageType'] = this.imageType;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
