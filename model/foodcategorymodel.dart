class FoodcategoryModel {
  String? status;
  String? message;
  int? total;
  List<FoodcategoryData>? data;

  FoodcategoryModel({this.status, this.message, this.total, this.data});

  FoodcategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <FoodcategoryData>[];
      json['data'].forEach((v) {
        data!.add(new FoodcategoryData.fromJson(v));
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

class FoodcategoryData {
  int? id;
  String? categoryName;
  String? primaryImage;
  String? note;
  String? createdAt;
  String? status;
  List<SubCategories>? subCategories;

  FoodcategoryData(
      {this.id,
      this.categoryName,
      this.primaryImage,
      this.note,
      this.createdAt,
      this.status,
      this.subCategories});

  FoodcategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    primaryImage = json['primaryImage'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['primaryImage'] = this.primaryImage;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? subCategoryName;
  String? primaryImage;

  SubCategories({this.id, this.subCategoryName, this.primaryImage});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryName = json['subCategoryName'];
    primaryImage = json['primaryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subCategoryName'] = this.subCategoryName;
    data['primaryImage'] = this.primaryImage;
    return data;
  }
}
