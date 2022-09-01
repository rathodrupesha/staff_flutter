class UserModel {
  int? code;
  int? status;
  String? msg;
  UserData? data;

  UserModel({this.code, this.status, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] == "") {
      data = null;
    } else {
      data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    }
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

class UserData {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  bool? isDeleted;
  StaffHotelId? staffHotelId;
  String? token;
  String? accessToken;
  int? hotelId;
  String? mobileNum;

  UserData(
      {this.id,
      this.userName,
      this.firstName,
      this.lastName,
      this.email,
      this.profileImage,
      this.isDeleted,
      this.staffHotelId,
      this.token,
      this.accessToken,
      this.hotelId,
      this.mobileNum});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    isDeleted = json['is_deleted'];
    staffHotelId = json['staffHotelId'] != null
        ? new StaffHotelId.fromJson(json['staffHotelId'])
        : null;
    token = json['token'];
    accessToken = json['access_token'];
    hotelId = json['hotel_id'];
    mobileNum = json['mobile_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['is_deleted'] = this.isDeleted;
    if (this.staffHotelId != null) {
      data['staffHotelId'] = this.staffHotelId!.toJson();
    }
    data['token'] = this.token;
    data['access_token'] = this.accessToken;
    data['hotel_id'] = this.hotelId;
    data['mobile_num'] = this.mobileNum;
    return data;
  }
}

class StaffHotelId {
  int? hotelId;
  CurrentHotel? currentHotel;

  StaffHotelId({this.hotelId,this.currentHotel});

  StaffHotelId.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotel_id'];
    currentHotel = json['current_hotel'] != null
        ? new CurrentHotel.fromJson(json['current_hotel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_id'] = this.hotelId;
    if (this.currentHotel != null) {
      data['current_hotel'] = this.currentHotel!.toJson();
    }
    return data;
  }
}
class CurrentHotel {
  String? hotelName;
  String? currencySymbol;

  CurrentHotel({this.hotelName, this.currencySymbol});

  CurrentHotel.fromJson(Map<String, dynamic> json) {
    hotelName = json['hotel_name'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_name'] = this.hotelName;
    data['currency_symbol'] = this.currencySymbol;
    return data;
  }
}
