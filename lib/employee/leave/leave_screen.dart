import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_attendance_app/employee/leave/auth/leave_fire_auth.dart';
import 'package:employee_attendance_app/employee/leave/provider/leave_provider.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_colors.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  @override
  void initState() {
    Provider.of<LeaveProvider>(context, listen: false).onWillPop(context);
    leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    leaveTypeController.clear();
    hourController.clear();
    reasonController.clear();
    daysController.clear();
    super.initState();
  }

  @override
  void dispose() {
    leaveTypeController.dispose();
    hourController.dispose();
    reasonController.dispose();
    daysController.dispose();
    super.dispose();
  }

  TextEditingController leaveTypeController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  late LeaveProvider leaveProvider;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  TextEditingController leaveFromDate = TextEditingController();
  TimeOfDay? pickedTime;
  bool fromDateValidation = false;
  bool toDateValidation = false;

  DateTime? pickedFrom, pickedTo;
  Future<void> selectFromDate(BuildContext context) async {
    leaveFromDate.clear();
    pickedFrom = await showDatePicker(
        context: context,
        initialDate: Provider.of<LeaveProvider>(context, listen: false).leaveFromDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (!mounted) return;
    if (pickedFrom != null && pickedFrom != Provider.of<LeaveProvider>(context, listen: false).leaveFromDate) {
      Provider.of<LeaveProvider>(context, listen: false).countValueGet();
      Provider.of<LeaveProvider>(context, listen: false).leaveFromDate = pickedFrom ?? DateTime.now();
      print(
          "PICKEDFORM $pickedFrom leaveFromDate ${leaveProvider.leaveFromDate}");
      if (leaveProvider.selectLeaveType == "Flexi Leave") {
        setState(() {
          leaveProvider.leaveToDate = pickedFrom ?? DateTime.now();
          pickedTo = pickedFrom;
        });
        print(
            "PICKEDFORM_Flexi $pickedFrom leaveToDate ${leaveProvider.leaveToDate}");
      }
      if (Provider.of<LeaveProvider>(context, listen: false).countLeave < 0) {
        pickedTo = null;
      }
    }
    setState(() {});
  }

  Future<void> selectToDate(BuildContext context) async {
    pickedTo = await showDatePicker(
      context: context,
      initialDate:
          Provider.of<LeaveProvider>(context, listen: false).leaveFromDate,
      firstDate: pickedFrom ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (!mounted) return;
    if (pickedTo != null &&
        pickedTo != Provider.of<LeaveProvider>(context, listen: false).leaveToDate) {
      Provider.of<LeaveProvider>(context, listen: false).leaveToDate = pickedTo ?? DateTime.now();
      Provider.of<LeaveProvider>(context, listen: false).countValueGet();
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Apply Leave',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: StreamBuilder(
              stream: FirebaseCollection()
                  .employeeCollection
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                if (!snapshot.hasData ||
                    !snapshot.data!.exists ||
                    snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.requireData.exists) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Consumer<LeaveProvider>(
                    builder: (BuildContext context, snapshot, Widget? child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButtonFormField2<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  padding: const EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  maxHeight: 200,
                                  useSafeArea: true,
                                  isOverButton: false,
                                  offset: const Offset(0, -15)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              value: snapshot.selectLeaveType,
                              validator: (value) {
                                if (value == null) {
                                  return '   Leave type is required';
                                }
                                return null;
                              },
                              hint: const Text('Select Leave Type',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium)),
                              isExpanded: true,
                              isDense: true,
                              // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                              // buttonHeight: 50,
                              style: const TextStyle(
                                  color: AppColor.appBlackColor,
                                  fontSize: 14,
                                  fontFamily: AppFonts.medium),

                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down),
                              ),
                              onChanged: (String? newValue) {
                                snapshot.selectLeaveType = newValue!;
                                snapshot.getLeaveType;
                                // leaveTypeController.clear();
                                // reasonController.clear();
                                // hourController.clear();
                                // daysController.clear();
                                // pickedFrom = null;
                                // pickedTo = null;
                                // daysController.clear();
                                if (snapshot.selectLeaveType == 'Flexi Leave') {
                                  pickedTo = null;
                                  pickedFrom = null;
                                  leaveProvider.leaveFromDate = pickedTo ?? DateTime.now();
                                  leaveProvider.leaveToDate = pickedTo?? DateTime.now();
                                  reasonController.clear();
                                  snapshot.countHour = 0;
                                  setState(() {});
                                }
                                if (snapshot.selectLeaveType != 'Flexi Leave') {
                                  pickedTime = null;
                                  hourController.clear();
                                  snapshot.countHour = 0;
                                  // toHourController.clear();
                                  reasonController.clear();
                                  setState(() {});
                                }
                              },
                              items: snapshot.selectLeaveTypeItem
                                  .map<DropdownMenuItem<String>>(
                                      (String leaveName) {
                                return DropdownMenuItem<String>(
                                    value: leaveName,
                                    alignment: AlignmentDirectional.topCenter,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            AppImage.leaveIcon,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        Text(leaveName)
                                      ],
                                    ));
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 5),
                              child: const Text('Leave From Date',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium))),
                          GestureDetector(
                            onTap: () {
                              selectFromDate(context);
                              debugPrint(snapshot.countLeave.toString());
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: fromDateValidation == true
                                          ? AppColor.redColor
                                          : AppColor.darkGreyColor),
                                  borderRadius: BorderRadius.circular(5)),
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.date_range_outlined,
                                            color: AppColor.appColor),
                                        const SizedBox(width: 10),
                                        Text(
                                            pickedFrom == null
                                                ? "Please select date"
                                                : DateFormat('dd-MM-yyyy')
                                                    .format(
                                                        snapshot.leaveFromDate),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppFonts.medium)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Visibility(
                              visible:
                                  fromDateValidation == false ? false : true,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'Please choose date',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.redColor,
                                      fontFamily: AppFonts.regular),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 5),
                              child: const Text('Leave To Date',
                                  style:
                                      TextStyle(fontFamily: AppFonts.regular))),
                          GestureDetector(
                            onTap: () {
                              leaveProvider.selectLeaveType == "Flexi Leave"
                                  ? null
                                  : selectToDate(context);
                              snapshot.getFromLeave();
                              debugPrint(snapshot.countLeave.toString());
                              debugPrint(pickedFrom.toString());
                              debugPrint(snapshot.leaveFromDate.toString());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: fromDateValidation == true
                                          ? AppColor.redColor
                                          : AppColor.darkGreyColor),
                                  borderRadius: BorderRadius.circular(5)),
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range_outlined,
                                          color: AppColor.appColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                            pickedTo == null
                                                ? "Please select date"
                                                : DateFormat('dd-MM-yyyy')
                                                    .format(snapshot.leaveToDate),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppFonts.medium)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Visibility(
                              visible: toDateValidation == false ? false : true,
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    'Please choose date',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.redColor,
                                        fontFamily: AppFonts.medium),
                                  ))),
                          Visibility(
                            visible: snapshot.selectLeaveType != 'Flexi Leave'
                                ? true
                                : false,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(left: 25, bottom: 5, top: 10),
                              child: Text('No of days',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium)),
                            ),
                          ),
                          Visibility(
                            visible: snapshot.selectLeaveType != 'Flexi Leave'
                                ? true
                                : false,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                cursorColor: AppColor.appColor,
                                keyboardType: TextInputType.number,
                                controller: daysController
                                  ..text =
                                      '${pickedTo == null ? '0' : pickedFrom == null || pickedTo == null ? snapshot.countLeave : snapshot.countLeave + 1}',
                                readOnly: true,
                                style: const TextStyle(
                                    fontFamily: AppFonts.medium),
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter hours';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave'
                                ? true
                                : false,
                            child: TimeRange(
                              fromTitle: const Text('From Time',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium)),
                              toTitle: const Text('To Time',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium)),
                              titlePadding: 20,
                              activeTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.medium),
                              backgroundColor: Colors.transparent,
                              borderColor: AppColor.appColor,
                              activeBorderColor: AppColor.appColor,
                              textStyle:
                                  const TextStyle(fontFamily: AppFonts.medium),
                              activeBackgroundColor: AppColor.appColor,
                              firstTime: const TimeOfDay(hour: 09, minute: 30),
                              lastTime: const TimeOfDay(hour: 19, minute: 00),
                              timeStep: 30,
                              timeBlock: 60,
                              onRangeCompleted: (range) {
                                setState(() {
                                  snapshot.countHour =
                                      range!.end.hour - range.start.hour;
                                  snapshot.fromTime = range.start.toString();
                                  snapshot.toTime = range.end.toString();
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave'
                                ? true
                                : false,
                            child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 25, bottom: 5, top: 10),
                                child: Text('No of hours',
                                    style: TextStyle(
                                        fontFamily: AppFonts.medium))),
                          ),
                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave'
                                ? true
                                : false,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                cursorColor: AppColor.appColor,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                style: const TextStyle(
                                    fontFamily: AppFonts.medium),
                                controller: hourController
                                  ..text = snapshot.countHour.toString(),
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter hours';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 25, bottom: 5, top: 10),
                              child: const Text('Reason',
                                  style:
                                      TextStyle(fontFamily: AppFonts.medium))),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Scrollbar(
                              child: TextFormField(
                                cursorColor: AppColor.appColor,
                                scrollController: scrollController,
                                maxLines: 3,
                                style: const TextStyle(
                                    fontFamily: AppFonts.medium),
                                keyboardType: TextInputType.multiline,
                                controller: reasonController,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColor.appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter reason';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  fromDateValidation = true;
                                  toDateValidation = true;
                                });
                                if (pickedFrom != null) {
                                  setState(() {
                                    fromDateValidation = false;
                                  });
                                }
                                if (pickedTo != null) {
                                  setState(() {
                                    toDateValidation = false;
                                  });
                                }
                                if (_formKey.currentState!.validate() &&
                                    pickedTo != null &&
                                    pickedFrom != null) {
                                  LeaveFireAuth().applyLeaveUser(
                                    context: context,
                                      leaveFrom: snapshot.leaveFromDate.toString().substring(0, 10),
                                      leaveTo: snapshot.selectLeaveType == 'Flexi Leave' ? '' : snapshot.leaveToDate.toString().substring(0, 10),
                                      leaveDays: snapshot.selectLeaveType == 'Flexi Leave' ? '' : daysController.text.toString(),
                                      leaveType: snapshot.selectLeaveType!,
                                      leaveReason: reasonController.text,
                                      leaveStatus: 'Pending',
                                      leaveEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                                      leaveFromTime: snapshot.selectLeaveType == 'Flexi Leave' ? snapshot.fromTime.toString().substring(10, 15) : '',
                                      leaveToTime: snapshot.selectLeaveType == 'Flexi Leave' ? snapshot.toTime.toString().substring(10, 15) : '',
                                      leaveHours: snapshot.selectLeaveType == 'Flexi Leave' ? hourController.text : '',
                                      leaveEmployeeName: '${data['employeeName']?.toString().capitalizeFirst}').then((_) {
                                    leaveTypeController.clear();
                                    reasonController.clear();
                                    hourController.clear();
                                    daysController.clear();
                                    pickedFrom = null;
                                    pickedTo = null;
                                    snapshot.countHour = 0;
                                    daysController.clear();
                                    snapshot.fromTime = '';
                                    snapshot.toTime = '';
                                    setState(() {});
                                  });
                                }
                              },
                              child: ButtonMixin().stylishButton(
                                  onPress: () {}, text: 'Apply Leave'),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      );
                    },
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
