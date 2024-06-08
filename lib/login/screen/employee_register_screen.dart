/*
import 'dart:async';
import 'dart:io';
import 'package:employee_attendance_app/login/screen/login_screen.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../admin/employeeprofile/auth/add_employee_fire_auth.dart';
import '../../login/provider/loading_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_utils.dart';

class RegisterEmployeeScreen extends StatefulWidget with TextFieldMixin {
  RegisterEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<RegisterEmployeeScreen> createState() => _RegisterEmployeeScreenState();
}

class _RegisterEmployeeScreenState extends State<RegisterEmployeeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  MaskedTextController dobController = MaskedTextController(mask: '00/00/0000');
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  File? file;

  Future<File> imageSizeCompress(
      {required File image,
        quality = 100,
        percentage = 10}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 10);
    return path;
  }

  void _selectProfileImage(BuildContext context) async{
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await imageSizeCompress(image: File(filePath!));
    setState(() {
      // file = File(filePath!);
      file = compressImage;
    });
  }


  void uploadFile() async {
    //_selectProfileImage(context);
    //Store Image in firebase database
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser?.email;
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      UploadTask uploadsTask =  ref.putFile(file!);
      final snapshot = await uploadsTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL().whenComplete(() {});

      User? user = await AddEmployeeFireAuth.registerEmployeeUsingEmailPassword(
          employeeName: employeeNameController.text,
          email: emailController.text,
          password: passwordController.text,
          context: context
      );
      if (user != null) {
        AppUtils.instance.showToast(toastMessage: "Employee Added");
        AddEmployeeFireAuth().addEmployee(email: emailController.text,
            employeeName: employeeNameController.text,
            mobile: mobileController.text, dob: dobController.text,
            address: addressController.text,
            designation: '', department: '',
            branch: '', dateOfJoining: '',
            imageUrl: imageUrl,
            employmentType: '', exprience: '',
            manager: '', type: 'Employee');
        //FirebaseAuth.instance.signOut();
        Get.off(LoginScreen());
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      }
      debugPrint("Image URL = $imageUrl");
    } catch (e) {
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final ref1 = FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.uid}.png");
    //  url = ref1.getDownloadURL().toString();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40,),
                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                    fontFamily: AppFonts.Medium)
                  ),
                const SizedBox(height: 40,),
                GestureDetector(
                    onTap: (){
                      _selectProfileImage(context);
                      // uploadFile();
                    },
                    child: ClipOval(
                      child: file == null ? */
/*Image.network(
                          'https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill) :*//*

                      Container(
                          color: AppColor.appColor,
                          height: 80,width: 80,
                          child: const Icon(Icons.camera_alt,size: 50,color: AppColor.whiteColor,)) :
                      Image.file(
                        file!,
                        height: 100,width: 100,
                        fit: BoxFit.fill,),
                    )
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFieldMixin().textFieldWidget(
                      controller: employeeNameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.person, color: AppColor.appColor),
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                        labelText: 'Email',
                        validator: (value){
                          if (value!.isEmpty ||
                              value.trim().isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                              r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_android, color: AppColor.appColor),
                      labelText: 'Mobile',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                      controller: dobController,
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
                      controller: addressController,
                      prefixIcon:
                      const Icon(Icons.location_on, color: AppColor.appColor),
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
                      controller: passwordController,
                      prefixIcon:
                      const Icon(Icons.lock, color: AppColor.appColor),
                      labelText: 'Password',
                      validator: (value){
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Enter a valid password';
                        } else if (value.length < 8) {
                          return 'Password must be atLeast 8 characters';
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
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        if(file == null){
                          AppUtils.instance.showToast(toastMessage: 'Please choose the image');
                        }
                        if (formKey.currentState!.validate()) {
                          if(file != null) {
                            Provider.of<LoadingProvider>(context,listen: false).startLoading();
                            uploadFile();
                          }
                        }
                      },
                      child: ButtonMixin()
                          .stylishButton(onPress: () {}, text: 'Sign Up'),
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 25),
            child: const Text(
              'Already have an Account ',
              style: TextStyle(
                  decorationThickness: 2,
                  decoration: TextDecoration.none,
                  fontFamily: AppFonts.Medium,
                  color: AppColor.appBlackColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.off(LoginScreen());
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 25),
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 16,
                    decorationThickness: 1,
                    decoration: TextDecoration.underline,
                    fontFamily: AppFonts.Medium,
                    color: AppColor.appColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
