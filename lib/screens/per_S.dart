import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String nw = "";
  @override
  void initState() {
    _name();
    certData();
    super.initState();
  }

  Future<List> certData() async {
    final _nu = await supabase.auth.currentUser!.id;
    final certd =
        await supabase.from('organization').select('*').textSearch('uid', _nu);
    print(certd);
    return certd;
  }

  void _name() async {
    final nu = supabase.auth.currentUser!.id;
    final nv = await supabase
        .from('everyone')
        .select('username')
        .textSearch('uid', nu);
    setState(() {
      nw = nv[0]['username'];
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
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Bannerb(),
          SingleChildScrollView(
            child: Column(
              children: [
                WelcomeT(name: nw),
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
                        FutureBuilder(
                          future: certData(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(snapshot.error.toString()));
                            }

                            if (snapshot.hasData) {
                              if (snapshot.data.length == 0) {
                                return Center(
                                  child: Text("Empty"),
                                );
                              }
                              return Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, int index) {
                                      var stuff = snapshot.data[index];
                                      var namee = stuff['certname'];
                                      var link =
                                          stuff['certificate'].toString();
                                      var timee = stuff['created_at'];
                                      var orgg = stuff['orgname'];

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: secondary,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text(
                                                "$namee",
                                                style:
                                                    TextStyle(color: primary),
                                                textAlign: TextAlign.start,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$orgg",
                                                    style: TextStyle(
                                                        color: primary),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    "$timee",
                                                    style: TextStyle(
                                                        color: primary),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  Icons.download,
                                                  color: primary,
                                                ),
                                                onPressed: () {
                                                  Downloader()
                                                      .download(namee, link);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
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
