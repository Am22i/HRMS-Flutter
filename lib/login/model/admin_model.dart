// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'dart:convert';

AdminModel adminModelFromJson(String str) => AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {

  String companyName;
  String email;
  String mobile;
  String type;

  AdminModel({
    required this.companyName,
    required this.email,
    required this.mobile,
    required this.type,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    companyName: json["companyName"],
    email: json["email"],
    mobile: json["mobile"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "email": email,
    "mobile": mobile,
    "type": type,
  };
}
