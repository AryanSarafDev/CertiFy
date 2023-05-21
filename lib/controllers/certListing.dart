import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/certificateVerificationController.dart';
import 'package:supaverify/utils/uploadd.dart';

import '../utils/constants.dart';
import '../utils/downloader.dart';
class Orglist extends StatefulWidget {

   Orglist({Key? key, required this.certdata}) : super(key: key);

  @override
  State<Orglist> createState() => _OrglistState();
  final Future<dynamic> certdata;


}
final SupabaseClient supabase = Supabase.instance.client;
class _OrglistState extends State<Orglist> {

  @override

  Widget build(BuildContext context) {

    return FutureBuilder(
      future: widget.certdata,
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(snapshot.error.toString()));
        }

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("Empty"),
            );
          }
          return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  var stuff = snapshot.data[index];
                  var namee = stuff['certname'];
                  var link = stuff['certificate'].toString();
                  var emaill = stuff['email'];
                  var timee = stuff['created_at'];
                  var hash = stuff['hashval'];


                  var filename = stuff['filename'];
                  var userid = stuff['oid'];
                  var orgemail = stuff['orgemail'];
                  print(userid);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondary,
                          borderRadius:
                          BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            "$namee",
                            style: TextStyle(color: primary),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$emaill",
                                style:
                                TextStyle(color: primary),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "$timee",
                                style:
                                TextStyle(color: primary),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          trailing: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: primary,
                                ),

                                onPressed: () {
                                  Downloader()
                                      .download(filename, link);
                                },
                              ),IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: primary,
                                ),

                                onPressed: () async{
                                  print(filename);
                                  print("userid");







                                  await supabase
                                      .from('organization')
                                      .delete()
                                      .match({ 'certname': namee});




                                  final List<FileObject> objec = await supabase
                                      .storage
                                      .from('pdfs')
                                      .remove(['$userid/$filename']);
                                  setState(() {

                                  });


                                  UploadSt().revoke(emaill, orgemail, hash);






                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}


  Future<List> certificateData() async {

    final _nu = await supabase.auth.currentUser!.id;
    final certd =
    await supabase.from('organization').select('*').textSearch('oid', _nu);
    print(certd);
    return certd;
  }
Future<List> certificateDataforUser() async {

  final _nu = await supabase.auth.currentUser!.id;
  final certd =
  await supabase.from('organization').select('*').textSearch('uid', _nu);
  print(certd);
  return certd;
}
class UserList extends StatefulWidget {
  const UserList({Key? key,required this.certdata}) : super(key: key);
  final Future<dynamic> certdata;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.certdata,
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(snapshot.error.toString()));
        }

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("Empty"),
            );
          }
          return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  var stuff = snapshot.data[index];
                  var namee = stuff['certname'];
                  var link =
                  stuff['certificate'].toString();
                  var timee = stuff['created_at'];
                  var orgg = stuff['orgname'];
                  var filename = stuff['filename'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondary,
                          borderRadius:
                          BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            "$namee",
                            style:
                            TextStyle(color: primary),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$orgg",
                                style: TextStyle(
                                    color: primary),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "$timee",
                                style: TextStyle(
                                    color: primary),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.download,
                              color: primary,
                            ),
                            onPressed: () {
                              Downloader()
                                  .download(filename, link);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}



