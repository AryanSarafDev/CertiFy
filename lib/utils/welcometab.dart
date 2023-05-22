import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants.dart';

class WelcomeT extends StatefulWidget {
  final String name;
  WelcomeT({Key? key, required this.name}) : super(key: key);

  @override
  State<WelcomeT> createState() => _WelcomeTState();
}

class _WelcomeTState extends State<WelcomeT> {
  final SupabaseClient supabase = Supabase.instance.client;

  late double logbuttonshadow = 2;

  late double logbuttonpress = 20;
  late double logbuttonside = 20;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: secondary,
              borderRadius:
                  BorderRadiusDirectional.only(bottomEnd: Radius.circular(90))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                      color: primary, fontSize: 50, fontFamily: 'Markbold'),
                ),
                Text(
                  "${widget.name}!",
                  style: TextStyle(
                      color: primary, fontSize: 30, fontFamily: 'Markbold'),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
              top: logbuttonpress, bottom: 20, left: 20, right: logbuttonside),
          child: Container(
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: third,
                  spreadRadius: logbuttonshadow,
                  offset: Offset(-3, 5),
                )
              ],
            ),
            child: IconButton(
              onPressed: () async {
                Timer(Duration(milliseconds: 400), () async {
                  if(widget.name!="Guest"&&widget.name!="Sign-in"&&widget.name!="Sign-up")
                  await supabase.auth.signOut();
                  else
                    Get.back();
                });

                setState(() {
                  logbuttonshadow = -4;
                  logbuttonpress = 30;
                  logbuttonside = 24;

                });
                Timer(Duration(milliseconds: 200), () {
                  setState(() {
                    logbuttonshadow = 2;
                    logbuttonpress = 20;
                    logbuttonside = 20;
                  });
                });
              },
              icon: Icon(
                Icons.logout,
              ),
              color: primary,
            ),
          ),
        )
      ],
    );
  }
}

class Bannerb extends StatelessWidget {
  const Bannerb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius:
            BorderRadiusDirectional.vertical(bottom: Radius.circular(120)),
        child: Image.asset(
          "assets/images/leaf.png",
          colorBlendMode: BlendMode.overlay,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

Future<String> Displayname() async {
  var supabase = Supabase.instance.client;
  final nu = supabase.auth.currentUser!.id;

  final nv =
      await supabase.from('everyone').select('username').textSearch('oid', nu);

  return nv[0]['username'];
}

Future<String> DisplaynameUser() async {
  var supabase = Supabase.instance.client;
  final nu = supabase.auth.currentUser!.id;

  final nv =
      await supabase.from('everyone').select('username').textSearch('uid', nu);

  return nv[0]['username'];
}
class Backbutton extends StatefulWidget {
  const Backbutton({Key? key}) : super(key: key);


  @override
  State<Backbutton> createState() => _BackbuttonState();

}

class _BackbuttonState extends State<Backbutton> {
  late double logbuttonshadow = 2;

  late double logbuttonpress = 20;
  late double logbuttonside = 20;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: logbuttonpress, bottom: 20, left: 20, right: logbuttonside),
      child: Container(
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: third,
              spreadRadius: logbuttonshadow,
              offset: Offset(-3, 5),
            )
          ],
        ),
        child: IconButton(
          onPressed: () async {
            Timer(Duration(milliseconds: 400), () async {
              Get.back();
            });

            setState(() {
              logbuttonshadow = -4;
              logbuttonpress = 30;
              logbuttonside = 24;

            });
            Timer(Duration(milliseconds: 200), () {
              setState(() {
                logbuttonshadow = 2;
                logbuttonpress = 20;
                logbuttonside = 20;
              });
            });
          },
          icon: Icon(
            Icons.logout,
          ),
          color: primary,
        ),
      ),
    );
  }
}
