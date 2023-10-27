import 'package:halsogourmet/model/ingradientsModel.dart';

class GetrefrigeratoringradientsModel {
  String? status;
  String? message;
  int? total;
  List<GetrefrigeratoringradientsModelData>? data;

  GetrefrigeratoringradientsModel(
      {this.status, this.message, this.total, this.data});

  GetrefrigeratoringradientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <GetrefrigeratoringradientsModelData>[];
      json['data'].forEach((v) {
        data!.add(new GetrefrigeratoringradientsModelData.fromJson(v));
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

class GetrefrigeratoringradientsModelData {
  int? id;
  int? userId;
  int? ingradientId;
  int? quantity;
  String? note;
  String? createdAt;
  String? status;

  IngradientsModelData? ingradient;

  GetrefrigeratoringradientsModelData(
      {this.id,
      this.userId,
      this.ingradientId,
      this.quantity,
      this.note,
      this.createdAt,
      this.status,
      this.ingradient});

  GetrefrigeratoringradientsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    ingradientId = json['ingradientId'];
    quantity = json['quantity'];
    note = json['note'];
    createdAt = json['createdAt'];
    status = json['status'];

    ingradient = json['Ingradient'] != null
        ? new IngradientsModelData.fromJson(json['Ingradient'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['ingradientId'] = this.ingradientId;
    data['quantity'] = this.quantity;
    data['note'] = this.note;
    data['createdAt'] = this.createdAt;
    data['status'] = this.status;

    if (this.ingradient != null) {
      data['Ingradient'] = this.ingradient!.toJson();
    }
    return data;
  }
}
