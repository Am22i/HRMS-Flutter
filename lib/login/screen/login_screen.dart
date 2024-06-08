import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import '../../mixin/textfield_mixin.dart';
import 'login_screen_admin.dart';

class LoginScreen extends StatefulWidget with ButtonMixin,TextFieldMixin{
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  // var passwordController = TextEditingController();
  // var emailController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  // bool passwordVisibility = false;
  // String? chooseType;
  // bool chooseValue = false;
  late TabController customerTabController;
  final List<Widget> _tabs = [
    const Tab(child: FittedBox(child: Text('Employee',style: TextStyle(fontSize: 20,fontFamily: AppFonts.bold)))),
    const Tab(child: FittedBox(child: Text('Admin',style: TextStyle(fontSize: 20,fontFamily: AppFonts.bold)))),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTabController = TabController(length: _tabs.length, vsync: this);
    // Provider.of<LoginProvider>(context,listen: false).fetchRecords();
    //print(Provider.of<LoginProvider>(context,listen: false).adminDataList[0].mobile);
  }

  @override
  Widget build(BuildContext context) {

    //New code Start
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TabBar(
            controller: customerTabController,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColor.blackColor,
            indicatorColor: AppColor.appColor,
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.5,color: AppColor.appColor)
            ),
            tabs: _tabs,
            onTap: (val) {
              // quoteTabController.animateTo(0);
              // orderTabController.animateTo(0);
              // setState(() {});
            },
          ),
        ),
        body:TabBarView(
          controller: customerTabController,
          children:  const [
            LoginScreenAdmin(),
            LoginScreenAdmin(),
            // LoginScreenAdmin(),
            // LoginScreenEmployee()
          ],
        )
    );
    //New code end
    /*return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                 *//* Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("Employee",style: TextStyle(fontFamily: AppFonts.Medium)),
                            Radio(
                                value: "Employee",
                                groupValue: chooseType,
                                onChanged: (value){
                                  setState(() {
                                    chooseType = value.toString();
                                    chooseValue = false;
                                  });
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Admin",style: TextStyle(fontFamily: AppFonts.Medium)),
                            Radio(
                                value: "Admin",
                                groupValue: chooseType,
                                onChanged: (value){
                                  setState(() {
                                    chooseType = value.toString();
                                    chooseValue = true;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),*//*
                  const SizedBox(height: 70),
                  const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24,fontFamily: AppFonts.Medium),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please sign in to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: AppFonts.Light),
                  ),
                  const SizedBox(height: 40),
                  TextFieldMixin().textFieldCardWidget(
                    controller: emailController,
                    prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                    labelText: 'Email',
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
                    controller: passwordController,
                    prefixIcon: const Icon(Icons.lock, color: AppColor.appColor),
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
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: (){
                      Get.to(ResetPasswordScreen());
                    },
                      child: const Text('Reset Password',style: TextStyle(fontFamily: AppFonts.Light),)),
                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState!.validate()){
                          Provider.of<LoadingProvider>(context,listen: false).startLoading();
                          User? user = await LoginAuth.signInUsingEmailPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(), context: context,
                          );
                          if (user != null) {
                            AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
                            AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, emailController.text);
                            Provider.of<LoginProvider>(context,listen: false).getSharedPreferenceData(emailController.text);
                            if (_formKey.currentState!.validate()) {
                              Provider.of<LoginProvider>(context,listen: false).getData(emailController.text);
                            }
                            Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                          }
                        }
                      },
                      child: ButtonMixin()
                          .stylishButton(onPress: () {}, text: 'Sign In'),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                'Don' "'" 't Have An Account Yet? ',
                style: TextStyle(
                    decorationThickness: 2,
                    decoration: TextDecoration.none,
                    fontFamily: AppFonts.Medium,
                    color:AppColor.appBlackColor),
              ),
            ),
            GestureDetector(
              onTap: (){
              // chooseValue == true ?
               Get.off(RegisterScreen());
                 //  : Get.off(RegisterEmployeeScreen());
               },
              child: Container(
                padding: const EdgeInsets.only(bottom: 25),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 16,
                      decorationThickness: 1,
                      fontFamily: AppFonts.Medium,
                      decoration: TextDecoration.underline,
                      color:AppColor.appColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}



