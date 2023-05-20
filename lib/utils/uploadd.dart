import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/certificateVerificationController.dart';

class UploadSt {
  final certificateVerification = CertificateVerificationController();

  final SupabaseClient supabase = Supabase.instance.client;

  String calculateSHA256(String input) {
    List<int> bytes = utf8.encode(input);
    Digest sha256Result = sha256.convert(bytes);
    String hash = sha256Result.toString();
    return hash;
  }

  Future<void> uploadh(String certHash, String fn, String emailc, String nac,
      File filess, String nw, String orgEmail) async {
    certificateVerification.init();
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

    await supabase.from('organization').insert({
      'oid': userid,
      'uid': data[0]['uid'],
      'certificate': uploadUrl,
      'email': emailc,
      'certname': nac,
      'orgname': nw,
      'hashval': certHash
    });

    String studentHash = calculateSHA256(emailc);
    String orgHash = calculateSHA256(orgEmail);
    certificateVerification.addCertificate(studentHash, orgHash, certHash);
  }
}
