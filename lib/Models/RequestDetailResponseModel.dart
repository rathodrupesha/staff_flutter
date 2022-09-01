import 'dart:ui';

import '../Utils/Constants.dart';

class RequestDetailResponse {
  int? code;
  int? status;
  String? msg;
  RequestDetailData? data;

  RequestDetailResponse({this.code, this.status, this.msg, this.data});

  RequestDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new RequestDetailData.fromJson(json['data']) : null;
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

class RequestDetailData {
  int? id;
  String? orderId;
  String? roomNo;
  String? requestedText;
  String? status;
  String? rejectionReason;
  String? date;
  String? createdAt;
  RequestOwner? requestOwner;
  RequestComplaints? requestComplaints;
  CancelRequests? cancelRequests;
  Hotel? hotel;
  MainCategory? mainCategory;
  SubCategory? subCategory;

  RequestDetailData(
      {this.id,
        this.orderId,
        this.roomNo,
        this.requestedText,
        this.status,
        this.rejectionReason,
        this.date,
        this.createdAt,
        this.requestOwner,
        this.requestComplaints,
        this.cancelRequests,
        this.hotel,
        this.mainCategory,
        this.subCategory});

  RequestDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    roomNo = json['room_no'];
    requestedText = json['requested_text'];
    status = json['status'];
    rejectionReason = json['rejection_reason'];
    date = json['date'];
    createdAt = json['createdAt'];
    requestOwner = json['request_owner'] != null
        ? new RequestOwner.fromJson(json['request_owner'])
        : null;
    requestComplaints = json['request_complaints'] != null
        ? new RequestComplaints.fromJson(json['request_complaints'])
        : null;
    cancelRequests = json['cancel_requests'] != null
        ? new CancelRequests.fromJson(json['cancel_requests'])
        : null;
    hotel = json['hotel'] != null ? new Hotel.fromJson(json['hotel']) : null;
    mainCategory = json['main_category'] != null
        ? new MainCategory.fromJson(json['main_category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;

    if(requestedText != null && requestedText!.isEmpty){requestedText = null;}

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['room_no'] = this.roomNo;
    data['requested_text'] = this.requestedText;
    data['status'] = this.status;
    data['rejection_reason'] = this.rejectionReason;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    if (this.requestOwner != null) {
      data['request_owner'] = this.requestOwner!.toJson();
    }
    if (this.requestComplaints != null) {
      data['request_complaints'] = this.requestComplaints!.toJson();
    }
    if (this.cancelRequests != null) {
      data['cancel_requests'] = this.cancelRequests!.toJson();
    }
    if (this.hotel != null) {
      data['hotel'] = this.hotel!.toJson();
    }
    if (this.mainCategory != null) {
      data['main_category'] = this.mainCategory!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
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

class RequestComplaints {
  int? id;
  String? status;
  String? comment;

  RequestComplaints({this.id, this.status, this.comment});

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

  RequestComplaints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['comment'] = this.comment;
    return data;
  }
}

class CancelRequests {
  int? id;
  String? status;
  String? reason;

  CancelRequests({this.id, this.status, this.reason});

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

  CancelRequests.fromJson(Map<String, dynamic> json) {
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

class Hotel {
  String? mainImage;
  String? hotelName;
  //Null? title;
  String? description;
  bool? status;

  Hotel(
      {this.mainImage,
        this.hotelName,
        //this.title,
        this.description,
        this.status});

  Hotel.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    hotelName = json['hotel_name'];
    //title = json['title'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['hotel_name'] = this.hotelName;
    //data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class MainCategory {
  String? image;
  String? name;
  String? type;

  MainCategory({this.image, this.name, this.type});

  MainCategory.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class SubCategory {
  String? name;
  String? description;

  SubCategory({this.name, this.description});

  SubCategory.fromJson(Map<String, dynamic> json) {
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
