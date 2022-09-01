import 'dart:ui';

import 'package:hamrostay/Utils/Constants.dart';

class MyRequestListModel {
  int? code;
  int? status;
  String? msg;
  OrderData? data;

  MyRequestListModel({this.code, this.status, this.msg, this.data});

  MyRequestListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
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

class OrderData {
  int? count;
  List<OrderListRows>? rows;
  int? totalPages;
  int? currentPage;

  OrderData({this.count, this.rows, this.totalPages, this.currentPage});

  OrderData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <OrderListRows>[];
      json['rows'].forEach((v) {
        rows!.add(new OrderListRows.fromJson(v));
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

class OrderListRows {
  int? id;
  String? orderId;
  String? status;
  String? tax;
  String? roomNumber;
  String? taxType;
  String? taxAmount;
  String? discount;
  String? discountType;
  String? discountAmount;
  String? subTotal;
  String? totalAmount;
  String? createdAt;
  var expectedTime;
  var expectedUnit;
  String? comment;
  OrderOwner? orderOwner;
  List<OrderItems>? orderItems;

  OrderListRows(
      {this.id,
        this.orderId,
        this.status,
        this.tax,
        this.roomNumber,
        this.taxType,
        this.taxAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.subTotal,
        this.totalAmount,
        this.createdAt,
        this.comment,
        this.orderOwner,
        this.expectedTime,
        this.expectedUnit,
        this.orderItems});

  String get orderItemString{

    String itemString = '';
    for(var model in orderItems!){
      itemString += model.quantity.toString() + " x " + model.name! + "\n";
    }
    return itemString;
  }

  OrderListRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
    tax = json['tax'];
    roomNumber = json['room_number'];
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    createdAt = json['createdAt'];
    comment = json['comment'];
    expectedTime = json['expected_time'] ?? "";
    expectedUnit = json['expected_unit'] ?? "";
    orderOwner = json['order_owner'] != null
        ? new OrderOwner.fromJson(json['order_owner'])
        : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }

    if(comment != null && comment!.isEmpty){comment = null;}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['tax'] = this.tax;
    data['room_number'] = this.roomNumber;
    data['tax_type'] = this.taxType;
    data['tax_amount'] = this.taxAmount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['sub_total'] = this.subTotal;
    data['total_amount'] = this.totalAmount;
    data['createdAt'] = this.createdAt;
    data['comment'] = this.comment;
    data['expected_time'] = this.expectedTime;
    data['expected_unit'] = this.expectedUnit;
    if (this.orderOwner != null) {
      data['order_owner'] = this.orderOwner!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
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

class OrderItems {
  String? name;
  String? unit;
  int? quantity;

  OrderItems({this.name, this.unit,this.quantity});

  OrderItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    unit = json['unit'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['quantity'] = this.quantity;
    return data;
  }
}

