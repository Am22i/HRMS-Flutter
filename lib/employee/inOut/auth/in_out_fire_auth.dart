import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:flutter/material.dart';

class InOutFireAuth{

  var mainCollection = FirebaseCollection().inOutCollection;

  var employeeInOutRef =FirebaseCollection().inOutCollection.snapshots();

  late String inTime, outTime, date, duration;
  //
  // Future<void> addInOutTime1({required String currentDate,
  //   required String inTime,
  //   String? outTime,
  //   String? duration,
  //   required String yearMonth,
  // }) async {
  //   DocumentReference documentReferencer = mainCollection.doc(DateTime.now().toString().substring(0,10));
  //   // documentReferencer.get();
  //   DocumentSnapshot inTime = await mainCollection.doc(DateTime.now().toString().substring(0,10)).get();
  //  final inTimeEntry = inTime.get('inTime');
  //
  //   Map<String, dynamic> data = <String, dynamic>{
  //     "currentDate": currentDate.toString(),
  //     "inTime": documentReferencer==null?inTimeEntry!=''?inTimeEntry:inTime.toString():inTime.toString(),
  //     "outTime": outTime.toString(),
  //     "duration": duration.toString(),
  //     "yearMonth": yearMonth,
  //   };
  //   debugPrint('In Out Data=> $data');
  //
  //   await documentReferencer
  //       .set(data)
  //       .whenComplete(() => debugPrint("Added In Out Data"))
  //       .catchError((e) => debugPrint(e));
  // }

  Future<void> addInOutTime({required String currentDate,
    required String inTime,
    String? outTime,
    String? duration,
    required String yearMonth,
  }) async {
    String inTimeEntry= '';
    String outTimeEntry='';
    String durationEntry='';
    DocumentReference documentReferencer = mainCollection.doc(DateTime.now().toString().substring(0,10));
    print("documentReferencer>>>>>>$documentReferencer");
    DocumentSnapshot documentSnapshot = await documentReferencer.get();

    if (documentSnapshot.exists) {
      DocumentSnapshot inOutTimeCurrentDateDoc = await mainCollection.doc(DateTime.now().toString().substring(0,10)).get();
      inTimeEntry = inOutTimeCurrentDateDoc.get('inTime');
      outTimeEntry = inOutTimeCurrentDateDoc.get('outTime');
      durationEntry = inOutTimeCurrentDateDoc.get('duration');

    }

    Map<String, dynamic> data = <String, dynamic>{
      "currentDate": currentDate.toString(),
      "inTime": documentSnapshot.exists?inTimeEntry!=''?inTimeEntry:inTime.toString():inTime.toString(),
      "outTime": documentSnapshot.exists?outTimeEntry!=''?outTimeEntry:outTime.toString():outTime.toString(),
      "duration": documentSnapshot.exists?durationEntry!='00:00'?durationEntry:duration.toString():duration.toString(),
      "yearMonth": yearMonth,
    };
    debugPrint('In Out Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added In Out Data"))
        .catchError((e) => debugPrint(e));
  }




}