// To parse this JSON data, do
//
//     final inOutModel = inOutModelFromJson(jsonString);

import 'dart:convert';

InOutModel inOutModelFromJson(String str) => InOutModel.fromJson(json.decode(str));

String inOutModelToJson(InOutModel data) => json.encode(data.toJson());

class InOutModel {
  InOutModel({
    required this.currentDate,
    this.inTime,
    this.outTime,
    this.duration,
    //this.inOutCheck,
  });

  String currentDate;
  String? inTime;
  String? outTime;
  String? duration;
  //bool? inOutCheck;

  factory InOutModel.fromJson(Map<String, dynamic> json) => InOutModel(
    currentDate: json["currentDate"],
    inTime: json["inTime"],
    outTime: json["outTime"],
    duration: json["duration"],
   // inOutCheck: json["inOutCheck"],
  );

  Map<String, dynamic> toJson() => {
    "currentDate": currentDate,
    "inTime": inTime,
    "outTime": outTime,
    "duration": duration,
   // "inOutCheck": inOutCheck,
  };
}
