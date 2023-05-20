import 'dart:io';


import 'package:supabase_flutter/supabase_flutter.dart';
class UploadSt{

  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> uploadh(String b,String fn,String emailc,String nac, File filess,String nw)
  async {
    print("PP");
      String upload = await supabase.storage
          .from('pdfs')
          .upload(
          "${supabase.auth.currentUser!.id}/$fn",
          filess);
      final uploadUrl = supabase.storage
          .from('')
          .getPublicUrl(upload);
      String userid =
      await supabase.auth.currentUser!.id;
      final data = await supabase
          .from('everyone')
          .select('uid')
          .textSearch('email', emailc);
      print(data[0]['uid']);

      await supabase
          .from('organization')
          .insert({
        'oid': userid,
        'uid': data[0]['uid'],
        'certificate': uploadUrl,
        'email': emailc,
        'certname':nac,
        'orgname': nw,
        'hashval': b
      });
    }

}