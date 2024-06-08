// import 'package:employee_attendance_app/login/screen/reset_password_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import '../../mixin/button_mixin.dart';
// import '../../mixin/textfield_mixin.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_images.dart';
// import '../../utils/app_preference_key.dart';
// import '../../utils/app_utils.dart';
// import '../auth/login_auth.dart';
// import '../provider/loading_provider.dart';
// import '../provider/login_provider.dart';
//
// class LoginScreenEmployee extends StatefulWidget {
//   const LoginScreenEmployee({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreenEmployee> createState() => _LoginScreenEmployeeState();
// }
//
// class _LoginScreenEmployeeState extends State<LoginScreenEmployee> {
//
//   var passwordController = TextEditingController();
//   var emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool passwordVisibility = false;
//   String? chooseType;
//   bool chooseValue = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Provider.of<LoginProvider>(context,listen: false).fetchRecords();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // const SizedBox(height: 50),
//                   Center(
//                     child:Image.asset(AppImage.appLogo,height: 150,width: 150,fit: BoxFit.fill),
//                   ),
//                   /* Align(
//                     alignment: Alignment.topCenter,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Employee",style: TextStyle(fontFamily: AppFonts.Medium)),
//                             Radio(
//                                 value: "Employee",
//                                 groupValue: chooseType,
//                                 onChanged: (value){
//                                   setState(() {
//                                     chooseType = value.toString();
//                                     chooseValue = false;
//                                   });
//                                 }),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text("Admin",style: TextStyle(fontFamily: AppFonts.Medium)),
//                             Radio(
//                                 value: "Admin",
//                                 groupValue: chooseType,
//                                 onChanged: (value){
//                                   setState(() {
//                                     chooseType = value.toString();
//                                     chooseValue = true;
//                                   });
//                                 }),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),*/
//                   const SizedBox(height: 50),
//                   const Text(
//                     "Login",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 24,fontFamily: AppFonts.medium),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Please sign in to continue',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontFamily: AppFonts.medium),
//                   ),
//                   const SizedBox(height: 40),
//                   TextFieldMixin().textFieldCardWidget(
//                     controller: emailController,
//                     prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
//                     labelText: 'Email',
//                     validator: (value) {
//                       if (value!.isEmpty ||
//                           value.trim().isEmpty ||
//                           !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
//                           r"[a-zA-Z0-9]+\.[a-zA-Z]+")
//                               .hasMatch(value)) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   TextFieldMixin().textFieldCardWidget(
//                     controller: passwordController,
//                     prefixIcon: const Icon(Icons.lock, color: AppColor.appColor),
//                     labelText: 'Password',
//                     obscureText: passwordVisibility ? false : true,
//                     suffixIcon: IconButton(
//                         highlightColor: Colors.transparent,
//                         onPressed: () {
//                           setState(() {
//                             passwordVisibility = !passwordVisibility;
//                           });
//                         },
//                         icon: passwordVisibility
//                             ? const Icon(
//                           Icons.visibility,
//                           color: AppColor.appColor,
//                         )
//                             : const Icon(Icons.visibility_off,
//                             color: AppColor.appColor)),
//                     validator: (value) {
//                       if (value == null ||
//                           value.isEmpty ||
//                           value.trim().isEmpty) {
//                         return 'Please enter password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 5),
//                   GestureDetector(
//                       onTap: (){
//                         Get.to(ResetPasswordScreen());
//                       },
//                       child: const Text('Reset Password',style: TextStyle(fontFamily: AppFonts.medium),)),
//                   const SizedBox(height: 30),
//
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: GestureDetector(
//                       onTap: () async {
//                         FocusScope.of(context).unfocus();
//                         if(_formKey.currentState!.validate()){
//                           Provider.of<LoadingProvider>(context,listen: false).startLoading();
//                           User? user = await LoginAuth.signInUsingEmailPassword(
//                             email: emailController.text.trim(),
//                             password: passwordController.text.trim(), context: context,
//                           );
//                           if (user != null) {
//                             AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
//                             AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, emailController.text);
//                             Provider.of<LoginProvider>(context,listen: false).getSharedPreferenceData(emailController.text);
//                             if (_formKey.currentState!.validate()) {
//                               Provider.of<LoginProvider>(context,listen: false).getData(emailController.text);
//                             }
//                             Provider.of<LoadingProvider>(context,listen: false).stopLoading();
//                           }
//                         }
//                       },
//                       child: ButtonMixin()
//                           .stylishButton(onPress: () {}, text: 'Sign In'),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         /*bottomNavigationBar: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(bottom: 25),
//               child: const Text(
//                 'Don' "'" 't Have An Account Yet? ',
//                 style: TextStyle(
//                     decorationThickness: 2,
//                     decoration: TextDecoration.none,
//                     fontFamily: AppFonts.Medium,
//                     color:AppColor.appBlackColor),
//               ),
//             ),
//             GestureDetector(
//               onTap: (){
//               // chooseValue == true ?
//                Get.off(RegisterScreen());
//                  //  : Get.off(RegisterEmployeeScreen());
//                },
//               child: Container(
//                 padding: const EdgeInsets.only(bottom: 25),
//                 child: const Text(
//                   'Sign Up',
//                   style: TextStyle(
//                       fontSize: 16,
//                       decorationThickness: 1,
//                       fontFamily: AppFonts.Medium,
//                       decoration: TextDecoration.underline,
//                       color:AppColor.appColor),
//                 ),
//               ),
//             ),
//           ],
//         ),*/
//       ),
//     );
//   }
// }
