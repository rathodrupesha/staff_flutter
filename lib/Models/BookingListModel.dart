import 'dart:ui';

import 'package:hamrostay/Utils/Constants.dart';

class BookingListModel {
  int? code;
  int? status;
  String? msg;
  BookingData? data;

  BookingListModel({this.code, this.status, this.msg, this.data});

  BookingListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new BookingData.fromJson(json['data']) : null;
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

class BookingData {
  int? count;
  List<BookingListRows>? rows;
  int? currentPage;

  BookingData({this.count, this.rows, this.currentPage});

  BookingData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <BookingListRows>[];
      json['rows'].forEach((v) {
        rows!.add(new BookingListRows.fromJson(v));
      });
    }
    //totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    //data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class BookingListRows {
  int? id;
  String? orderId;
  String? status;
  String? createdAt;
  String? roomNo;
  int? noOfPerson;
  String? totalAmount;
  BookingOwner? bookingOwner;
  PremiumPackageServices? premiumPackageServices;
  PremiumServices? premiumServices;

  BookingListRows(
      {this.id,
        this.orderId,
        this.status,
        this.createdAt,
        this.bookingOwner,
        this.roomNo,
        this.noOfPerson,
        this.totalAmount,
        this.premiumPackageServices,this.premiumServices});

  BookingListRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    roomNo = json['room_no'];
    noOfPerson = json['no_of_person'];
    totalAmount = json['total_amount'];
    bookingOwner = json['booking_owner'] != null
        ? new BookingOwner.fromJson(json['booking_owner'])
        : null;
    premiumPackageServices = json['premiumPackageServices'] != null
        ? new PremiumPackageServices.fromJson(json['premiumPackageServices'])
        : null;
    premiumServices = json['premiumServices'] != null
        ? new PremiumServices.fromJson(json['premiumServices'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['room_no'] = this.roomNo;
    data['no_of_person'] = this.noOfPerson;
    data['total_amount'] = this.totalAmount;
    if (this.bookingOwner != null) {
      data['booking_owner'] = this.bookingOwner!.toJson();
    }
    if (this.premiumPackageServices != null) {
      data['premiumPackageServices'] = this.premiumPackageServices!.toJson();
    }
    if (this.premiumServices != null) {
      data['premiumServices'] = this.premiumServices!.toJson();
    }
    return data;
  }
}

class BookingOwner {
  String? firstName;
  String? lastName;
  String? profileImage;

  BookingOwner({this.firstName, this.lastName, this.profileImage});

  BookingOwner.fromJson(Map<String, dynamic> json) {
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

class PremiumPackageServices {
  String? name;

  PremiumPackageServices({this.name});

  PremiumPackageServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
class PremiumServices {
  String? mainImage;
  String? name;
  String? description;
  //Null? discount;
  //Null? discountType;
  String? importantNotes;
  //Null? deletedBy;
  //Null? deletedAt;

  PremiumServices(
      {this.mainImage,
        this.name,
        this.description,
        //this.discount,
        //this.discountType,
        this.importantNotes,
        //this.deletedBy,
        /*this.deletedAt*/});

  PremiumServices.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    name = json['name'];
    description = json['description'];
    //discount = json['discount'];
    //discountType = json['discount_type'];
    importantNotes = json['important_notes'];
    //deletedBy = json['deleted_by'];
    //deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['name'] = this.name;
    data['description'] = this.description;
    //data['discount'] = this.discount;
    //data['discount_type'] = this.discountType;
    data['important_notes'] = this.importantNotes;
    //data['deleted_by'] = this.deletedBy;
    //data['deletedAt'] = this.deletedAt;
    return data;
  }
}

