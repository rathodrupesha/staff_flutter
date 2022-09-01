class AssignServiceResponseModel {
  int? code;
  int? status;
  String? msg;
  List<AssignServiceData>? data;

  AssignServiceResponseModel({this.code, this.status, this.msg, this.data});

  AssignServiceResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AssignServiceData>[];
      json['data'].forEach((v) {
        data!.add(new AssignServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignServiceData {
  int? id;
  String? name;
  String? image;
  String? type;
  int? count;

  AssignServiceData({this.id, this.name, this.image,this.type, this.count});

  AssignServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['count'] = this.count;
    data['type'] = this.type;
    return data;
  }
}
