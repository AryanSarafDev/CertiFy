import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/VerifierBox.dart';
import 'package:supaverify/utils/uploadd.dart';

import '../utils/constants.dart';
import '../utils/hashcalc.dart';
import '../utils/textbox.dart';
import '../utils/welcometab.dart';

class ver_S extends StatefulWidget {
  const ver_S({Key? key}) : super(key: key);

  @override
  State<ver_S> createState() => _ver_SState();
}

class _ver_SState extends State<ver_S> {
  final SupabaseClient supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [Stack(children: [
          Bannerb(),
          Column(
            children: [WelcomeT(name: "Guest"),VerifierBox()
            ]),]
    ),
      ]));
  }
}
