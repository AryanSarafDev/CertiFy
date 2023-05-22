

import 'package:dio/dio.dart';
import 'package:get/get.dart';



import 'package:permission_handler/permission_handler.dart';
 class Downloader{

  //file download function


void download(String name, String url) async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,

    //add more permission to request here.
  ].request();
  if(statuses[Permission.storage]!.isGranted){




    String savePath =  "/storage/emulated/0/Download"+ "/$name.pdf ";


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
      Get.snackbar("Download", "completed");
    } on DioError catch (e) {
      print(e.message);
    }
  }else{
    print("No permission to read and write.");
  }


}

}
