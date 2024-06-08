import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_utils.dart';

class AddGrievance extends StatefulWidget {
  const AddGrievance({super.key});

  @override
  State<AddGrievance> createState() =>
      _AddGrievanceState();
}

class _AddGrievanceState extends State<AddGrievance> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Add Grievance',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: ListView(
          children: [
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* Required";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                color: AppColor.appColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                label: Text(
                  "Complain",
                  style: TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: TextStyle(
                  color: Color(0xFF89889B),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: descriptionController,
              style: const TextStyle(
                color: AppColor.appColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* Required";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                label: Text(
                  "Details",
                  style: TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: TextStyle(
                  color: Color(0xFF89889B),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                  onTap: () {
                    validateTrainingAndDevelopment();
                  },
                  child: ButtonMixin().stylishButton(text: 'Submit')),
            ),
          ],
        ),
      ),
    );
  }



   validateTrainingAndDevelopment() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String employeeId = prefs.getString("employeeId") ?? "";

    if (titleController.text.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please enter complaint title');
    }
    if (titleController.text.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please enter complaint details');
    }
    else {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('EEE d MMM kk:mm').format(now);

      FirebaseFirestore.instance.collection("Grievances").add({
        "title": titleController.text,
        "description": descriptionController.text,
        "employeeId": employeeId,
        "dateTime": formattedDate,
      }).then((value) {
        AppUtils.instance.showToast(toastMessage: 'Your complaint has been submitted.');
        Navigator.pop(context, "added");
      });
    }
  }
}
