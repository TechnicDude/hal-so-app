class NotificationModel {
  String? status;
  String? message;
  int? total;
  List<NotificationData>? data;

  NotificationModel({this.status, this.message, this.total, this.data});
  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
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

class NotificationData {
  int? id;
  String? path;
  String? title;
  String? subTitle;
  String? readStatus;
  int? userId;
  String? all;
  String? admin;
  String? image;
  String? note;
  String? createdAt;
  String? status;

  NotificationData(
      {this.id,
      this.path,
      this.title,
      this.subTitle,
      this.readStatus,
      this.userId,
      this.all,
      this.admin,
      this.image,
      this.note,
      this.createdAt,
      this.status});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    title = json['title'];
    subTitle = json['subTitle'];
    readStatus = json['readStatus'].toString();
    userId = json['userId'];
    all = json['all'].toString();
    admin = json['admin'].toString();
    image = json['image'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['readStatus'] = this.readStatus;
    data['userId'] = this.userId;
    data['all'] = this.all;
    data['admin'] = this.admin;
    data['image'] = this.image;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
