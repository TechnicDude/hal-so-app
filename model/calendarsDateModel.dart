class FinalCalendarsDateModel {
  String? status;
  String? message;
  List<CalendarsDateModel>? data;

  FinalCalendarsDateModel({this.status, this.message, this.data});

  FinalCalendarsDateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CalendarsDateModel>[];
      json['data'].forEach((v) {
        data!.add(new CalendarsDateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CalendarsDateModel {
  String? foodtypeName;
  int? foodtypeId;
  String? foodtypeImage;
  List<Items>? items;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;

  CalendarsDateModel(
      {this.foodtypeName,
      this.foodtypeId,
      this.foodtypeImage,
      this.items,
      this.calorie,
      this.protein,
      this.fat,
      this.carbohydrate});

  CalendarsDateModel.fromJson(Map<String, dynamic> json) {
    foodtypeName = json['foodtypeName'];
    foodtypeId = json['foodtypeId'];
    foodtypeImage = json['foodtypeImage'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    calorie = json['calorie'];
    protein = json['protein'];
    fat = json['fat'];
    carbohydrate = json['carbohydrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodtypeName'] = this.foodtypeName;
    data['foodtypeId'] = this.foodtypeId;
    data['foodtypeImage'] = this.foodtypeImage;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['calorie'] = this.calorie;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrate'] = this.carbohydrate;
    return data;
  }
}

class Items {
  int? id;
  String? date;
  int? recipeId;
  int? ingradientId;
  int? foodTypeId;
  int? userId;
  int? quantity;
  String? type;
  int? serving;
  String? createdAt;
  String? status;
  List<Recipes>? recipes;
  List<Ingradient>? ingradient;
  Foodtype? foodtype;

  Items(
      {this.id,
      this.date,
      this.recipeId,
      this.ingradientId,
      this.foodTypeId,
      this.userId,
      this.quantity,
      this.type,
      this.serving,
      this.createdAt,
      this.status,
      this.recipes,
      this.ingradient,
      this.foodtype});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    recipeId = json['recipeId'];
    ingradientId = json['ingradientId'];
    foodTypeId = json['foodTypeId'];
    userId = json['userId'];
    quantity = json['quantity'];
    type = json['type'];
    serving = json['serving'];
    createdAt = json['createdAt'];
    status = json['status'];
    if (json['recipes'] != null) {
      recipes = <Recipes>[];
      json['recipes'].forEach((v) {
        recipes!.add(new Recipes.fromJson(v));
      });
    }
    if (json['ingradient'] != null) {
      ingradient = <Ingradient>[];
      json['ingradient'].forEach((v) {
        ingradient!.add(new Ingradient.fromJson(v));
      });
    }
    foodtype = json['foodtype'] != null
        ? new Foodtype.fromJson(json['foodtype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['recipeId'] = this.recipeId;
    data['ingradientId'] = this.ingradientId;
    data['foodTypeId'] = this.foodTypeId;
    data['userId'] = this.userId;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['serving'] = this.serving;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.map((v) => v.toJson()).toList();
    }
    if (this.ingradient != null) {
      data['ingradient'] = this.ingradient!.map((v) => v.toJson()).toList();
    }
    if (this.foodtype != null) {
      data['foodtype'] = this.foodtype!.toJson();
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
  String? prepareTime;
  String? cookTime;
  int? serving;
  bool? premium;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;
  String? note;
  String? createdAt;
  String? status;
  List<Recipeimage>? recipeimage;
  List<Ingradients>? ingradients;

  Recipes(
      {this.id,
      this.categoryId,
      this.subCategoryId,
      this.subSubCategoryId,
      this.title,
      this.shortDescription,
      this.prepareTime,
      this.cookTime,
      this.serving,
      this.premium,
      this.calorie,
      this.protein,
      this.fat,
      this.carbohydrate,
      this.note,
      this.createdAt,
      this.status,
      this.recipeimage,
      this.ingradients});

  Recipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    subSubCategoryId = json['subSubCategoryId'];
    title = json['title'];
    shortDescription = json['shortDescription'];
    prepareTime = json['prepareTime'];
    cookTime = json['cookTime'];
    serving = json['serving'];
    premium = json['premium'];
    calorie = json['calorie'].toString();
    protein = json['protein'].toString();
    fat = json['fat'].toString();
    carbohydrate = json['carbohydrate'].toString();
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];
    if (json['recipeimage'] != null) {
      recipeimage = <Recipeimage>[];
      json['recipeimage'].forEach((v) {
        recipeimage!.add(new Recipeimage.fromJson(v));
      });
    }
    if (json['ingradients'] != null) {
      ingradients = <Ingradients>[];
      json['ingradients'].forEach((v) {
        ingradients!.add(new Ingradients.fromJson(v));
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
    data['prepareTime'] = this.prepareTime;
    data['cookTime'] = this.cookTime;
    data['serving'] = this.serving;
    data['premium'] = this.premium;
    data['calorie'] = this.calorie;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrate'] = this.carbohydrate;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.recipeimage != null) {
      data['recipeimage'] = this.recipeimage!.map((v) => v.toJson()).toList();
    }
    if (this.ingradients != null) {
      data['ingradients'] = this.ingradients!.map((v) => v.toJson()).toList();
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

class Ingradients {
  int? id;
  String? recipeId;
  String? ingradientId;
  int? amount;
  Ingradient? ingradient;

  Ingradients(
      {this.id,
      this.recipeId,
      this.ingradientId,
      this.amount,
      this.ingradient});

  Ingradients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipeId'];
    ingradientId = json['ingradientId'];
    amount = json['amount'];
    ingradient = json['ingradient'] != null
        ? new Ingradient.fromJson(json['ingradient'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipeId'] = this.recipeId;
    data['ingradientId'] = this.ingradientId;
    data['amount'] = this.amount;
    if (this.ingradient != null) {
      data['ingradient'] = this.ingradient!.toJson();
    }
    return data;
  }
}

class Ingradient {
  int? id;
  String? title;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;
  String? image;
  String? type;
  String? createdAt;
  String? status;

  Ingradient(
      {this.id,
      this.title,
      this.calorie,
      this.protein,
      this.fat,
      this.carbohydrate,
      this.image,
      this.type,
      this.createdAt,
      this.status});

  Ingradient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    calorie = json['calorie'].toString();
    protein = json['protein'].toString();
    fat = json['fat'].toString();
    carbohydrate = json['carbohydrate'].toString();
    image = json['image'];
    type = json['type'];
    createdAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['calorie'] = this.calorie;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrate'] = this.carbohydrate;
    data['image'] = this.image;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

class Foodtype {
  int? id;
  String? foodType;
  String? primaryImage;
  String? note;

  Foodtype({this.id, this.foodType, this.primaryImage, this.note});

  Foodtype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodType = json['foodType'];
    primaryImage = json['primaryImage'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['foodType'] = this.foodType;
    data['primaryImage'] = this.primaryImage;
    data['note'] = this.note;
    return data;
  }
}
