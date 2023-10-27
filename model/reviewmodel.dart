class ReviewModel {
  String? status;
  String? message;
  int? total;
  List<ReviewData>? data;

  ReviewModel({this.status, this.message, this.total, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data!.add(new ReviewData.fromJson(v));
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

class ReviewData {
  int? id;
  int? userId;
  int? recipeId;
  int? rating;
  String? comment;
  String? reviewStatus;
  String? statusMassage;
  String? statusUpdateBy;
  String? statusUpdateAt;
  String? note;
  String? createdAt;
  String? status;
  Users? users;

  ReviewData(
      {this.id,
      this.userId,
      this.recipeId,
      this.rating,
      this.comment,
      this.reviewStatus,
      this.statusMassage,
      this.statusUpdateBy,
      this.statusUpdateAt,
      this.note,
      this.createdAt,
      this.status,
      this.users});

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    recipeId = json['recipeId'];
    rating = json['rating'];
    comment = json['comment'];
    reviewStatus = json['reviewStatus'];
    statusMassage = json['statusMassage'];
    statusUpdateBy = json['statusUpdateBy'];
    statusUpdateAt = json['statusUpdateAt'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['recipeId'] = this.recipeId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['reviewStatus'] = this.reviewStatus;
    data['statusMassage'] = this.statusMassage;
    data['statusUpdateBy'] = this.statusUpdateBy;
    data['statusUpdateAt'] = this.statusUpdateAt;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

class Users {
  int? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? emailAddress;
  String? userAvatar;

  Users(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.emailAddress,
      this.userAvatar});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailAddress = json['emailAddress'];
    userAvatar = json['userAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailAddress'] = this.emailAddress;
    data['userAvatar'] = this.userAvatar;
    return data;
  }
}
