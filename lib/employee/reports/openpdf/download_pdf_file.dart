import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class DownloadPdfFile{
  int version = 0;
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  Future<void> getAndroidDeviceInfo() async {

  }

  Future<bool> savePdf(url, fileName) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    try {
      androidInfo = await deviceInfo.androidInfo;
       version = int.parse(androidInfo.version.release);
      print("ANDROID_DEVICE_VERSION $version");
      print('Android version OpenPdfInOutPresent : ${androidInfo.version.release}');
      print('Android version OpenPdfInOutSummary : ${androidInfo.model}');
      print('Android version OpenPdfInOutSummary : ${androidInfo.brand}');
    } catch (e) {
      print('Error getting Android device info: $e');
    }
    Directory? directory;
    // var linked;
    try {
      if (Platform.isAndroid) {
        if ((version > 12)?true:await _requestPermission(Permission.storage)  ) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/Download";
          directory = Directory(newPath);

          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            String tempPath = directory.path;
            final filePath = '$tempPath/$fileName.pdf';
            ByteData bytes = ByteData.view(url.buffer);
            final buffer = bytes.buffer;
            File(filePath).writeAsBytes(buffer.asUint8List(url.offsetInBytes, url.lengthInBytes));
            return true;
          }
          return false;
        } else {
          return false;
        }
      }
      else if(Platform.isIOS) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            File saveFile = File('${directory.path}/$fileName.pdf');
            //await saveFile.writeAsBytes(linked);
            await saveFile.writeAsBytes(url);
            return true;
          }
          return false;
        } else {
          return false;
        }
      }
      else{
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  downloadFile(linked) async {
    Random random = Random();

    bool downloaded = await savePdf(linked,'report${random.nextInt(10)}');
    if (downloaded) {
      AppUtils.instance.showToast(toastMessage: 'File Downloaded');
      debugPrint("File Downloaded");
    } else {
      AppUtils.instance.showToast(toastMessage: 'File Failed');
      debugPrint("Problem Downloading File");
    }
  }
}