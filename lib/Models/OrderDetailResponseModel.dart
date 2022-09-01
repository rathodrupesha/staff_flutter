import 'dart:ui';

import '../Utils/Constants.dart';

class OrderDetailResponse {
  int? code;
  int? status;
  String? msg;
  OrderDetailData? data;

  OrderDetailResponse({this.code, this.status, this.msg, this.data});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderDetailData.fromJson(json['data']) : null;
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

class OrderDetailData {
  int? id;
  String? orderId;
  String? status;
  String? roomNumber;
  String? tax;
  String? taxType;
  String? taxAmount;
  String? discount;
  String? discountType;
  String? discountAmount;
  String? subTotal;
  String? totalAmount;
  String? createdAt;
  String? comment;
  String? expectedTime;
  String? expectedUnit;
  List<OrderItems>? orderItems;
  OrderComplaints? orderComplaints;
  CancelOrder? cancelOrders;
  OrderOwner? orderOwner;

  OrderDetailData(
      {this.id,
        this.orderId,
        this.status,
        this.roomNumber,
        this.tax,
        this.taxType,
        this.taxAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.subTotal,
        this.totalAmount,
        this.createdAt,
        this.comment,
        this.orderItems,
        this.orderComplaints,
        this.cancelOrders,
        this.expectedTime,
        this.expectedUnit,
        this.orderOwner});

  String get orderItemString{

    String itemString = '';
    for(var model in orderItems!){
      itemString += model.units.toString() + " x " + model.name! + "\n";
    }
    return itemString;
  }

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
    roomNumber = json['room_number'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    createdAt = json['createdAt'];
    comment = json['comment'];
    expectedTime = json['expected_time'];
    expectedUnit = json['expected_unit'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    orderComplaints = json['order_complaints'] != null
        ? new OrderComplaints.fromJson(json['order_complaints'])
        : null;
    cancelOrders = json['cancel_orders'] != null
        ? new CancelOrder.fromJson(json['cancel_orders'])
        : null;
    orderOwner = json['order_owner'] != null
        ? new OrderOwner.fromJson(json['order_owner'])
        : null;

    if(comment != null && comment!.isEmpty){comment = null;}

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['room_number'] = this.roomNumber;
    data['tax'] = this.tax;
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
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.orderComplaints != null) {
      data['order_complaints'] = this.orderComplaints!.toJson();
    }
    if (this.cancelOrders != null) {
      data['cancel_orders'] = this.cancelOrders!.toJson();
    }
    if (this.orderOwner != null) {
      data['order_owner'] = this.orderOwner!.toJson();
    }
    return data;
  }
}

class OrderItems {
  int? units;
  String? pricePerUnit;
  String? totalPrice;
  var preparationUnit;
  var preparationTime;
  String? price;
  String? name;
  String? image;

  OrderItems(
      {this.units,
        this.pricePerUnit,
        this.totalPrice,
        this.preparationUnit,
        this.preparationTime,
        this.price,
        this.name,
        this.image});

  OrderItems.fromJson(Map<String, dynamic> json) {
    units = json['units'];
    pricePerUnit = json['price_per_unit'];
    totalPrice = json['total_price'];
    preparationUnit = json['preparation_unit'];
    preparationTime = json['preparation_time'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['units'] = this.units;
    data['price_per_unit'] = this.pricePerUnit;
    data['total_price'] = this.totalPrice;
    data['preparation_unit'] = this.preparationUnit;
    data['preparation_time'] = this.preparationTime;
    data['price'] = this.price;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class CancelOrder {
  int? id;
  String? status;
  String? reason;

  CancelOrder({this.id, this.status, this.reason});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Pending";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }
    return "Active";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  CancelOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class OrderComplaints {
  int? id;
  String? comment;
  String? status;

  OrderComplaints({this.id, this.comment, this.status});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Active";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }
    return "Active";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  OrderComplaints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['status'] = this.status;
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
