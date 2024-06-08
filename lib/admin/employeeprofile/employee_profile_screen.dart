import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_collection.dart';
import '../../login/auth/login_employee_fire_auth.dart';
import '../../login/provider/loading_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_utils.dart';
import '../../widget/admin_bottom_navigationbar.dart';

//ignore: must_be_immutable
class ViewAdminEmployeeProfileScreen extends StatefulWidget
    with TextFieldMixin {
  ViewAdminEmployeeProfileScreen({Key? key, required this.email})
      : super(key: key);
  String email;

  @override
  State<ViewAdminEmployeeProfileScreen> createState() =>
      _ViewAdminEmployeeProfileScreen();
}

class _ViewAdminEmployeeProfileScreen
    extends State<ViewAdminEmployeeProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  MaskedTextController dobController = MaskedTextController(mask: '00/00/0000');
  TextEditingController mobileController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  MaskedTextController dateOfJoinController =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController exprienceGradeController = TextEditingController();
  TextEditingController managerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Employee Information',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: StreamBuilder(
            stream: FirebaseCollection()
                .employeeCollection
                .doc(widget.email)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                debugPrint('Something went wrong');
                return const Center(
                    child: Text(
                  "Something went wrong",
                  style: TextStyle(fontFamily: AppFonts.regular),
                ));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: CircularProgressIndicator());
              } else {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ClipOval(
                          child: data['imageUrl'] == ""
                              ? Container(
                                  color: AppColor.appColor,
                                  height: 80,
                                  width: 80,
                                  child: Center(
                                    child: Text(
                                        '${data['employeeName']?.substring(0, 1).toUpperCase()}',
                                        style: const TextStyle(
                                            color: AppColor.appBlackColor,
                                            fontSize: 30,
                                            fontFamily: AppFonts.medium)),
                                  ),
                                )
                              : Image.network('${data['imageUrl']}',
                                  height: 100, width: 100, fit: BoxFit.fill)),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            TextFieldMixin().textFieldWidget(
                              controller: employeeNameController..text = data['employeeName'],
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              prefixIcon: const Icon(Icons.person,
                                  color: AppColor.appColor),
                              labelText: 'Employee Name',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter employee name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: emailController
                                  ..text = data['email'],
                                readOnly: true,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email,
                                    color: AppColor.appColor),
                                labelText: 'Email',
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.trim().isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: mobileController
                                ..text = data['mobile'],
                              readOnly: true,
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(Icons.phone_android,
                                  color: AppColor.appColor),
                              labelText: 'Mobile',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter mobile number';
                                } else if (value.length < 10) {
                                  return "Please enter valid mobile number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: dobController..text = data['dob'],
                              readOnly: true,
                              keyboardType: TextInputType.datetime,
                              prefixIcon: const Icon(Icons.date_range_outlined,
                                  color: AppColor.appColor),
                              labelText: 'Date of Birth',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter date of birth';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: addressController
                                ..text = data['address'],
                              readOnly: true,
                              prefixIcon: const Icon(Icons.location_on,
                                  color: AppColor.appColor),
                              labelText: 'Address',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: designationController
                                ..text = data['designation'],
                              keyboardType: TextInputType.text,
                              prefixIcon: const Icon(Icons.post_add,
                                  color: AppColor.appColor),
                              labelText: 'Designation',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter designation';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: departmentController
                                ..text = data['department'],
                              keyboardType: TextInputType.text,
                              prefixIcon: const Icon(Icons.description,
                                  color: AppColor.appColor),
                              labelText: 'Department',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter department';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: branchNameController
                                ..text = data['branch'],
                              keyboardType: TextInputType.text,
                              prefixIcon: const Icon(Icons.person,
                                  color: AppColor.appColor),
                              labelText: 'Branch',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter branch';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: dateOfJoinController
                                ..text = data['dateofjoining'],
                              keyboardType: TextInputType.datetime,
                              prefixIcon: const Icon(Icons.date_range_outlined,
                                  color: AppColor.appColor),
                              labelText: 'Date of Joining',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter joining date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: employmentTypeController
                                  ..text = data['employment_type'],
                                keyboardType: TextInputType.text,
                                prefixIcon: const Icon(Icons.person,
                                    color: AppColor.appColor),
                                labelText: 'Employment Type',
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().isEmpty) {
                                    return 'Please enter employment type';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: exprienceGradeController
                                ..text = data['exprience'],
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.timeline_sharp,
                                  color: AppColor.appColor),
                              labelText: 'Exprience',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter exprience year';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                              controller: managerController
                                ..text = data['manager'],
                              keyboardType: TextInputType.text,
                              prefixIcon: const Icon(Icons.man,
                                  color: AppColor.appColor),
                              labelText: 'Manager',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter manager name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              Provider.of<LoadingProvider>(context,
                                      listen: false)
                                  .startLoading();
                              Timer(const Duration(seconds: 5), () {
                                AppUtils.instance.showToast(
                                    toastMessage: "Employee Updated");
                                AddEmployeeFireAuth().addEmployee(
                                    email: data['email'],
                                    employeeName: data['employeeName'],
                                    mobile: data['mobile'],
                                    dob: data['dob'],
                                    address: data['address'],
                                    designation: designationController.text,
                                    department: departmentController.text,
                                    branch: branchNameController.text,
                                    dateOfJoining: dateOfJoinController.text,
                                    imageUrl: data['imageUrl'],
                                    employmentType:
                                        employmentTypeController.text,
                                    exprience: exprienceGradeController.text,
                                    manager: managerController.text,
                                    type: 'Employee');
                                Get.off(const AdminBottomNavBarScreen());
                                Provider.of<LoadingProvider>(context,
                                        listen: false)
                                    .stopLoading();
                              });
                              //FirebaseAuth.instance.signOut();
                            }
                          },
                          child: ButtonMixin()
                              .stylishButton(onPress: () {}, text: 'Update'),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
