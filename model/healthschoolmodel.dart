class HealthschoolModel {
  String? status;
  String? message;
  int? total;
  List<HealthschoolData>? data;

  HealthschoolModel({this.status, this.message, this.total, this.data});

  HealthschoolModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <HealthschoolData>[];
      json['data'].forEach((v) {
        data!.add(new HealthschoolData.fromJson(v));
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

class HealthschoolData {
  int? id;
  String? title;
  String? banner;
  String? category;
  String? description;
  String? video;
  String? audio;
  String? videoUrl;
  String? audioUrl;
  String? createdAt;
  String? status;
  String? totalLike;
  String? userLike;

  HealthschoolData(
      {this.id,
      this.title,
      this.banner,
      this.category,
      this.description,
      this.video,
      this.audio,
      this.videoUrl,
      this.audioUrl,
      this.createdAt,
      this.status,
      this.totalLike,
      this.userLike});

  HealthschoolData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    category = json['category'];
    description = json['description'];
    video = json['video'];
    audio = json['audio'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    createdAt = json['createdAt'];
    status = json['status'];
    totalLike = json['totalLike'].toString();
    userLike = json['userLike'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['banner'] = this.banner;
    data['category'] = this.category;
    data['description'] = this.description;
    data['video'] = this.video;
    data['audio'] = this.audio;
    data['videoUrl'] = this.videoUrl;
    data['audioUrl'] = this.audioUrl;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    data['totalLike'] = this.totalLike;
    data['userLike'] = this.userLike;

    return data;
  }
}
