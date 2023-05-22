import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/certificateVerificationController.dart';

import 'constants.dart';

class UploadSt {
  late CertificateVerificationController certificateVerification;
  late SupabaseClient supabase;

  UploadSt() {
    certificateVerification = CertificateVerificationController();

    supabase = Supabase.instance.client;
  }

  String calculateSHA256(String input) {
    List<int> bytes = utf8.encode(input);
    Digest sha256Result = sha256.convert(bytes);
    String hash = sha256Result.toString();
    return hash;
  }

  verifyCertificate(String studentHash, String orgHash, String certHash) async {

    await certificateVerification.init();
    var x = await certificateVerification.verifyCertificate(
        studentHash, orgHash, certHash);
    print(x);
    return x;
  }

  Future<void> uploadh(String certHash, String fn, String emailc, String nac,
      File filess, String nw, String orgEmail) async {
    await certificateVerification.init();
    String upload = await supabase.storage
        .from('pdfs')
        .upload("${supabase.auth.currentUser!.id}/$fn", filess);
    final uploadUrl = supabase.storage.from('').getPublicUrl(upload);
    String userid = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('everyone')
        .select('uid')
        .textSearch('email', emailc);
    print(data[0]['uid']);

    String studentHash = calculateSHA256(emailc);
    String orgHash = calculateSHA256(orgEmail);
    var tranhash = await certificateVerification.addCertificate(
        studentHash, orgHash, certHash);
    print(tranhash);





    DateTime now =  DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    try{
    await supabase.from('organization').insert({
      'created_at' : date.toString(),
      'oid': userid,
      'uid': data[0]['uid'],
      'certificate': uploadUrl,
      'email': emailc,
      'certname': nac,
      'orgname': nw,
      'hashval': certHash,
      'filename': fn,
      'orgemail': orgEmail,
      'transhash': tranhash
    });}catch(e){Get.snackbar("Error","$e",colorText: Colors.red);}finally{
      Get.snackbar("Upload completed!","You can now refresh the list",colorText: Colors.green);
    }


  }
  void revoke(String emaill, String orgemail,String hash) async{
    await certificateVerification.init();
    String studentHash = calculateSHA256(emaill);
    String orgHash = calculateSHA256(orgemail);
    await certificateVerification.revokeCertificate(studentHash, orgHash, hash);



  }
}
