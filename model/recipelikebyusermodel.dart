class RecipelikebyuserModel {
  String? status;
  String? message;
  RecipelikebyuserData? data;

  RecipelikebyuserModel({this.status, this.message, this.data});

  RecipelikebyuserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new RecipelikebyuserData.fromJson(json['data'])
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

class RecipelikebyuserData {
  int? id;
  int? userId;
  String? recipeId;
  String? type;
  String? updatedAt;
  String? createdAt;

  RecipelikebyuserData(
      {this.id,
      this.userId,
      this.recipeId,
      this.type,
      this.updatedAt,
      this.createdAt});

  RecipelikebyuserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    recipeId = json['recipeId'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['recipeId'] = this.recipeId;
    data['type'] = this.type;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
