
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/app_utils.dart';
import '../../../widget/employee_bottom_navigationbar.dart';

class LeaveFireAuth {
  // Future<void> applyLeave(
  //     {required String leaveEmail,
  //     required String leaveEmployeeName,
  //     required String leaveFrom,
  //     required String leaveTo,
  //     required String leaveDays,
  //     required String leaveType,
  //     required String leaveReason,
  //     required String leaveFromTime,
  //     required String leaveToTime,
  //     required String leaveHours,
  //     required String leaveStatus}) async {
  //   String leaveFormFireStore = '';
  //   String leaveToFireStore = '';
  //   DocumentReference documentReferencer = FirebaseFirestore.instance.collection('leave').doc('$leaveEmail $leaveFrom');
  //   DocumentSnapshot documentSnapshot = await documentReferencer.get();
  //   if (documentSnapshot.exists) {
  //     DocumentSnapshot inOutTimeCurrentDateDoc = await FirebaseFirestore.instance.collection('leave').doc('$leaveEmail $leaveFrom').get();
  //     leaveFormFireStore = inOutTimeCurrentDateDoc.get('leaveForm');
  //     leaveToFireStore = inOutTimeCurrentDateDoc.get('leaveTo');
  //     DateTime startDate = DateTime.parse(leaveFormFireStore);
  //     DateTime endDate = DateTime.parse(leaveToFireStore);
  //     DateTime pickedDate = DateTime.parse(leaveFrom.toString());
  //     bool isInRange = pickedDate.isAfter(startDate) && pickedDate.isBefore(endDate) || pickedDate.isAtSameMomentAs(startDate) || pickedDate.isAtSameMomentAs(endDate);
  //     if(isInRange){
  //       AppUtils.instance.showToast(toastMessage: "Leave Not Picked");
  //       return;
  //     }
  //     print("PICKED_DATE_IS_IN_RANGE $isInRange");
  //   }
  //   Map<String, dynamic> data = <String, dynamic>{
  //     "leaveEmail": leaveEmail.toString(),
  //     "leaveEmployeeName": leaveEmployeeName.toString(),
  //     "leaveForm": leaveFrom.toString(),
  //     "leaveTo": leaveTo.toString(),
  //     "leaveDays": leaveDays.toString(),
  //     "leaveStatus": leaveStatus.toString(),
  //     "leaveFromTime": leaveFromTime.toString(),
  //     "leaveToTime": leaveToTime.toString(),
  //     "leaveHours": leaveHours.toString(),
  //     "leaveReason": leaveReason.toString(),
  //     "leaveType": leaveType.toString(),
  //     "created_at": DateTime.now().toString()
  //   };
  //   debugPrint('Leave Application Data => $data');
  //   await documentReferencer.set(data).whenComplete(() {
  //     debugPrint("Applying for leave");
  //   }).catchError((e) => debugPrint(e));
  // }
  Future<void> applyLeaveAdmin({
    required String leaveEmail,
    required String leaveEmployeeName,
    required String leaveFrom,
    required String leaveTo,
    required String leaveDays,
    required String leaveType,
    required String leaveReason,
    required String leaveFromTime,
    required String leaveToTime,
    required String leaveHours,
    required String leaveStatus,
    required BuildContext context,
  }) async {
    DocumentReference documentReferencer = FirebaseFirestore.instance
        .collection('leave')
        .doc('$leaveEmail $leaveFrom');
    Map<String, dynamic> data = <String, dynamic>{
      "leaveEmail": leaveEmail,
      "leaveEmployeeName": leaveEmployeeName,
      "leaveForm": leaveFrom,
      "leaveTo": leaveTo,
      "leaveDays": leaveDays,
      "leaveStatus": leaveStatus,
      "leaveFromTime": leaveFromTime,
      "leaveToTime": leaveToTime,
      "leaveHours": leaveHours,
      "leaveReason": leaveReason,
      "leaveType": leaveType,
      "created_at": DateTime.now().toString(),
    };
    debugPrint('Leave Application Data => $data');
    await documentReferencer.set(data).whenComplete(() {
      debugPrint("Applying for leave");
    }).catchError((e) => debugPrint(e));
  }

