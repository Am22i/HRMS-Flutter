// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  EmployeeModel({
    required this.address,
    required this.branch,
    required this.dateofjoining,
    required this.department,
    required this.designation,
    required this.email,
    required this.dob,
    required this.employeeName,
    required this.employmentType,
    required this.exprience,
    required this.imageUrl,
    required this.mobile,
    required this.type,
  });

  String address;
  String branch;
  String dateofjoining;
  String department;
  String designation;
  String email;
  String dob;
  String employeeName;
  String employmentType;
  String exprience;
  String imageUrl;
  String mobile;
  String type;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    address: json["address"],
    branch: json["branch"],
    dateofjoining: json["dateofjoining"],
    department: json["department"],
    designation: json["designation"],
    email: json["email"],
    dob: json["dob"],
    employeeName: json["employeeName"],
    employmentType: json["employment_type"],
    exprience: json["exprience"],
    imageUrl: json["imageUrl"],
    mobile: json["mobile"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "branch": branch,
    "dateofjoining": dateofjoining,
    "department": department,
    "designation": designation,
    "email": email,
    "dob": dob,
    "employeeName": employeeName,
    "employment_type": employmentType,
    "exprience": exprience,
    "imageUrl": imageUrl,
    "mobile": mobile,
    "type": type,
  };
}
