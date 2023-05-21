import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


import 'constants.dart';
class WelcomeT extends StatelessWidget {
  final String name;
   WelcomeT({Key? key,
    required this.name}) : super(key: key);
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Container(decoration: BoxDecoration(color: secondary,borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(90))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  "$name!",
                  style: TextStyle(
                      color: primary,
                      fontSize: 30,
                      fontFamily: 'Markbold'),
                ),
              ],
            ),
          ),
        ),

        Spacer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(decoration: BoxDecoration(color: secondary,borderRadius:  BorderRadius.circular(90),boxShadow:  [BoxShadow(
            color: third,

            spreadRadius: 2 ,
            offset: Offset(-3, 5),

          )
          ],
          ),

            child: IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
              },
              icon: Icon(Icons.logout),
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
      child: ClipRRect(borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(120)),

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

  final nv = await supabase
      .from('everyone')
      .select('username')
      .textSearch('oid', nu);

  return nv[0]['username'];
}
Future<String> DisplaynameUser() async {
  var supabase = Supabase.instance.client;
  final nu = supabase.auth.currentUser!.id;

  final nv = await supabase
      .from('everyone')
      .select('username')
      .textSearch('uid', nu);

  return nv[0]['username'];
}



