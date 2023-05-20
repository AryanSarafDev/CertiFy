import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/dropController.dart';

import '../utils/constants.dart';
import '../utils/textbox.dart';

List<String> list = <String>[
  'Personal',
  'Organization',
  'Verification',
];

class registerS extends StatefulWidget {
  @override
  State<registerS> createState() => _registerSState();
}

class _registerSState extends State<registerS> {
  TextEditingController _emailc = new TextEditingController();
  TextEditingController _namec = new TextEditingController();
  TextEditingController _passc = new TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    supabase.dispose;
    _emailc.dispose();
    _namec.dispose();
    _passc.dispose();
    super.dispose();
  }

  bool isorg = false;
  bool isper = true;
  bool isver = false;
  String dropdownValue = list.first;
  DropCont dropcontroller = DropCont();
  var drop = "".obs;
  String un = "Username";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            //Stack 1: Container for background card
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.97,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(20)),
              ),
            ),
            //Stack 2: Container for background card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.0,
                decoration: BoxDecoration(
                    color: secondary, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(spadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 8.0),
                        child: TextString(
                          textEditingController: _namec,
                          hintText: "Enter $un",
                          textInputType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 8.0),
                        child: TextString(
                            textEditingController: _emailc,
                            hintText: "Enter email",
                            textInputType: TextInputType.emailAddress),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 8.0),
                        child: TextString(
                          textEditingController: _passc,
                          hintText: "Enter Password",
                          textInputType: TextInputType.visiblePassword,
                          isPass: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 70, vertical: 8),
                        child: DropdownButton(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: fourthdull),
                          underline: Container(
                            height: 2,
                            color: primary,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;

                              if (dropdownValue == "Organization") {
                                un = "Organization";
                                isorg = true;
                                isper = false;
                                isver = false;
                              } else if (dropdownValue == "Personal") {
                                un = "Username";
                                isper = true;
                                isorg = false;
                                isver = false;
                              } else if (dropdownValue == "Verification") {
                                un = "Username";
                                isver = true;
                                isper = false;
                                isorg = false;
                              }
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 70, vertical: 16),
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  try {
                                    await supabase.auth.signUp(
                                        password: _passc.text,
                                        email: _emailc.text);

                                    String userid =
                                        supabase.auth.currentUser!.id;
                                    if (isorg == true) {
                                      await supabase.from('everyone').insert({
                                        'username': _namec.text,
                                        'oid': userid,
                                        'isorg': isorg,
                                        'isper': isper,
                                        'isver': isver,
                                        'email': _emailc.text
                                      });
                                    } else {
                                      await supabase.from('everyone').insert({
                                        'username': _namec.text,
                                        'uid': userid,
                                        'isorg': isorg,
                                        'isper': isper,
                                        'isver': isver,
                                        'email': _emailc.text
                                      });
                                    }
                                    Get.back();

                                    await supabase.auth.signInWithPassword(
                                        password: _passc.text,
                                        email: _emailc.text);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Error Signing up $e"),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                },
                                child: Text(
                                  "Sign-up",
                                  style:
                                      TextStyle(color: secondary, fontSize: 20),
                                ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    ));
  }
}
