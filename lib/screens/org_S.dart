import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/utils/downloader.dart';
import 'package:supaverify/utils/hashcalc.dart';
import 'package:supaverify/utils/uploadd.dart';
import 'package:supaverify/utils/welcometab.dart';

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

  String? hashvall;
  late File filess;

  double hi = 0;
  double hi1 = 0;
  String fn = "filename";
  bool view = false;
  String nw = "";
  String orgEmail = "";
  var dd;

  Future<List> certData() async {
    final _nu = await supabase.auth.currentUser!.id;
    final certd =
        await supabase.from('organization').select('*').textSearch('oid', _nu);
    print(certd);
    return certd;
  }

  void _name() async {
    final nu = supabase.auth.currentUser!.id;

    final nv = await supabase
        .from('everyone')
        .select('username')
        .textSearch('oid', nu);

    setState(() {
      nw = nv[0]['username'];
      orgEmail = supabase.auth.currentUser!.email!;
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
      body: Stack(children: [
        Bannerb(),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeT(name: nw),
              TextButton(
                  onPressed: () {
                    UploadSt().verifyCertificate(
                        "aebd6721742346a1fa847fda68f8edb31cfcf0b436cbfc27d611c2f8caf84290",
                        "aebd6721742346a1fa847fda68f8edb31cfcf0b436cbfc27d611c2f8caf84290",
                        "6c5e16ed6879e9a84a30b0970b4e6988ba74083d1a492e069e687935e3d96830");
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.black),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (hi == 0) {
                        hi = 300;

                        Timer(Duration(milliseconds: 400), () {
                          setState(() {
                            view = true;
                          });
                        });
                      } else {
                        view = false;
                        hi = 0;
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
                      color: primary,
                      borderRadius: BorderRadius.circular(90),
                      boxShadow: [
                        BoxShadow(
                          color: secondary,
                          spreadRadius: 0,
                          offset: Offset(-5, 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: hi,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );
                                    setState(() {
                                      dd = result;
                                    });

                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      filess = File(result.files.single.path!);

                                      setState(() {
                                        fn = file.name;
                                      });
                                      var newhash = await getFileSha256(
                                          result.files.single.path!);
                                      setState(() {
                                        hashvall = newhash;
                                      });
                                    } else {}
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                      UploadSt().uploadh(
                                          hashvall!,
                                          fn,
                                          _emailc.text,
                                          _nac.text,
                                          filess,
                                          nw,
                                          orgEmail);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.download,
                                                color: primary,
                                              ),
                                              onPressed: () {
                                                Downloader()
                                                    .download(namee, link);
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
      ]),
    ));
  }
}
