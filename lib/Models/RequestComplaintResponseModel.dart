import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class RequestComplaintResponseModel {
  int? code;
  int? status;
  String? msg;
  RequestComplaintData? data;

  RequestComplaintResponseModel({this.code, this.status, this.msg, this.data});

  RequestComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new RequestComplaintData.fromJson(json['data']) : null;
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

class RequestComplaintData {
  int? count;
  List<RequestComplaintRows>? rows;
  int? totalPages;
  int? currentPage;

  RequestComplaintData({this.count, this.rows, this.totalPages, this.currentPage});

  RequestComplaintData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <RequestComplaintRows>[];
      json['rows'].forEach((v) {
        rows!.add(new RequestComplaintRows.fromJson(v));
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

class RequestComplaintRows {
  int? id;
  String? status;
  String? comment;
  String? orderId;
  String? requestedText;
  String? roomNo;
  String? service;
  String? subService;

  RequestComplaintRows(
      {this.id,
        this.status,
        this.comment,
        this.orderId,
        this.requestedText,
        this.roomNo,
        this.service,
        this.subService});

  RequestComplaintRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    comment = json['comment'];
    orderId = json['order_id'];
    requestedText = json['requested_text'];
    roomNo = json['room_no'];
    service = json['service'];
    subService = json['sub_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['comment'] = this.comment;
    data['order_id'] = this.orderId;
    data['requested_text'] = this.requestedText;
    data['room_no'] = this.roomNo;
    data['service'] = this.service;
    data['sub_service'] = this.subService;
    return data;
  }
}
