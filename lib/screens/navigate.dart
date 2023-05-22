import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/screens/per_S.dart';
import 'package:supaverify/screens/ver_S.dart';
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
    final boolc =
        await supabase.from('everyone').select('*').textSearch('email', idd!);
    print(boolc);
    return boolc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: certData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var stuff = snapshot.data[0];
              //segregating pages
              print(stuff);
              var orga = stuff['isorg'];
              var pers = stuff['isper'];
              var veri = stuff['isver'];
              if (orga)
                return orgS();
              else if (pers)
                return PerS();
              else  return ver_S();

            }
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
