
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


import 'package:permission_handler/permission_handler.dart';
 class Downloader{
  //file download function

void download(String name, String url) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,

  ].request();

  if(statuses[Permission.storage]!.isGranted){
    Directory root = await getTemporaryDirectory();

    var path = root.path + '/docs';;


    var savePath = path ;
    print(savePath);
    print(url);


    try {
      await Dio().download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
              //you can build progressbar feature too
            }
          });
      print("File is saved to download folder.");
    } on DioError catch (e) {
      print(e.message);
    }
  }else{
    print("No permission to read and write.");
  }

}

}
