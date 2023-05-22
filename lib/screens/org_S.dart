import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/certListing.dart';
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
  final TextEditingController _emailc = TextEditingController();
  final TextEditingController _nac = TextEditingController();
  late Future<List<dynamic>> certData;

  @override
  void initState() {
    setState(() {
      certData = certificateData();
      setname();
    });
    super.initState();
  }

  String? hashvall;
  late File filess;

  double hi = 0;
  double hi1 = 0;
  String fn = "filename";
  bool view = false;
  String displayname = "";
  double buttonpress = 20;
  double buttonshadow = 0;
  double buttonside = 10;

  void setname() async {
    var recieve = await Displayname();
    setState(() {
      displayname = recieve;
    });
    setState(() {});
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
        const Bannerb(),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeT(name: displayname),
              Padding(
                padding: EdgeInsets.fromLTRB(buttonside,buttonpress, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (hi == 0) {
                        hi = 300;

                        Timer(const Duration(milliseconds: 400), () {
                          setState(() {
                            view = true;
                          });
                        });
                      } else {
                        view = false;
                        hi = 0;
                      }
                      setState(() {
                        buttonshadow = -12;
                        buttonpress = 26;
                        buttonside = 6;
                      });
                      Timer(Duration(milliseconds: 200), () {
                        setState(() {
                          buttonshadow = 0;
                          buttonpress = 20;
                          buttonside = 10;
                        });
                      });

                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Container(
                      height: 100,
                      width: 270,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(90),
                        boxShadow: [
                          BoxShadow(
                            color: secondary,
                            spreadRadius: buttonshadow,
                            offset: Offset(-8, 8),
                          )
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add, color: third),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
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
                                    height: 60,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.file_copy,
                                      color: primary,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    fn,
                                    style: const TextStyle(
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
                                  onPressed: () {
                                    try {
                                      UploadSt().uploadh(
                                        hashvall!,
                                        fn,
                                        _emailc.text,
                                        _nac.text,
                                        filess,
                                        displayname,
                                        supabase.auth.currentUser!.email!,
                                      );
                                    } catch (e) {
                                      Get.snackbar("$e", "",
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: secondary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: const Text(
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
                          const Padding(
                            padding: EdgeInsets.all(12.0),
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
                              setState(() {
                                certData = certificateData();
                              });
                            },
                            icon: const Icon(Icons.refresh_outlined),
                            color: third,
                          )
                        ],
                      ),
                      Orglist(certdata: certData),
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
