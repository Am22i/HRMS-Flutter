import 'package:employee_attendance_app/login/controller/onboarding_controller.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>{

  final _controller = OnBoardingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.appColor.withOpacity(0.5),
                AppColor.appColor.withOpacity(0.0),
              ],
            ),
          ),
          child: Stack(
            children: [
              PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: _controller.selectedPageIndex,
                  itemCount: _controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            _controller.onboardingPages[index].imageAsset,height: 200),
                        const SizedBox(height: 80),
                        Text(
                          _controller.onboardingPages[index].title,textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 30,fontFamily: AppFonts.bold),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:50.0),
                          child: Text(
                            _controller.onboardingPages[index].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20,fontFamily: AppFonts.regular),
                          ),
                        ),
                      ],
                    );
                  }),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                    onTap: (){
                      Get.off(LoginScreen());
                    },
                    child: Container(
                      color: Colors.transparent,
                        height:40,width:70,child: const Center(child: Text('Skip',textAlign: TextAlign.center,style: TextStyle(fontFamily: AppFonts.bold,fontSize: 20),))),
                  ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Obx(() {
                  return _controller.selectedPageIndex.value != 0
                      ? GestureDetector(
                          onTap: () {
                            _controller.pageController.previousPage(
                                duration: 300.milliseconds,
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                              color: Colors.transparent,
                              height: 40,
                              width: 40,
                              child:
                                  const Center(child: Icon(Icons.arrow_back))),
                        )
                      : const SizedBox.shrink();
                }),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: List.generate(
                    _controller.onboardingPages.length,
                        (index) => Obx(() {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        width: 15,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _controller.selectedPageIndex.value == index
                              ? AppColor.appColor
                              : AppColor.backgroundColor,
                          shape: BoxShape.rectangle,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Obx(() {
                  return GestureDetector(
                    onTap: _controller.forwardAction,
                    child: Container(
                        color: Colors.transparent,
                        height:40,child: Center(child: Text(_controller.isLastPage ? 'Get Started' : 'Next -->',textAlign: TextAlign.center,style: const TextStyle(fontFamily: AppFonts.semiBold,fontSize: 20),))),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
