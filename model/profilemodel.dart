class ProfileUserModel {
  String? status;
  String? message;
  ProfileUserData? data;

  ProfileUserModel({this.status, this.message, this.data});

  ProfileUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProfileUserData.fromJson(json['data'])
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

class ProfileUserData {
  int? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? emailAddress;
  int? phoneNumber;
  String? userAvatar;

  ProfileUserData({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.phoneNumber,
    this.userAvatar,
  });

  ProfileUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    userAvatar = json['userAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailAddress'] = this.emailAddress;
    data['phoneNumber'] = this.phoneNumber;
    data['userAvatar'] = this.userAvatar;
    return data;
  }
}
