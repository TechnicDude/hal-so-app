class PackageModel {
  String? status;
  String? message;
  int? total;
  List<PackageData>? data;

  PackageModel({this.status, this.message, this.total, this.data});

  PackageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <PackageData>[];
      json['data'].forEach((v) {
        data!.add(new PackageData.fromJson(v));
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

class PackageData {
  int? id;
  String? packageID;
  String? title;
  int? perMonthPrice;
  String? createdAt;
  String? status;
  List<Services>? services;
  List<Prices>? prices;

  PackageData(
      {this.id,
      this.packageID,
      this.title,
      this.perMonthPrice,
      this.createdAt,
      this.status,
      this.services,
      this.prices});

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageID = json['packageID'];
    title = json['title'];
    perMonthPrice = json['perMonthPrice'];
    createdAt = json['createdAt'];
    status = json['status'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <Prices>[];
      json['prices'].forEach((v) {
        prices!.add(new Prices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packageID'] = this.packageID;
    data['title'] = this.title;
    data['perMonthPrice'] = this.perMonthPrice;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.prices != null) {
      data['prices'] = this.prices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? title;

  Services({this.id, this.title});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class Prices {
  int? id;
  int? perMonthPrice;
  String? discountType;
  String? stripeProductID;
  String? appleProductID;
  String? isRecurring;
  int? discount;
  int? tenure;

  Prices(
      {this.id,
      this.perMonthPrice,
      this.discountType,
      this.stripeProductID,
      this.appleProductID,
      this.isRecurring,
      this.discount,
      this.tenure});

  Prices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    perMonthPrice = json['perMonthPrice'];
    discountType = json['discountType'];
    stripeProductID = json['stripeProductID'];
    appleProductID = json['appleProductID'];
    isRecurring = json['isRecurring'].toString();
    discount = json['discount'];
    tenure = json['tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['perMonthPrice'] = this.perMonthPrice;
    data['discountType'] = this.discountType;
    data['stripeProductID'] = this.stripeProductID;
    data['appleProductID'] = this.appleProductID;
    data['isRecurring'] = this.isRecurring;
    data['discount'] = this.discount;
    data['tenure'] = this.tenure;
    return data;
  }
}
