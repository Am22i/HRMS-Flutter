import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../login/auth/login_employee_fire_auth.dart';
import '../../login/provider/loading_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_utils.dart';
import '../../widget/admin_bottom_navigationbar.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController dateOfJoinController = TextEditingController();
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController exprienceGradeController = TextEditingController();
  TextEditingController managerController = TextEditingController();
  File? file;
  bool passwordVisibility = false;
  String? _employmentType;
  final List<String> employmentTypes = ['Probation', 'Permanent'];

  Future<File> imageSizeCompress({
    required File image,
  }) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,
        quality: 100, percentage: 50);
    return path;
  }

  void selectProfileImage(BuildContext context) async {
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await imageSizeCompress(image: File(filePath!));
    setState(() {
      // file = File(filePath!);
      file = compressImage;
    });
  }

  void uploadFile() async {
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser?.email;
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      UploadTask uploadsTask = ref.putFile(file!);
      final snapshot = await uploadsTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL().whenComplete(() {});
      if (!mounted) return;
      User? user = await AddEmployeeFireAuth.registerEmployeeUsingEmailPassword(
          employeeName: employeeNameController.text,
          emailID: emailController.text,
          password: passwordController.text,
          context: context);
      if (user != null) {
        AppUtils.instance.showToast(toastMessage: "Employee Added");
        AddEmployeeFireAuth()
            .addEmployee(
                email: emailController.text.toLowerCase().trim(),
                employeeName: employeeNameController.text.trim(),
                mobile: mobileController.text.trim(),
                dob: dobController.text.trim(),
                address: addressController.text.trim(),
                designation: designationController.text.trim(),
                department: departmentController.text.trim(),
                branch: branchNameController.text.trim(),
                dateOfJoining: dateOfJoinController.text.trim(),
                imageUrl: imageUrl,
                employmentType: _employmentType!.trim(),
                exprience: exprienceGradeController.text.trim(),
                manager: managerController.text.trim(),
                type: 'Employee')
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminBottomNavBarScreen()),
              (route) => false);
          // Get.off(AdminBottomNavBarScreen());
          send();
        });
        //FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Provider.of<LoadingProvider>(context, listen: false).stopLoading();
      }
      debugPrint("Image URL = $imageUrl");
    } catch (e) {
      debugPrint('Failed to upload image');
    }
  }

  Future<void> send() async {
    debugPrint("send mail on this id :- ${emailController.text}");
    final Email email = Email(
      body:
          'Please find the HRMS credentials below,\n\n To Start HRMS,\n Login ID-${emailController.text} \n Password- ${passwordController.text}',
      subject: 'HRMS Credentials..!!',
      recipients: [emailController.text],
    );
    try {
      await FlutterEmailSender.send(email);
      debugPrint("send method run successfully !!");
    } catch (error) {
      debugPrint("send method $error");
    }
  }

  Future selectDateForDOB() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1500),
        lastDate: DateTime.now());
    if (picked != null) {
      print("pickeddd $picked");
      setState(
          () => {dobController.text = DateFormat('dd/MM/yyyy').format(picked)});
      print("dobController ${dobController.text}");
    }
  }

  Future selectDateForDOJ() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1500),
        lastDate: DateTime.now());
    if (picked != null) {
      print("pickeddd $picked");
      setState(() => {
            dateOfJoinController.text = DateFormat('dd/MM/yyyy').format(picked)
          });
      print("dateOfJoinController ${dateOfJoinController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final ref1 = FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.uid}.png");
    //  url = ref1.getDownloadURL().toString();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Add Employee',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                /*const Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: AppFonts.Medium)
                ),
                const SizedBox(height: 40,),*/
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                        onTap: () {
                          selectProfileImage(context);
                          // uploadFile();
                        },
                        child: ClipOval(
                          child: file == null
                              ? /*Image.network(
                          'https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill) :*/
                              Container(
                                  color: AppColor.appColor,
                                  height: 80,
                                  width: 80,
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    size: 50,
                                    color: AppColor.whiteColor,
                                  ))
                              : Image.file(
                                  file!,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.fill,
                                ),
                        )),
                    Positioned(
                      left: 50,
                      top: 40,
                      child: GestureDetector(
                        onTap: () {
                          selectProfileImage(context);
                        },
                        child: ClipOval(
                            child: Container(
                          height: 40,
                          width: 40,
                          color: AppColor.whiteColor,
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColor.appColor,
                          ),
                        )),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 40),
                    TextFieldMixin().textFieldWidget(
                      controller: employeeNameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.person_outline_rounded,
                          color: AppColor.appColor),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      labelText: 'Employee Name',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColor.appColor),
                        labelText: 'Email',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the employee email';
                          } else if (!RegExp(
                                  r'^(?:[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
                                  caseSensitive: false)
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_iphone_rounded,
                          color: AppColor.appColor),
                      labelText: 'Mobile',
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee mobile number';
                        } else if (value.length < 10) {
                          return "please enter 10-digit mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: dobController,
                      prefixIcon: const Icon(Icons.date_range_outlined,
                          color: AppColor.appColor),
                      onTap: () {
                        selectDateForDOB();
                        // FocusScope.of(context).requestFocus(FocusNode());
                      },
                      labelText: 'Date of Birth',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee birth date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: addressController,
                      prefixIcon: const Icon(Icons.location_on_outlined,
                          color: AppColor.appColor),
                      labelText: 'Address',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: designationController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      prefixIcon: const Icon(Icons.account_box,
                          color: AppColor.appColor),
                      labelText: 'Designation',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee designation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: departmentController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.description_outlined,
                          color: AppColor.appColor),
                      labelText: 'Department',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee department';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: branchNameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.account_balance_outlined,
                          color: AppColor.appColor),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      labelText: 'Branch',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee branch';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: dateOfJoinController,
                      onTap: () {
                        selectDateForDOJ();
                        // FocusScope.of(context).requestFocus(FocusNode());
                      },
                      prefixIcon: const Icon(Icons.date_range_outlined,
                          color: AppColor.appColor),
                      labelText: 'Joining Date',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter the employee joining date';
                        }
                        return null;
                      },
                    ),
                    /*DropdownButton2(
                      value: _employmentType,
                      dropdownMaxHeight: 200,
                      selectedItemHighlightColor: AppColor.backgroundColor,
                      isDense: true,
                      style: const TextStyle(
                          color: AppColor.appBlackColor,
                          fontSize: 14,
                          fontFamily: AppFonts.medium),
                      iconOnClick: const Icon(Icons.arrow_drop_up),
                      icon: const Icon(Icons.arrow_drop_down),
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 3,
                      scrollbarAlwaysShow: true,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (value) =>
                          setState(() {
                            print("changes $value");
                          }),
                      items: const [
                        DropdownMenuItem(
                          child: Text('Probation'),
                          value: 'Probation',
                        ),
                        DropdownMenuItem(
                          child: Text('Permanent'),
                          value: 'Permanent',
                        ),
                      ],
                    ),*/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 00),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_pin_outlined,
                                color: AppColor.appColor),
                            contentPadding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                            labelText: 'Employment Type',
                            labelStyle: TextStyle(
                                fontFamily: AppFonts.regular,
                                fontSize: 14,
                                color: AppColor.appColor)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an employment type';
                          }
                          return null;
                        },
                        value: _employmentType,
                        onChanged: (value) {
                          setState(() {
                            _employmentType = value;
                          });
                          print("EMployee_Type $_employmentType");
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Probation',
                            child: Text('Probation'),
                          ),
                          DropdownMenuItem(
                            value: 'Permanent',
                            child: Text('Permanent'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: exprienceGradeController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.timeline_sharp,
                          color: AppColor.appColor),
                      labelText: 'Experience',
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Please enter the employee experience';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: managerController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.personal_injury_outlined,
                          color: AppColor.appColor),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      labelText: 'Manager',
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Please enter the employee manager';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: passwordController,
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColor.appColor),
                      labelText: 'Password',
                      obscureText: passwordVisibility ? false : true,
                      suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                          icon: passwordVisibility
                              ? const Icon(
                                  Icons.visibility,
                                  color: AppColor.appColor,
                                )
                              : const Icon(Icons.visibility_off,
                                  color: AppColor.appColor)),
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Please enter the password';
                        } else if (value.length < 8) {
                          return 'Password must be atLeast 8 characters';
                        } else if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        if (file == null) {
                          AppUtils.instance.showToast(
                              toastMessage: 'Please choose employee image');
                        }
                        if (formKey.currentState!.validate()) {
                          if (file != null) {
                            Provider.of<LoadingProvider>(context, listen: false)
                                .startLoading();
                            uploadFile();
                          }
                        }
                      },
                      child: ButtonMixin()
                          .stylishButton(onPress: () {}, text: 'Add Employee'),
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
