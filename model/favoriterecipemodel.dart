class FovoriterecipeModel {
  String? status;
  String? message;
  int? total;
  List<FovoriteData>? data;

  FovoriterecipeModel({this.status, this.message, this.total, this.data});

  FovoriterecipeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <FovoriteData>[];
      json['data'].forEach((v) {
        data!.add(FovoriteData.fromJson(v));
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

class FovoriteData {
  int? id;
  int? userId;
  int? recipeId;
  String? type;
  String? createdAt;
  String? status;
  Recipes? recipes;

  FovoriteData(
      {this.id,
      this.userId,
      this.recipeId,
      this.type,
      this.createdAt,
      this.status,
      this.recipes});

  FovoriteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    recipeId = json['recipeId'];
    type = json['type'];
    createdAt = json['createdAt'];
    status = json['status'];
    recipes =
        json['recipes'] != null ? new Recipes.fromJson(json['recipes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['recipeId'] = this.recipeId;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    return data;
  }
}

class Recipes {
  int? id;
  int? categoryId;
  int? subCategoryId;
  int? subSubCategoryId;
  String? title;
  String? shortDescription;
  String? primaryImage;
  String? prepareTime;
  String? cookTime;
  List<Recipeimage>? recipeimage;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;

  Recipes(
      {this.id,
      this.categoryId,
      this.subCategoryId,
      this.subSubCategoryId,
      this.title,
      this.shortDescription,
      this.primaryImage,
      this.prepareTime,
      this.cookTime,
      this.recipeimage,
      this.calorie,
      this.protein,
      this.fat,
      this.carbohydrate});

  Recipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    subSubCategoryId = json['subSubCategoryId'];
    title = json['title'];
    shortDescription = json['shortDescription'];
    primaryImage = json['primaryImage'];
    prepareTime = json['prepareTime'];
    cookTime = json['cookTime'];
    calorie = json['calorie'];
    protein = json['protein'];
    fat = json['fat'];
    carbohydrate = json['carbohydrate'];

    if (json['recipeimage'] != null) {
      recipeimage = <Recipeimage>[];
      json['recipeimage'].forEach((v) {
        recipeimage!.add(new Recipeimage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['subSubCategoryId'] = this.subSubCategoryId;
    data['title'] = this.title;
    data['shortDescription'] = this.shortDescription;
    data['primaryImage'] = this.primaryImage;
    data['prepareTime'] = this.prepareTime;
    data['cookTime'] = this.cookTime;

    data['calorie'] = this.calorie;

    data['protein'] = this.protein;

    data['fat'] = this.fat;

    data['carbohydrate'] = this.carbohydrate;

    if (this.recipeimage != null) {
      data['recipeimage'] = this.recipeimage!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Recipeimage {
  int? id;
  String? image;
  String? imageType;

  Recipeimage({this.id, this.image, this.imageType});

  Recipeimage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imageType = json['imageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['imageType'] = this.imageType;
    return data;
  }
}
