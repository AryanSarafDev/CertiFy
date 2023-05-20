import 'package:flutter/material.dart';

import 'constants.dart';
import 'downloader.dart';

    class ListCert extends StatefulWidget {
      Future<List<dynamic>> a;

      ListCert({Key? key, required this.a}) : super(key: key);
    
      @override
      State<ListCert> createState() => _ListCertState();
    }
    
    class _ListCertState extends State<ListCert> {
  get a => null;

      @override
      Widget build(BuildContext context) {
        return FutureBuilder(
          future: a,
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
        );
      }
    }
    