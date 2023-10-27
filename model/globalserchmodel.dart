class GlobalsearchModel {
  String? status;
  String? message;
  List<GlobalsearchModelData>? data;

  GlobalsearchModel({this.status, this.message, this.data});

  GlobalsearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GlobalsearchModelData>[];
      json['data'].forEach((v) {
        data!.add(new GlobalsearchModelData.fromJson(v));
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

class GlobalsearchModelData {
  int? id;
  String? title;
  String? subTitle;
  String? path;
  String? image;
  bool? premium;
  String? goto;

  GlobalsearchModelData({
    this.id,
    this.title,
    this.subTitle,
    this.path,
    this.image,
    this.premium,
    this.goto,
  });

  GlobalsearchModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['subTitle'];
    path = json['path'];
    image = json['image'];
    premium = json['premium'];
    goto = json['goTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['path'] = this.path;
    data['image'] = this.image;
    data['premium'] = this.premium;
    data['goTo'] = this.goto;
    return data;
  }
}
