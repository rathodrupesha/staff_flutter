import 'dart:ui';

import 'package:hamrostay/Utils/Constants.dart';

class RequestListModel {
  int? code;
  int? status;
  String? msg;
  RequestData? data;

  RequestListModel({this.code, this.status, this.msg, this.data});

  RequestListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new RequestData.fromJson(json['data']) : null;
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

class RequestData {
  int? count;
  List<RequestListRows>? rows;
  //Null? totalPages;
 // int? currentPage;

  RequestData({this.count, this.rows/*, this.totalPages, this.currentPage*/});

  RequestData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <RequestListRows>[];
      json['rows'].forEach((v) {
        rows!.add(new RequestListRows.fromJson(v));
      });
    }
    //totalPages = json['totalPages'];
    //currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    //data['totalPages'] = this.totalPages;
    //data['currentPage'] = this.currentPage;
    return data;
  }
}

class RequestListRows {
  int? id;
  String? status;
  String? orderId;
  String? createdAt;
  String? requestedText;
  String? roomNo;
  RequestOwner? requestOwner;
  HotelRequestSubService? hotelRequestSubService;

  RequestListRows(
      {this.id,
        this.status,
        this.orderId,
        this.createdAt,
        this.requestedText,
        this.requestOwner,
        this.roomNo,
        this.hotelRequestSubService});

  RequestListRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    orderId = json['order_id'];
    createdAt = json['createdAt'];
    requestedText = json['requested_text'];
    roomNo = json['room_no'];
    requestOwner = json['request_owner'] != null
        ? new RequestOwner.fromJson(json['request_owner'])
        : null;
    hotelRequestSubService = json['hotel_request_sub_service'] != null
        ? new HotelRequestSubService.fromJson(json['hotel_request_sub_service'])
        : null;

    if(requestedText != null && requestedText!.isEmpty){requestedText = null;}

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['createdAt'] = this.createdAt;
    data['requested_text'] = this.requestedText;
    data['room_no'] = this.roomNo;
    if (this.requestOwner != null) {
      data['request_owner'] = this.requestOwner!.toJson();
    }
    if (this.hotelRequestSubService != null) {
      data['hotel_request_sub_service'] = this.hotelRequestSubService!.toJson();
    }


    return data;
  }
}

class RequestOwner {
  String? firstName;
  String? lastName;
  String? profileImage;

  RequestOwner({this.firstName, this.lastName, this.profileImage});

  RequestOwner.fromJson(Map<String, dynamic> json) {
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

class HotelRequestSubService {
  String? name;
  String? description;

  HotelRequestSubService({this.name, this.description});

  HotelRequestSubService.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