  /* Future<void> applyLeaveUser({
    required String leaveEmail,
    required String leaveEmployeeName,
    required String leaveFrom,
    required String leaveTo,
    required String leaveDays,
    required String leaveType,
    required String leaveReason,
    required String leaveFromTime,
    required String leaveToTime,
    required String leaveHours,
    required String leaveStatus,
    required BuildContext context,
  }) async {
    String leaveFormFireStore = '';
    String leaveToFireStore = '';
    DocumentReference documentReferencer = FirebaseFirestore.instance.collection('leave').doc('$leaveEmail $leaveFrom');
      // DocumentSnapshot documentSnapshot = await documentReferencer.get();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('leave').where('leaveEmail', isEqualTo:leaveEmail).get();
      if (querySnapshot.docs.exists) {
      DocumentSnapshot inOutTimeCurrentDateDoc = await FirebaseFirestore.instance.collection('leave').doc('$leaveEmail $leaveFrom').get();
      leaveFormFireStore = inOutTimeCurrentDateDoc.get('leaveForm');
      leaveToFireStore = inOutTimeCurrentDateDoc.get('leaveTo');
      print("LEAVE COLLECTION DATE $leaveFormFireStore $leaveToFireStore");
      DateTime startDate = DateTime.parse(leaveFormFireStore);
      DateTime endDate = DateTime.parse(leaveToFireStore);
      DateTime pickedDate = DateTime.parse(leaveFrom);
      bool isInRange = pickedDate.isAfter(startDate) &&
          pickedDate.isBefore(endDate) ||
          pickedDate.isAtSameMomentAs(startDate) ||
          pickedDate.isAtSameMomentAs(endDate);

      if (isInRange) {
        FocusScope.of(context).unfocus();
        AppUtils.instance.showToast(toastMessage: "Leave request cannot be added for the same date or within a date range.",toastLength: Toast.LENGTH_LONG);
        return;
      }
      print("PICKED_DATE_IS_IN_RANGE $isInRange");
    }
    Map<String, dynamic> data = <String, dynamic>{
      "leaveEmail": leaveEmail,
      "leaveEmployeeName": leaveEmployeeName,
      "leaveForm": leaveFrom,
      "leaveTo": leaveTo,
      "leaveDays": leaveDays,
      "leaveStatus": leaveStatus,
      "leaveFromTime": leaveFromTime,
      "leaveToTime": leaveToTime,
      "leaveHours": leaveHours,
      "leaveReason": leaveReason,
      "leaveType": leaveType,
      "created_at": DateTime.now().toString(),
    };
    await documentReferencer.set(data).whenComplete(() {
      Get.offAll(const BottomNavBarScreen());
      AppUtils.instance.showToast(toastMessage: "Leave Apply Successfully",toastLength: Toast.LENGTH_LONG);
    }).catchError((e) => debugPrint(e));
  }*/
  Future<void> applyLeaveUser({
    required String leaveEmail,
    required String leaveEmployeeName,
    required String leaveFrom,
    required String leaveTo,
    required String leaveDays,
    required String leaveType,
    required String leaveReason,
    required String leaveFromTime,
    required String leaveToTime,
    required String leaveHours,
    required String leaveStatus,
    required BuildContext context,
  }) async {
    DocumentReference documentReferencer = FirebaseFirestore.instance
        .collection('leave')
        .doc('$leaveEmail $leaveFrom');
    print("loggedOnce :- ${FirebaseAuth.instance.currentUser!.email}");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('leave')
        .where('leaveEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
        print("QuerySnapshot ${querySnapshot.docs}");
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String leaveFormFirestore = documentSnapshot['leaveForm'];
        String leaveToFirestore = documentSnapshot['leaveTo'];
        print("docLeave $leaveFormFirestore $leaveToFirestore");

        DateTime startDate = DateTime.parse(leaveFormFirestore);
        DateTime endDate = DateTime.parse(leaveToFirestore);
        DateTime pickedDate = DateTime.parse(leaveFrom);
        print("LeaveParse $startDate $endDate $pickedDate");

        bool isInRange =
            pickedDate.isAfter(startDate) && pickedDate.isBefore(endDate) ||
                pickedDate.isAtSameMomentAs(startDate) ||
                pickedDate.isAtSameMomentAs(endDate);

        if (isInRange) {
          FocusScope.of(context).unfocus();
          AppUtils.instance.showToast(
              toastMessage:
                  "Leave request cannot be added for the same date or within a date range.",
              toastLength: Toast.LENGTH_LONG);
          return;
        }
      }
    }

    // Continue with the code to add a new leave document
    Map<String, dynamic> data = <String, dynamic>{
      "leaveEmail": leaveEmail,
      "leaveEmployeeName": leaveEmployeeName,
      "leaveForm": leaveFrom,
      "leaveTo": leaveTo,
      "leaveDays": leaveDays,
      "leaveStatus": leaveStatus,
      "leaveFromTime": leaveFromTime,
      "leaveToTime": leaveToTime,
      "leaveHours": leaveHours,
      "leaveReason": leaveReason,
      "leaveType": leaveType,
      "created_at": DateTime.now().toString(),
    };

    await documentReferencer.set(data).whenComplete(() {
      Get.offAll(const BottomNavBarScreen());
      AppUtils.instance.showToast(
          toastMessage: "Leave Apply Successfully",
          toastLength: Toast.LENGTH_LONG);
    }).catchError((e) => debugPrint(e));
  }
}
