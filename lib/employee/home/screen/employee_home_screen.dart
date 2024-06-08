import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/grievances/employee_grievances.dart';
import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/employee/reports/employee_reports_screen.dart';
import 'package:employee_attendance_app/employee/trainingAndDevelopment/view_employee_training_and_development.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../attendance_details/attendance_details_screen.dart';
import '../../inOut/screen/employee_in_out_screen.dart';
import '../../leave/leave_screen.dart';
import '../../leave/leave_status_applied.dart';
import '../../publicholiday/screen/public_holiday_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  DateTime now = DateTime.now();
  var hour = DateTime.now().hour;
  final ScrollController controller = ScrollController();

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);
    final getEmployeeData = FirebaseCollection()
        .employeeCollection
        .doc(FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    String employeeId = FirebaseCollection()
        .employeeCollection
        .doc(FirebaseAuth.instance.currentUser!.email)
        .id;
    setPrefsEmployeeId(employeeId);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.appColor, AppColor.whiteColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: getEmployeeData,
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong",
                                style: TextStyle(fontFamily: AppFonts.medium));
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return const Text('');
                          } else if (snapshot.requireData.exists) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                    child: data['imageUrl'] == ""
                                        ? Container(
                                            color: AppColor.backgroundColor,
                                            height: 80,
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                '${data['employeeName']?.substring(0, 1).toUpperCase()}',
                                                style: const TextStyle(
                                                    color:
                                                        AppColor.appBlackColor,
                                                    fontSize: 30,
                                                    fontFamily:
                                                        AppFonts.medium),
                                              ),
                                            ),
                                          )
                                        : Image.network('${data['imageUrl']}',
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover)),
                                const SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, ${capitalizeAllWord(data['employeeName'])}',
                                      style: const TextStyle(
                                          fontFamily: AppFonts.medium,
                                          color: AppColor.backgroundColor),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                        hour < 12
                                            ? 'Good Morning'
                                            : hour < 17
                                                ? 'Good Afternoon'
                                                : 'Good Evening',
                                        style: const TextStyle(
                                            fontFamily: AppFonts.bold,
                                            fontSize: 24,
                                            color: AppColor.whiteColor)),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(60),
                            topLeft: Radius.circular(60))),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                    date
                                        .toString()
                                        .replaceAll("00:00:00.000", ""),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: AppColor.greyColorLight,
                                        fontFamily: AppFonts.medium))),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(PublicHolidayScreen(),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/3634/3634857.png',
                                        'Public Holiday',
                                        'Check allocated public holiday',
                                        Colors.pink.withOpacity(0.4)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const EmployeeInOutScreen(),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/4158/4158668.png',
                                        'Entry Exit',
                                        'Fill the attendance today is present or not',
                                        Colors.deepOrangeAccent
                                            .withOpacity(0.4)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          AttendanceDetailsScreen(
                                            passType: 'Employee',
                                            email: '',
                                          ),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/1286/1286827.png',
                                        'Attendance Details',
                                        'Check your entry exit time details',
                                        Colors.lightGreen.withOpacity(0.4)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const LeaveScreen(),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/3387/3387310.png',
                                        'Apply Leave',
                                        'Applying for a leave',
                                        Colors.blue.withOpacity(0.4)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const LeaveStatusApplied(),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/198/198141.png',
                                        'Leave Status',
                                        'Check your entry exit time details',
                                        Colors.yellow.withOpacity(0.4)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const ReportScreen(),
                                          transition:
                                              Transition.rightToLeftWithFade);
                                    },
                                    child: dashboardDetailsWidget(
                                        'https://cdn-icons-png.flaticon.com/512/1690/1690427.png',
                                        'Reports',
                                        'Check your reports month wise',
                                        Colors.purple.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                      const ViewEmployeeTrainingAndDevelopment(),
                                      transition:
                                          Transition.rightToLeftWithFade);
                                },
                                child: Card(
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      // height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.25),
                                            Colors.blueGrey.withOpacity(0.25),
                                          ],
                                          begin:
                                              const FractionalOffset(0.1, 0.5),
                                          end: const FractionalOffset(0.1, 3.0),
                                          stops: const [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Image.asset(
                                                  AppImage
                                                      .trainingAndDevelopment,
                                                  height: 55,
                                                  width: 55,
                                                  fit: BoxFit.contain,
                                                  color: AppColor.appColor,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 20,
                                                ),
                                                child: Text(
                                                    'Training and Development',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            AppFonts.medium),
                                                    textAlign: TextAlign.start),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: SizedBox(
                                                  width: 260,
                                                  child: Text(
                                                      'List of trainings and development programs by company',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              AppFonts.medium),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(EmployeeGrievances(),
                                      transition:
                                          Transition.rightToLeftWithFade);
                                },
                                child: Card(
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      // height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.green.withOpacity(0.25),
                                            AppColor.appColor.withOpacity(0.4),
                                          ],
                                          begin:
                                              const FractionalOffset(0.1, 0.5),
                                          end: const FractionalOffset(0.1, 3.0),
                                          stops: const [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Image.asset(
                                                  AppImage.grievance,
                                                  height: 55,
                                                  width: 55,
                                                  fit: BoxFit.contain,
                                                  color: AppColor.appColor,
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 20,
                                                ),
                                                child: Text('Grievance',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            AppFonts.medium),
                                                    textAlign: TextAlign.start),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'List of grievances filed by employees',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              AppFonts.medium),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ))),
              ),
            ],
          ),
          // endDrawer: const EmployeeDrawerScreen(),
        ),
      ),
    );
  }

  void setPrefsEmployeeId(String employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("employeeId", employeeId);
  }
}
