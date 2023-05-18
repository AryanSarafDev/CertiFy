import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/screens/per_S.dart';

import 'org_S.dart';
class NavigateS extends StatefulWidget {
  const NavigateS({Key? key}) : super(key: key);

  @override
  State<NavigateS> createState() => _NavigateSState();
}

class _NavigateSState extends State<NavigateS> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    certData();
    super.initState();
  }

  Future<List> certData() async {
    final idd = supabase.auth.currentUser!.email;
    final boolc = await supabase
        .from('everyone')
        .select('*')
        .textSearch('email', idd!);
    print(boolc);
    return boolc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: certData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var stuff = snapshot.data[0];
    switch (snapshot.connectionState) {

      case ConnectionState.none:return Center(child: CircularProgressIndicator());
      case ConnectionState.waiting:
        return Center(child: CircularProgressIndicator());
        break;
      default:
        if (snapshot.hasData) {
          print("applee");
          print(stuff);
          var orga = stuff['isorg'];
          var pers = stuff['isper'];
          var veri = stuff['isver'];
          if (orga)
            return orgS();
          else if (pers) return PerS();
          return orgS();
        }else
          return Center(child: CircularProgressIndicator());


        return Center(child: CircularProgressIndicator());
    } }),
    );
  }
}
