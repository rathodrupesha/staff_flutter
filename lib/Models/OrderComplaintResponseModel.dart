import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class OrderComplaintResponseModel {
  int? code;
  int? status;
  String? msg;
  OrderComplaintData? data;

  OrderComplaintResponseModel({this.code, this.status, this.msg, this.data});

  OrderComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderComplaintData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderComplaintData {
  int? count;
  List<Rows>? rows;
  int? totalPages;
  int? currentPage;

  OrderComplaintData({this.count, this.rows, this.totalPages, this.currentPage});

  OrderComplaintData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class Rows {
  int? id;
  String? comment;
  String? status;
  String? orderId;
  int? userId;
  String? roomNumber;
  String? taxAmount;
  String? discountAmount;
  String? tax;
  String? taxType;
  String? discount;
  String? discountType;
  List<OrderItems>? orderItems;
  OrderOwner? orderOwner;

  Rows(
      {this.id,
        this.comment,
        this.status,
        this.orderId,
        this.userId,
        this.roomNumber,
        this.taxAmount,
        this.discountAmount,
        this.tax,
        this.taxType,
        this.discount,
        this.discountType,
        this.orderItems,
        this.orderOwner});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Active";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusCompleted){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }
    return "";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusCompleted){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    status = json['status'];
    orderId = json['order_id'];
    userId = json['user_id'];
    roomNumber = json['room_number'];
    taxAmount = json['tax_amount'];
    discountAmount = json['discount_amount'];
    tax = json['tax'];
    taxType = json['tax_type'];
    discount = json['discount'];
    discountType = json['discount_type'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    orderOwner = json['order_owner'] != null
        ? new OrderOwner.fromJson(json['order_owner'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['room_number'] = this.roomNumber;
    data['tax_amount'] = this.taxAmount;
    data['discount_amount'] = this.discountAmount;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.orderOwner != null) {
      data['order_owner'] = this.orderOwner!.toJson();
    }
    return data;
  }
}

class OrderItems {
  String? name;
  int? units;

  OrderItems({this.name, this.units});

  OrderItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['units'] = this.units;
    return data;
  }
}

class OrderOwner {
  String? firstName;
  String? lastName;
  String? profileImage;

  OrderOwner({this.firstName, this.lastName, this.profileImage});

  OrderOwner.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
