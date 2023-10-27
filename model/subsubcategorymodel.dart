class SubsubcategoryModel {
  String? status;
  String? message;
  int? total;
  List<SubsubcategoryData>? data;

  SubsubcategoryModel({this.status, this.message, this.total, this.data});

  SubsubcategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <SubsubcategoryData>[];
      json['data'].forEach((v) {
        data!.add(new SubsubcategoryData.fromJson(v));
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

class SubsubcategoryData {
  int? id;
  int? subCategoryId;
  String? subSubCategoryName;
  String? foodTypes;
  String? primaryImage;
  String? note;
  String? createdAt;
  String? status;
  Subcategory? subcategory;

  SubsubcategoryData(
      {this.id,
      this.subCategoryId,
      this.subSubCategoryName,
      this.foodTypes,
      this.primaryImage,
      this.note,
      this.createdAt,
      this.status,
      this.subcategory});

  SubsubcategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['subCategoryId'];
    subSubCategoryName = json['subSubCategoryName'];
    foodTypes = json['foodTypes'];
    primaryImage = json['primaryImage'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
    subcategory = json['subcategory'] != null
        ? new Subcategory.fromJson(json['subcategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subCategoryId'] = this.subCategoryId;
    data['subSubCategoryName'] = this.subSubCategoryName;
    data['foodTypes'] = this.foodTypes;
    data['primaryImage'] = this.primaryImage;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.toJson();
    }
    return data;
  }
}

class Subcategory {
  int? id;
  String? subCategoryName;
  Category? category;

  Subcategory({this.id, this.subCategoryName, this.category});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryName = json['subCategoryName'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subCategoryName'] = this.subCategoryName;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? categoryName;

  Category({this.id, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
