class SubcategoryModel {
  String? status;
  String? message;
  int? total;
  List<SubcategoryData>? data;

  SubcategoryModel({this.status, this.message, this.total, this.data});

  SubcategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <SubcategoryData>[];
      json['data'].forEach((v) {
        data!.add(new SubcategoryData.fromJson(v));
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

class SubcategoryData {
  int? id;
  int? categoryId;
  String? subCategoryName;
  String? primaryImage;
  String? note;
  String? createdAt;
  String? status;
  Category? category;
  List<SubSubCategories>? subSubCategories;

  SubcategoryData(
      {this.id,
      this.categoryId,
      this.subCategoryName,
      this.primaryImage,
      this.note,
      this.createdAt,
      this.status,
      this.category,
      this.subSubCategories});

  SubcategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    subCategoryName = json['subCategoryName'];
    primaryImage = json['primaryImage'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['subSubCategories'] != null) {
      subSubCategories = <SubSubCategories>[];
      json['subSubCategories'].forEach((v) {
        subSubCategories!.add(new SubSubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    data['subCategoryName'] = this.subCategoryName;
    data['primaryImage'] = this.primaryImage;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subSubCategories != null) {
      data['subSubCategories'] =
          this.subSubCategories!.map((v) => v.toJson()).toList();
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

class SubSubCategories {
  int? id;
  String? subSubCategoryName;
  String? primaryImage;

  SubSubCategories({this.id, this.subSubCategoryName, this.primaryImage});

  SubSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subSubCategoryName = json['subSubCategoryName'];
    primaryImage = json['primaryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subSubCategoryName'] = this.subSubCategoryName;
    data['primaryImage'] = this.primaryImage;
    return data;
  }
}
