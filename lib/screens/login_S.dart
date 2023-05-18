import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/screens/register_S.dart';
import 'package:supaverify/utils/constants.dart';
import 'package:supaverify/utils/textbox.dart';

import '../controllers/dropController.dart';

class loginS extends StatefulWidget {
  loginS({Key? key}) : super(key: key);

  @override
  State<loginS> createState() => _loginSState();
}

class _loginSState extends State<loginS> {
  final DropCont boolcont = Get.put(DropCont());
  TextEditingController _emailc = new TextEditingController();

  TextEditingController _passc = new TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    supabase.dispose;
    _emailc.dispose();

    _passc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Stack(children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.97,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
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
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () async {
                                  try {
                                    await supabase.auth.signInWithPassword(
                                        password: _passc.text,
                                        email: _emailc.text);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("$e"),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                },
                                child: Text(
                                  "Login",
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
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account yet? ",
                    style: TextStyle(color: fourthdull),
                  ),
                  InkWell(
                      child: Text(
                        "Sign-Up!",
                        style: TextStyle(color: primary),
                      ),
                      onTap: () async {
                        await Get.to(registerS());
                      })
                ]),
          )
        ],
      ),
    ));
  }
}
