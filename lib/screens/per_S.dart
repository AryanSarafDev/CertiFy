import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/certListing.dart';

import '../utils/constants.dart';
import '../utils/downloader.dart';
import '../utils/welcometab.dart';

class PerS extends StatefulWidget {
  const PerS({Key? key}) : super(key: key);

  @override
  State<PerS> createState() => _PerSState();
}

class _PerSState extends State<PerS> {
  final SupabaseClient supabase = Supabase.instance.client;
  String displayname = "";
  var certData;

  @override
  void initState() {
    setname();
    certData=certificateDataforUser();
    super.initState();
  }


  void setname() async {
    var recieve = await DisplaynameUser();
    setState(() {
      displayname = recieve;
    });
    setState(() {});
  }

  @override
  void dispose() {
    supabase.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Bannerb(),
          SingleChildScrollView(
            child: Column(
              children: [
                WelcomeT(name: displayname),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Container(
                    height: 600,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Certificates Recieved",
                                style: TextStyle(
                                    color: third,
                                    fontSize: 20,
                                    fontFamily: 'Markbold'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: Icon(Icons.refresh_outlined),
                              color: third,
                            )
                          ],
                        ),
                        UserList(certdata: certData)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
