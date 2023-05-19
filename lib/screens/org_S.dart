import 'dart:async';
import 'dart:io';


import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/utils/downloader.dart';

import '../utils/constants.dart';
import '../utils/textbox.dart';

class orgS extends StatefulWidget {
  const orgS({Key? key}) : super(key: key);

  @override
  State<orgS> createState() => _orgSState();
}

class _orgSState extends State<orgS> {
  final SupabaseClient supabase = Supabase.instance.client;
  TextEditingController _emailc = new TextEditingController();
  TextEditingController _nac = new TextEditingController();

  @override
  void initState() {
    _name();
    certData();
    super.initState();
  }

  late File filess;

  double hi = 0;
  double hi1 = 0;
  String fn = "filename";
  bool view = false;
  String nw = "";

  Future<List> certData() async {
    final _nu = await supabase.auth.currentUser!.id;
    final certd =
        await supabase.from('organization').select('*').textSearch('oid', _nu);
    print(certd);
    return certd;
  }

  void _name() async {
    print("apple");
    final nu = await supabase.auth.currentUser!.id;
    final nv = await supabase
        .from('everyone')
        .select('username')
        .textSearch('oid', nu);

    setState(() async {
      nw = await nv[0]['username'];
      setState(() {});
    });
  }

  @override
  void dispose() {
    supabase.dispose;
    _emailc.dispose();
    _nac.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: primary,
                            fontSize: 50,
                            fontFamily: 'Markbold'),
                      ),
                      Text(
                        "$nw!",
                        style: TextStyle(
                            color: primary,
                            fontSize: 30,
                            fontFamily: 'Markbold'),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    await supabase.auth.signOut();
                  },
                  icon: Icon(Icons.logout),
                  color: primary,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (hi == 0) {
                      hi = 300;
                      hi1 = 60;
                      view = true;
                    } else {
                      view = false;
                      hi = 0;
                      hi1 = 0;
                    }
                  });
                },
                child: Container(
                  height: 100,
                  width: 270,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Add a certificate",
                          style: TextStyle(
                              color: third,
                              fontSize: 20,
                              fontFamily: 'Markbold'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.add, color: third),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 0),
                height: hi,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(20)),
                child: Visibility(
                  visible: view,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    var a = result.files.single.path!;
                                    filess = File(result.files.single.path!);
                                    setState(() {
                                      fn = file.name;
                                    });
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.file_copy,
                                    color: primary,
                                  ),
                                  height: 60,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  fn,
                                  style: TextStyle(
                                      color: third,
                                      fontSize: 20,
                                      fontFamily: 'Markbold'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextStringWhite(
                            textEditingController: _nac,
                            hintText: "Enter Certificate Title",
                            textInputType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextStringWhite(
                            textEditingController: _emailc,
                            hintText: "Enter email",
                            textInputType: TextInputType.emailAddress),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                  try {
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
                                        .textSearch('email', _emailc.text);
                                    print(data[0]['uid']);

                                    await supabase.from('organization').insert({
                                      'oid': userid,
                                      'uid': data[0]['uid'],
                                      'certificate': uploadUrl,
                                      'email': _emailc.text,
                                      'certname': _nac.text,
                                      'orgname': nw
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("$e"),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: secondary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Text(
                                  "Submit",
                                  style:
                                      TextStyle(color: primary, fontSize: 20),
                                ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Certificates Issued",
                            style: TextStyle(
                                color: third,
                                fontSize: 20,
                                fontFamily: 'Markbold'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.refresh_outlined),
                          color: third,
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: certData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
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
                                  print("$index) ");
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
                                                style: TextStyle(color: primary),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                "$timee",
                                                style: TextStyle(color: primary),
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
                                              Downloader().download(namee, link);
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
