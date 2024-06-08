import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../utils/app_utils.dart';

class AddTrainingAndDevelopment extends StatefulWidget {
  const AddTrainingAndDevelopment({super.key});

  @override
  State<AddTrainingAndDevelopment> createState() =>
      _AddTrainingAndDevelopmentState();
}

class _AddTrainingAndDevelopmentState extends State<AddTrainingAndDevelopment> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var meetingUrlController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var employeesController = TextEditingController();
  var employees = FirebaseFirestore.instance.collection("employee").snapshots();
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  List<EmployeeModel> selectedEmployees = [];
  List<String> selectedEmployeeIds = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Add Training & Development',
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
              controller: meetingUrlController,
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
              controller: dateController,
              onTap: () {
                selectDate();
              },
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
              controller: timeController,
              onTap: () {
                selectTime(context);
              },
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
            Text(
              "Employees",
              style: const TextStyle(
                color: AppColor.appColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: selectedEmployees.length * 35,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 35,
                    childAspectRatio: 2.9),
                itemCount: selectedEmployees.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black45),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            selectedEmployees[index].name ?? "",
                            style: const TextStyle(
                              color: AppColor.appColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEmployeeIds
                                    .remove(selectedEmployees[index].id);
                              });
                              for (var employee in selectedEmployees) {
                                if (employee.id ==
                                    selectedEmployees[index].id) {
                                  selectedEmployees.remove(employee);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                selectEmployeesPopup();
              },
              child: TextFormField(
                enabled: false,
                controller: employeesController,
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
                  label: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColor.appColor,
                      ),
                      Text(
                        "Add Employees",
                        style: const TextStyle(
                          color: AppColor.appColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                  onTap: () {
                    validateTrainingAndDevelopment();
                  },
                  child: ButtonMixin().stylishButton(text: 'Add Program')),
            ),
          ],
        ),
      ),
    );
  }

  selectEmployeesPopup() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
        return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            backgroundColor: Colors.white,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: StreamBuilder(
                          stream: employees,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Something went wrong",
                                      style: TextStyle(
                                          fontFamily: AppFonts.medium)));
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: Text(
                                "No Data Found",
                                style: TextStyle(fontFamily: AppFonts.medium),
                              ));
                            } else if (snapshot
                                .requireData.docChanges.isEmpty) {
                              return const Center(
                                  child: Text(
                                "No Data Found",
                                style: TextStyle(fontFamily: AppFonts.medium),
                              ));
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (selectedEmployeeIds.contains(
                                            snapshot.data!.docs[index].id)) {
                                          setDialogState(() {
                                            selectedEmployeeIds.remove(
                                                snapshot.data!.docs[index].id);
                                          });
                                          for (var employee
                                              in selectedEmployees) {
                                            if (employee.id ==
                                                snapshot.data!.docs[index].id) {
                                              selectedEmployees
                                                  .remove(employee);
                                            }
                                          }
                                        } else {
                                          EmployeeModel employeeModel =
                                              EmployeeModel();
                                          employeeModel.name = snapshot.data!
                                              .docs[index]["employeeName"];
                                          employeeModel.id =
                                              snapshot.data!.docs[index].id;
                                          selectedEmployees.add(employeeModel);
                                          setDialogState(() {
                                            selectedEmployeeIds.add(
                                                snapshot.data!.docs[index].id);
                                          });
                                        }
                                      },
                                      child: ListTile(
                                        tileColor: index.isOdd
                                            ? Colors.blueGrey.withOpacity(0.1)
                                            : Colors.white,
                                        title: Text(
                                            snapshot.data!.docs[index]
                                                ["employeeName"],
                                            style: const TextStyle(
                                                fontFamily: AppFonts.medium)),
                                        leading: Text('${index + 1}',
                                            style: const TextStyle(
                                                fontFamily: AppFonts.medium)),
                                        trailing: Visibility(
                                            visible: selectedEmployeeIds
                                                .contains(snapshot
                                                    .data!.docs[index].id),
                                            child: const Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Colors.green,
                                            )),
                                        // trailing: Icons,
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: Text('No Data Found',
                                      style: TextStyle(
                                          fontFamily: AppFonts.medium)));
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: ButtonMixin().stylishButton(text: 'Done')),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Future selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    if (picked != null) {
      print("picked $picked");
      setState(
          () => dateController.text = DateFormat('dd/MM/yyyy').format(picked));
      print("dobController ${dateController.text}");
    }
  }

  selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        helpText: "Select Time",
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SizedBox(
              height: 520,
              child: Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: AppColor.appColor,
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.appColor,
                  ),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              ),
            ),
          );
        });
    if (picked != null) {
      String formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      timeController.text = formattedTime;
    }
  }

   validateTrainingAndDevelopment() {

    if (titleController.text.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please enter title');
    } else if (dateController.text.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please select date');
    }
    else if (timeController.text.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please select time');
    }
    else if (selectedEmployees.isEmpty) {
      AppUtils.instance.showToast(toastMessage: 'Please select at least one employee');
    }
    else {
      FirebaseFirestore.instance.collection("trainingAndDevelopments").add({
        "title": titleController.text,
        "description": descriptionController.text,
        "meetingUrl": meetingUrlController.text,
        "date": dateController.text,
        "time": timeController.text,
        "employees": jsonEncode(selectedEmployeeIds)
      }).then((value) {
        AppUtils.instance.showToast(toastMessage: 'Training and Development program added.');
        Navigator.pop(context, "added");
      });
    }
  }
}

class EmployeeModel {
  String? name;
  String? id;
}
