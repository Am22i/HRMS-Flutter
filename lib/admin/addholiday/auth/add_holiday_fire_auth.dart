
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../firebase/firebase_collection.dart';
import '../../../utils/app_utils.dart';

class AddHolidayFireAuth{

  Future<void> addPublicHoliday(
      {required String holidayDate,
        required String holidayName,
        required String holidayDescription,
      }) async {
    DocumentReference documentReferencer =
    FirebaseCollection().holidayCollection.doc(holidayDate);

    Map<String, dynamic> data = <String, dynamic>{
      "holidayDate": holidayDate.toString(),
      "holidayName": holidayName.toString(),
      "holidayDescription": holidayDescription.toString()
    };
    debugPrint('Holiday data=> $data');

    FirebaseCollection().holidayCollection.get().then((querySnapshot) {
      // for (var result in querySnapshot.docs) {
      //   // print(result.data());
      // }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() {
        AppUtils.instance.showToast(toastMessage: 'Public Holiday is added.');
    })
        .catchError((e) => Get.snackbar('Error', e));
  }

}