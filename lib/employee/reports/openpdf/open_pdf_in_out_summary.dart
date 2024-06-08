
import 'package:device_info_plus/device_info_plus.dart';
import 'package:employee_attendance_app/employee/reports/openpdf/download_pdf_file.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//ignore: must_be_immutable
class OpenPdfInOutSummary extends StatefulWidget {

  dynamic linked;

  OpenPdfInOutSummary({Key? key,required this.linked}) : super(key: key);

  @override
  State<OpenPdfInOutSummary> createState() => _OpenPdfInOutSummaryState();
}

class _OpenPdfInOutSummaryState extends State<OpenPdfInOutSummary> {
  Future<void> getAndroidDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    try {
      androidInfo = await deviceInfo.androidInfo;
      print('Android version OpenPdfInOutSummary : ${androidInfo.version.release}');
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
      body: widget.linked == null ? const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.indigo,),) :
      SfPdfViewer.memory(widget.linked),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.appColor,
        onPressed: (){
          DownloadPdfFile().downloadFile(widget.linked);
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
