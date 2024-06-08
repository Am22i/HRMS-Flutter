import 'package:device_info_plus/device_info_plus.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'download_pdf_file.dart';
//ignore: must_be_immutable
class OpenPdfInOutPresent extends StatefulWidget {

  dynamic linked;

  OpenPdfInOutPresent({Key? key,required this.linked}) : super(key: key);

  @override
  State<OpenPdfInOutPresent> createState() => _OpenPdfInOutPresentState();
}

class _OpenPdfInOutPresentState extends State<OpenPdfInOutPresent> {
  Future<void> getAndroidDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    try {
      androidInfo = await deviceInfo.androidInfo;
      print('Android version OpenPdfInOutPresent : ${androidInfo.version.release}');
      print('Android version OpenPdfInOutSummary : ${androidInfo.model}');
      print('Android version OpenPdfInOutSummary : ${androidInfo.brand}');
    } catch (e) {
      print('Error getting Android device info: $e');
    }
  }
  @override
  void initState() {
    getAndroidDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: widget.linked == null ? const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.indigo)) :
      SfPdfViewer.memory(widget.linked),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          DownloadPdfFile().downloadFile(widget.linked);
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
