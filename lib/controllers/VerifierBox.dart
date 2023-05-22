import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';
import '../utils/hashcalc.dart';
import '../utils/textbox.dart';
import '../utils/uploadd.dart';

class VerifierBox extends StatefulWidget {
  const VerifierBox({Key? key}) : super(key: key);

  @override
  State<VerifierBox> createState() => _VerifierBoxState();
}

class _VerifierBoxState extends State<VerifierBox> {
  TextEditingController _emailuser = new TextEditingController();
  TextEditingController _emailorg = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailorg.dispose();
    _emailuser.dispose();
  }

  late File filess;
  String? hashvall;
  String fn = "filename";
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: 300,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Visibility(
                visible: true,
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
                          textEditingController: _emailuser,
                          hintText: "Enter Holder's email",
                          textInputType: TextInputType.text),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextStringWhite(
                          textEditingController: _emailorg,
                          hintText: "Enter Organization email",
                          textInputType: TextInputType.emailAddress),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                String calculateSHA256(String input) {
                                  List<int> bytes = utf8.encode(input);
                                  Digest sha256Result = sha256.convert(bytes);
                                  String hash = sha256Result.toString();
                                  return hash;
                                }

                                String studentHash =
                                    calculateSHA256(_emailuser.text);
                                String orgHash =
                                    calculateSHA256(_emailorg.text);
                                var verify = await UploadSt().verifyCertificate(
                                    studentHash, orgHash, hashvall!);
                                print(verify);
                                if (verify == true) {
                                  Get.snackbar(
                                      "Verified ✅", "Certificate is valid",
                                      backgroundColor: Colors.green);
                                } else {
                                  Get.snackbar("Not Verified ❌",
                                      "Certificate is not valid",
                                      backgroundColor: Colors.red);
                                }
                              },
                              child: Text(
                                "Verify",
                                style: TextStyle(color: primary, fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            )))
                  ],
                ))));
  }
}
