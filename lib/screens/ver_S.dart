import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';

class ver_S extends StatefulWidget {
  const ver_S({Key? key}) : super(key: key);

  @override
  State<ver_S> createState() => _ver_SState();
}

class _ver_SState extends State<ver_S> {
  final SupabaseClient supabase = Supabase.instance.client;
  String nw = "";
  @override
  void initState() {
    _name();
    super.initState();
  }

  void _name() async {
    print("apple");
    final nu = await supabase.auth.currentUser!.id;
    final nv = await supabase
        .from('everyone')
        .select('username')
        .textSearch('uid', nu);
    setState(() async {
      nw = await nv[0]['username'];
      setState(() {});
    });
  }

  @override
  void dispose() {
    supabase.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                            color: primary,
                            fontSize: 60,
                            fontFamily: 'Markbold'),
                      ),
                      Text(
                        "$nw",
                        style: TextStyle(
                            color: primary,
                            fontSize: 60,
                            fontFamily: 'Markbold'),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await supabase.auth.signOut();
                },
                icon: Icon(Icons.logout),
                color: primary,
              )
            ],
          ),
        ],
      ),
    );
  }
}
