import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Login_Screen.dart';
//import 'package:delivery/map_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  var orderstream;
  // final loc.Location location = loc.Location();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getcart();
    super.initState();
  }

  getcart() async {
    this.orderstream = await getuserorders();
    setState(() {});
  }

  Future<Stream<QuerySnapshot>> getuserorders() async {
    return FirebaseFirestore.instance
        .collection("Payments")
        //.where("status", isNotEqualTo: "Done")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: orderstream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        final now = map['ts'].toDate();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(now);
                        final String formattedTime =
                            DateFormat.Hms().format(now);
                        if (map['type'] != "Recharge" &&
                            map['type'] != "Failure") {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xfffe0c00d),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Text(formatted,
                                                    style: const TextStyle(
                                                        color: Colors.white))),
                                            const Spacer(),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: const BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Text(
                                                    "  " + formattedTime,
                                                    //'${DateTime.parse(map['ts'].toDate().toString())}',
                                                    style: const TextStyle(
                                                        color: Colors.white))),
                                          ],
                                        ),
                                        //    SizedBox(height: 10),

                                        //    children: map['orderlist']
                                        //   .list((e) =>
                                        Container(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          height: 60,
                                          // width: 10,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            itemCount: map['orderlist'].length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                // decoration: BoxDecoration(
                                                //     color: Colors.black),
                                                alignment: Alignment.topLeft,
                                                //  height: 100,
                                                //    width: 100,
                                                child: Chip(
                                                  label: Text(
                                                      map['orderlist'][index],
                                                      // '${e['name']}  X ${e['count']}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 10),
                                        Row(children: [
                                          const Text(
                                            "Total:",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "₹" + ' ${map['amount']}',
                                          ),
                                          const Spacer(),
                                          Text(
                                            ' ${map['mode']}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ]),
                                        const SizedBox(height: 20),
                                        Row(children: [
                                          Flexible(
                                            flex: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                //  _listenlocation(map);

                                                // MapUtils.openMap(
                                                //     map['latitude'],
                                                //     map['longitude']);
                                              },
                                              child: Container(
                                                  // width:
                                                  //     MediaQuery.of(context)
                                                  //             .size
                                                  //             .width *
                                                  //         0.35,
                                                  height: 42,
                                                  child: Center(
                                                      child: Text(
                                                    ' ${map['orderid']}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  )),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xfffe0c00d),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xfffe0c00d),
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5)))),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Flexible(
                                            flex: 3,
                                            child: GestureDetector(
                                              onTap: () async => await launch(
                                                  "tel://" +
                                                      "+${int.parse(map['Phone'])}"),
                                              child: Container(
                                                  // width:
                                                  //     MediaQuery.of(context)
                                                  //             .size
                                                  //             .width *
                                                  //         0.4,
                                                  height: 42,
                                                  child: const Center(
                                                      child: Text(
                                                    "Call",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xfffe0c00d),
                                                    ),
                                                  )),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xfffe0c00d),
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5)))),
                                            ),
                                          ),
                                        ])
                                      ]),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                            ),
                          );
                        } else {
                          return Divider();
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
