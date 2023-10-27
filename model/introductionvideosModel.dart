class IntroductionvideosModel {
  String? status;
  String? message;
  int? total;
  List<IntroductionvideosDataModel>? data;

  IntroductionvideosModel({this.status, this.message, this.total, this.data});

  IntroductionvideosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <IntroductionvideosDataModel>[];
      json['data'].forEach((v) {
        data!.add(new IntroductionvideosDataModel.fromJson(v));
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

class IntroductionvideosDataModel {
  int? id;
  String? videoUrl;
  String? title;
  String? description;
  String? createdAt;
  String? status;
  String? videoImage;

  IntroductionvideosDataModel({
    this.id,
    this.videoUrl,
    this.title,
    this.description,
    this.createdAt,
    this.status,
    this.videoImage,
  });

  IntroductionvideosDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoUrl = json['videoUrl'];
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
    status = json['status'];
    videoImage = json['videoImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['videoUrl'] = this.videoUrl;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    data['videoImage'] = this.videoImage;
    return data;
  }
}
