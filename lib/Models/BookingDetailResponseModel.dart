import 'dart:ui';

import '../Utils/Constants.dart';

class BookingDetailResponse {
  int? code;
  int? status;
  String? msg;
  BookingDetailData? data;

  BookingDetailResponse({this.code, this.status, this.msg, this.data});

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new BookingDetailData.fromJson(json['data']) : null;
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

class BookingDetailData {
  int? id;
  String? orderId;
  String? startTime;
  String? endTime;
  String? duration;
  String? status;
  String? date;
  //String? acceptedBy;
  String? acceptOrRejectDate;
  int? rejectedBy;
  String? rejectedReason;
  String? createdAt;
  String? amountUnit;
  String? durationUnit;
  String? roomNo;
  String? tax;
  String? taxType;
  String? taxAmount;
  String? discount;
  String? discountType;
  String? discountAmount;
  String? subTotal;
  String? totalAmount;
  int? noOfPerson;
  PremiumServices? premiumServices;
  PremiumPackageServices? premiumPackageServices;
  BookingComplaints? bookingComplaints;
  BookingOwner? bookingOwner;
  CancelBooking? cancelBookings;

  BookingDetailData(
      {this.id,
        this.orderId,
        this.startTime,
        this.endTime,
        this.duration,
        this.status,
        this.date,
        //this.acceptedBy,
        this.acceptOrRejectDate,
        this.rejectedBy,
        this.rejectedReason,
        this.createdAt,
        this.amountUnit,
        this.durationUnit,
        this.roomNo,
        this.tax,
        this.taxType,
        this.taxAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.subTotal,
        this.totalAmount,
        this.noOfPerson,
        this.premiumServices,
        this.premiumPackageServices,
        this.bookingComplaints,
        this.bookingOwner,
        this.cancelBookings});


  BookingDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    status = json['status'];
    date = json['date'];
    //acceptedBy = json['accepted_by'];
    acceptOrRejectDate = json['accept_or_reject_date'];
    rejectedBy = json['rejected_by'];
    rejectedReason = json['rejected_reason'];
    createdAt = json['createdAt'];
    amountUnit = json['amount_unit'];
    durationUnit = json['duration_unit'];
    roomNo = json['room_no'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    noOfPerson = json['no_of_person'];
    premiumServices = json['premiumServices'] != null
        ? new PremiumServices.fromJson(json['premiumServices'])
        : null;
    premiumPackageServices = json['premiumPackageServices'] != null
        ? new PremiumPackageServices.fromJson(json['premiumPackageServices'])
        : null;
    bookingComplaints = json['booking_complaints'] != null
        ? new BookingComplaints.fromJson(json['booking_complaints'])
        : null;
    bookingOwner = json['booking_owner'] != null
        ? new BookingOwner.fromJson(json['booking_owner'])
        : null;
    cancelBookings = json['cancel_bookings'] != null
        ? new CancelBooking.fromJson(json['cancel_bookings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['date'] = this.date;
    //data['accepted_by'] = this.acceptedBy;
    data['accept_or_reject_date'] = this.acceptOrRejectDate;
    data['rejected_by'] = this.rejectedBy;
    data['rejected_reason'] = this.rejectedReason;
    data['createdAt'] = this.createdAt;
    data['amount_unit'] = this.amountUnit;
    data['duration_unit'] = this.durationUnit;
    data['room_no'] = this.roomNo;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['tax_amount'] = this.taxAmount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['sub_total'] = this.subTotal;
    data['total_amount'] = this.totalAmount;
    data['no_of_person'] = this.noOfPerson;
    if (this.premiumServices != null) {
      data['premiumServices'] = this.premiumServices!.toJson();
    }
    if (this.premiumPackageServices != null) {
      data['premiumPackageServices'] = this.premiumPackageServices!.toJson();
    }
    if (this.bookingComplaints != null) {
      data['booking_complaints'] = this.bookingComplaints!.toJson();
    }
    if (this.bookingOwner != null) {
      data['booking_owner'] = this.bookingOwner!.toJson();
    }
    if (this.cancelBookings != null) {
      data['cancel_bookings'] = this.cancelBookings!.toJson();
    }
    return data;
  }
}

class PremiumServices {
  String? mainImage;
  String? name;
  String? description;
  String? discount;
  String? discountType;
  String? importantNotes;
  //Null? deletedBy;
  //Null? deletedAt;

  PremiumServices(
      {this.mainImage,
        this.name,
        this.description,
        this.discount,
        this.discountType,
        this.importantNotes,
        /*this.deletedBy,
        this.deletedAt*/});

  PremiumServices.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    name = json['name'];
    description = json['description'];
    discount = json['discount'];
    discountType = json['discount_type'];
    importantNotes = json['important_notes'];
    //deletedBy = json['deleted_by'];
    //deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['name'] = this.name;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['important_notes'] = this.importantNotes;
    //data['deleted_by'] = this.deletedBy;
    //data['deletedAt'] = this.deletedAt;
    return data;
  }
}

class PremiumPackageServices {
  String? name;
  SlotDetail? slotDetail;

  PremiumPackageServices({this.name, this.slotDetail});

  PremiumPackageServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slotDetail = json['slotDetail'] != null
        ? new SlotDetail.fromJson(json['slotDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.slotDetail != null) {
      data['slotDetail'] = this.slotDetail!.toJson();
    }
    return data;
  }
}

class SlotDetail {
  String? date;
  String? startTime;
  String? endTime;

  SlotDetail({this.date, this.startTime, this.endTime});

  SlotDetail.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}

class BookingComplaints {
  int? id;
  String? comment;
  String? status;

  BookingComplaints({this.id, this.comment, this.status});

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

  BookingComplaints.fromJson(Map<String, dynamic> json) {
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

class CancelBooking {
  int? id;
  String? status;
  String? reason;

  CancelBooking({this.id, this.status, this.reason});

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

  CancelBooking.fromJson(Map<String, dynamic> json) {
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
