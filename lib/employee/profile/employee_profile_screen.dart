import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/employeeprofile/auth/add_employee_fire_auth.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  MaskedTextController dateOfJoinController = MaskedTextController(mask: '00/00/0000');
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController exprienceGradeController = TextEditingController();
  TextEditingController managerController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dobSetKey = '';
  String dobGetKey = '';
  String nameSetKey = '';
  String nameGetKey = '';
  String mobileNumberSetKey = '';
  String mobileNumberGetKey = '';
  String addressSetKey = '';
  String addressGetKey = '';
  bool isUpdating =false;
  update({required String dobDate,required String userName,required String mobileNumber,required String address}) async {
    if(dobGetKey.isNotEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /// dobDate
    prefs.setString(dobSetKey, dobDate);
    dobGetKey = prefs.getString(dobSetKey) ?? '';
    /// name
    prefs.setString(nameSetKey, userName);
    nameGetKey = prefs.getString(nameSetKey) ?? '';
    /// mobileNumber
    prefs.setString(mobileNumberSetKey, mobileNumber);
    mobileNumberGetKey = prefs.getString(mobileNumberSetKey) ?? '';
    /// address
    prefs.setString(addressSetKey, address);
    addressGetKey = prefs.getString(addressSetKey) ?? '';
    /// SET TEXT_EDITING_CONTROLLER ///
    dobController = TextEditingController(text: dobGetKey);
    employeeNameController = TextEditingController(text: nameGetKey);
    mobileController = TextEditingController(text: mobileNumberGetKey);
    addressController = TextEditingController(text: addressGetKey);
    setState(() {});
  }
  File? file;
  var url = '';
  DateTime? datePicked;
  final formKey = GlobalKey<FormState>();
  Future<File> imageSizeCompress(
      {required File image,}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 50);
    return path;
  }
  void selectProfileImage(BuildContext context) async{
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
    print("PICKEDPICTURE $file");
  }
  Future<bool> uploadFile() async {
    //_selectProfileImage(context);
    //Store Image in firebase database
    if (file == null) return false;
    final fireauth = FirebaseAuth.instance.currentUser!.email;
    print("emailAuth $fireauth");
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(file!);
      // var dowurl = await (await ref.putFile(file!).whenComplete(() => ref.getDownloadURL()));
      debugPrint("Image Upload Got >>> $ref");

      //  final ref1 =
      //  FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
      final url1 = (await ref.getDownloadURL()).toString();
      setState((){
        url = url1;
      });
      debugPrint("URLLLLLLLL $url");
return true;
    } catch (e) {
      debugPrint('error occurred');
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: const Text('Edit Profile',style: TextStyle(fontFamily: AppFonts.bold),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: StreamBuilder(
              stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                if (snapshot.hasError) {
                  debugPrint('Something went wrong');
                  return const Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.regular),);
                }
                else if (!snapshot.hasData || !snapshot.data!.exists) {
                  debugPrint('Document does not exist');
                  return const Center(child: CircularProgressIndicator());
                } else if(snapshot.requireData.exists){
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  update(dobDate: data['dob'],address: data['address'],mobileNumber:  data['mobile'],userName: data['employeeName'] );
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        clipBehavior: Clip.none,
                        children : [
                        GestureDetector(
                          onTap: (){
                            selectProfileImage(context);
                          },
                          child: ClipOval(
                              child: file == null ?
                              data['imageUrl'] == "" ? Container(
                                color: AppColor.appColor,
                                height: 100,width: 100,child: Center(
                                child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                  style: const TextStyle(color: Colors.white,fontSize: 40,fontFamily: AppFonts.regular)),
                              ),) :
                              Image.network(
                                  '${data['imageUrl']}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover) :
                                  Image.file(
                                    file!,
                                    height: 100,width: 100,
                                    fit: BoxFit.cover,),
                          ),
                        ),
                          Positioned(
                            left: 70,
                            top: 60,
                            child: GestureDetector(
                              onTap: (){
                                selectProfileImage(context);
                              },
                              child: ClipOval(child: Container(
                                height: 40,width: 40,
                                color:AppColor.whiteColor,child: const Icon(Icons.camera_alt,color: AppColor.appColor,),)),
                            ),
                          )
                        ]
                      ),

                      Container(
                        margin: const EdgeInsets.only(top:5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),

                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Name',
                              controller: employeeNameController,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),],
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Name is Required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Email',
                              controller: emailController..text = data['email'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'DOB',
                              readOnly: true,
                              controller: dobController,
                              validator: (val) {
                                if(val!.isEmpty){
                                  return "Please Pick DOB";
                                }
                                return null;
                              },
                              onTap: () async {
                                datePicked = null;
                                datePicked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now(),
                                );
                                if (datePicked != null) {
                                  setState(() {
                                    dobController.text = DateFormat('dd/MM/yyyy').format(datePicked!);
                                    dobController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(datePicked!));
                                  });
                                  print("DOBController :- $dobController");
                                  print("DOBController :- $datePicked");
                                } else {
                                  setState(() {
                                    dobController.text = data['dob'];
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Mobile',
                              inputFormatters: [LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.phone,
                              controller: mobileController,
                              validator: (value){
                                if(value!.length < 10){
                                  return 'Please enter valid Mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Address',
                              controller: addressController,
                              keyboardType: TextInputType.text,
                              validator: (val) {
                                if(val!.isEmpty){
                                  return "Please add address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Designation',
                              controller: designationController..text = data['designation'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Department',
                              controller: departmentController..text = data['department'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Branch',
                              controller: branchNameController..text = data['branch'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Joining Date',
                              controller: dateOfJoinController..text = data['dateofjoining'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Employment Type',
                              controller: employmentTypeController..text = data['employment_type'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Experience',
                              controller: exprienceGradeController..text = data['exprience'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Manager',
                              controller: managerController..text = data['manager'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  // if(url == ''){
                                  //   var querySnapshots = await FirebaseCollection().employeeCollection.doc('${data['email']}').get();
                                  //   // for (var snapshot in querySnapshots.docChanges) {
                                  //   //   url = snapshot.doc.get("imageUrl");
                                  //   setState(() {
                                  //     url = querySnapshots['imageUrl'];
                                  //   });
                                  //   print("onTap Url :- $url");
                                  //   // }
                                  // }
                                  if(formKey.currentState!.validate() ) {
                                    setState(() {
                                      isUpdating =true;
                                    });
                                    // if(url != ''){
                                    uploadFile().then((value) {
                                      if(value ==true){
                                        AppUtils.instance.showToast(toastMessage: "Updated profile successfully.");
                                        AddEmployeeFireAuth().addEmployee(
                                            email: emailController.text.toLowerCase().trim(), employeeName: employeeNameController.text.trim(),
                                            mobile: mobileController.text.trim(), dob: dobController.text.trim(),
                                            address: addressController.text.trim(), designation: designationController.text.trim(), department: departmentController.text.trim(),
                                            branch: branchNameController.text.trim(), dateOfJoining: dateOfJoinController.text.trim(),
                                            imageUrl:url,
                                            employmentType: employmentTypeController.text.trim(), exprience: exprienceGradeController.text.trim(),
                                            manager: managerController.text.trim(), type: 'Employee');
                                        setState(() {
                                          isUpdating =false;
                                        });
                                        Get.back();
                                      }
                                    });

                                  }
                                },
                                child: isUpdating?const CircularProgressIndicator(
                                  color: AppColor.darkGreyColor,
                                  backgroundColor: Colors.black,
                                ):ButtonMixin().stylishButton(onPress: () {}, text: 'Update Profile'),
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
