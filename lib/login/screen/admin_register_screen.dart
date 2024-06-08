import 'package:employee_attendance_app/login/auth/login_auth.dart';
import 'package:employee_attendance_app/login/provider/login_provider.dart';
import 'package:employee_attendance_app/login/screen/login_screen.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';
import '../provider/loading_provider.dart';

class RegisterScreen extends StatefulWidget with ButtonMixin,TextFieldMixin {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var emailController = TextEditingController();
  var companyNameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegExp passwordValidation = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  /*@override
  void dispose() {
    companyNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child:  Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        "Create Admin Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontFamily: AppFonts.medium),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextFieldMixin().textFieldCardWidget(
                      controller: companyNameController,
                      prefixIcon: const Icon(Icons.person, color: AppColor.appColor),
                      labelText: 'Company Name',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: emailController,
                      prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.trim().isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                            r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: mobileController,
                      prefixIcon: const Icon(Icons.phone, color: AppColor.appColor),
                      labelText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
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
                    TextFieldMixin().textFieldCardWidget(
                      controller: passwordController,
                      prefixIcon: const Icon(Icons.lock, color: AppColor.appColor),
                      labelText: 'Password',
                     /* onChanged: (val) {
                        final key = encrypt.Key.fromUtf8('my 32 length key................');
                        final iv = encrypt.IV.fromLength(16);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));
                        print("Password is encrypted::: ${encrypter.encrypt(val, iv: iv).base64}");
                        print("Password is decrypted::: ${encrypter.decrypt(encrypter.encrypt(val, iv: iv), iv: iv)}");

                        },*/
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Enter valid password';
                        } else if (!passwordValidation
                            .hasMatch(passwordController.text)) {
                          return 'Password must contain at least one number and both lower upper case letters and special characters.';
                        } else if (value.length < 8) {
                          return 'Password must be atLeast 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: confirmPasswordController,
                      prefixIcon: const Icon(Icons.lock, color: AppColor.appColor),
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter confirm password!';
                        }
                        if (value != passwordController.text) {
                          return "Password does Not Match";
                        } else if (passwordController.text.isNotEmpty &&
                            passwordController.text.length >= 8 &&
                            passwordController.text.length <= 16 &&
                            !passwordController.text.contains(' ') &&
                            RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(
                                passwordController.text.toString())) {
                          return null;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () async{
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                           // final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8('my 32 length key................')));
                            /*signUpAdmin(
                                    email: emailController.text,
                                    companyName: companyNameController.text,
                                    mobile: mobileController.text,
                                    password: encrypter.encrypt(passwordController.text,iv: encrypt.IV.fromLength(16)).base64).toString();*/

                            Provider.of<LoadingProvider>(context,listen: false).startLoading();

                            User? user = await LoginAuth.registerUsingEmailPassword(
                              email: emailController.text,
                              password: passwordController.text,
                              userType: 'Admin', mobile: mobileController.text,context: context
                            );
                            if (user != null) {
                              Get.off(LoginScreen());
                              AppUtils.instance.showToast(toastMessage: "Register Successfully");
                              if (!mounted) return;
                              Provider.of<LoginProvider>(context,listen: false).signUpAdmin(email: emailController.text.trim(), companyName: companyNameController.text.trim(),
                                  mobile: mobileController.text.trim(),type: 'Admin');
                              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                            }
                          }
                        },
                        child: ButtonMixin()
                            .stylishButton(onPress: () {}, text: 'Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
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
                    fontFamily: AppFonts.medium,
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
                      fontFamily: AppFonts.medium,
                      color: AppColor.appColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
