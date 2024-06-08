import 'package:employee_attendance_app/login/provider/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class Loading extends StatelessWidget {
  final Widget? child;

  const Loading({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, data, _) {
        return IgnorePointer(
          ignoring: data.isLoading,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child!,
              if (data.isLoading)
                const Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: SpinKitThreeBounce(
                      color: AppColor.appColor,
                      size: 40,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
