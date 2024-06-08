import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/trainingAndDevelopment/view_employee_training_and_development.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../utils/app_utils.dart';

class EmployeeTrainingAndDevelopmentDetail extends StatefulWidget {
  const EmployeeTrainingAndDevelopmentDetail({super.key});

  @override
  State<EmployeeTrainingAndDevelopmentDetail> createState() =>
      _EmployeeTrainingAndDevelopmentDetailState();
}

class _EmployeeTrainingAndDevelopmentDetailState extends State<EmployeeTrainingAndDevelopmentDetail> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var meetingUrlController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var employeesController = TextEditingController();
  var employees = FirebaseFirestore.instance.collection("employee").snapshots();
  TimeOfDay selectedTime =
  TimeOfDay(hour: DateTime
      .now()
      .hour, minute: DateTime
      .now()
      .minute);
  List<EmployeeModel> selectedEmployees = [];
  List<String> selectedEmployeeIds = [];

  var trainingProgramModel = TrainingProgram();

  @override
  void initState() {
    // TODO: implement initState
    trainingProgramModel = Get.arguments;
    titleController.text = trainingProgramModel.title ?? "";
    descriptionController.text = trainingProgramModel.description ?? "";
    meetingUrlController.text = trainingProgramModel.meetingUrl ?? "";
    dateController.text = trainingProgramModel.date ?? "";
    timeController.text = trainingProgramModel.time ?? "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Training & Development',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: ListView(
          children: [
            TextFormField(
              enabled: false,
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
              decoration: InputDecoration(
                label: Text(
                  "Title",
                  style: const TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: const TextStyle(
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
              enabled: false,
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
              decoration: InputDecoration(
                label: Text(
                  "Description",
                  style: const TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF89889B),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              enabled: false,
              controller: meetingUrlController,
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
              decoration: InputDecoration(
                label: Text(
                  "Meeting URL",
                  style: const TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: const TextStyle(
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
              enabled: false,
              controller: dateController,
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
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.date_range_outlined,
                    color: AppColor.appColor),
                label: Text(
                  "Date",
                  style: const TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: const TextStyle(
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
              enabled: false,
              controller: timeController,
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
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.access_time_outlined,
                    color: AppColor.appColor),
                label: Text(
                  "Time",
                  style: const TextStyle(
                    color: AppColor.appColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF89889B),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeModel {
  String? name;
  String? id;
}
