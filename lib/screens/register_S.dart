import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/registerpagecontroller.dart';
import 'package:supaverify/utils/welcometab.dart';

import '../utils/constants.dart';

List<String> list = <String>[
  'Personal',
  'Organization',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Stack(

          children:[ Bannerb(), Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(

                children: [
                  Stack(children: [
                    Column(
                      children: [WelcomeT(name:"Sign-up"),
                        RegisterPageContr(
                          emailc: _emailc,
                          passc: _passc,
                          namec: _namec,
                          signupbutton: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 70, vertical: 16),
                            child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20))),
                                    onPressed: () async {
                                      try {
                                        await supabase.auth.signUp(
                                            password: _passc.text, email: _emailc.text);

                                        String userid = supabase.auth.currentUser!.id;
                                        if (isorg == true) {
                                          await supabase.from('everyone').insert({
                                            'username': _namec.text,
                                            'oid': userid,
                                            'isorg': isorg,
                                            'isper': isper,
                                            'email': _emailc.text
                                          });
                                        } else {
                                          await supabase.from('everyone').insert({
                                            'username': _namec.text,
                                            'uid': userid,
                                            'isorg': isorg,
                                            'isper': isper,
                                            'email': _emailc.text
                                          });
                                        }

                                        Get.back();
                                      Get.snackbar("Sign-up completed!","You can Sign-in now");

                                      } catch (e) {
                                        Get.snackbar(
                                          "$e",
                                          "",
                                          backgroundColor: Colors.red,
                                          colorText: primary,
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Sign-up",
                                      style: TextStyle(color: secondary, fontSize: 20),
                                    ))),
                          ),
                        ),
                      ],
                    ),
                    //Stack 1: Container for background card
                  ]),
                ],
              ),
            ),
          ]
        ),
      ),
    ));
  }
}
