import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/trainingAndDevelopment/add_training_and_development.dart';
import 'package:employee_attendance_app/employee/trainingAndDevelopment/employee_training_and_development_detail.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewEmployeeTrainingAndDevelopment extends StatefulWidget {
  const ViewEmployeeTrainingAndDevelopment({super.key});

  @override
  State<ViewEmployeeTrainingAndDevelopment> createState() =>
      _ViewEmployeeTrainingAndDevelopmentState();
}

class _ViewEmployeeTrainingAndDevelopmentState
    extends State<ViewEmployeeTrainingAndDevelopment> {
  var programs = FirebaseFirestore.instance
      .collection("trainingAndDevelopments")
      .snapshots();
  List<TrainingProgram> myPrograms = [];
  var trainingProgramModel = TrainingProgram();

  @override
  void initState() {
    // TODO: implement initState

    getMyPrograms();
    super.initState();
  }

  getMyPrograms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String employeeId = prefs.getString("employeeId") ?? "";

    FirebaseCollection()
        .trainingProgramsCollection
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        trainingProgramModel = TrainingProgram();
        trainingProgramModel.title = doc['title'];
        trainingProgramModel.description = doc["description"];
        trainingProgramModel.date = doc["date"];
        trainingProgramModel.time = doc["time"];
        trainingProgramModel.meetingUrl = doc["meetingUrl"];
        trainingProgramModel.employees = json.decode(doc["employees"]);
        for (var employee in trainingProgramModel.employees ?? []) {
          if (employee == employeeId) {
            setState(() {
              myPrograms.add(trainingProgramModel);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Training & Development',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child:  ListView.builder(
                        itemCount: myPrograms.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(const EmployeeTrainingAndDevelopmentDetail(),
                                  transition: Transition.rightToLeftWithFade, arguments: myPrograms[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                tileColor: Colors.blueGrey.withOpacity(0.1),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(myPrograms[index].title ?? "",
                                        style: const TextStyle(
                                            fontFamily: AppFonts.medium)),
                                    Text(
                                        myPrograms[index].description ?? "",
                                        style: const TextStyle(
                                            fontFamily: AppFonts.medium)),
                                  ],
                                ),
                                trailing: Text(
                                    "${myPrograms[index].date ?? ""} ${myPrograms[index].time ?? ""}",
                                    style: const TextStyle(
                                        fontFamily: AppFonts.medium,
                                        fontSize: 14)),
                              ),
                            ),
                          );
                        }),
          ),
        ],
      ),
    );
  }
}

class TrainingProgram {
  String? title;
  String? description;
  String? date;
  String? time;
  String? meetingUrl;
  List? employees;
}
