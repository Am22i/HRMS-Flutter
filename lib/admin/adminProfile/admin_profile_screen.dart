import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../login/provider/login_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';
import '../../widget/admin_bottom_navigationbar.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreen();
}

class _AdminProfileScreen extends State<AdminProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: StreamBuilder(
            stream: FirebaseCollection()
                .adminCollection
                .doc(FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                debugPrint('Something went wrong');
                return const Text(
                  "Something went wrong",
                  style: TextStyle(fontFamily: AppFonts.regular),
                );
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.requireData.exists) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Name',
                            controller: companyNameController
                              ..text = data['companyName'],
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z]')),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is Required';
                              }
                              if (value.trim().isEmpty) {
                                return "Please enter valid Name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Email',
                            controller: emailController..text = data['email'] ?? "",
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Mobile',
                            keyboardType: TextInputType.number,
                            controller: mobileController..text = data['mobile'],
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value!.length < 10) {
                                return 'Please enter valid Mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  AppUtils.instance.showToast(
                                      toastMessage:
                                          "Updated profile successfully.");
                                  Provider.of<LoginProvider>(context,
                                          listen: false)
                                      .signUpAdmin(
                                          email: emailController.text
                                              .toLowerCase()
                                              .toString(),
                                          companyName:
                                              companyNameController.text.trim(),
                                          mobile: mobileController.text.trim(),
                                          type: 'Admin');
                                  Get.back();
                                }
                              },
                              child: ButtonMixin().stylishButton(
                                  onPress: () {}, text: 'Update Profile'),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ],
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
            },
          ),
        ),
      ),
    );
  }
}
