import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Login_Screen.dart';
import 'package:delivery/local_notification_service.dart';
import 'package:delivery/map_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var orderstream;
  final loc.Location location = loc.Location();
  FirebaseAuth _auth = FirebaseAuth.instance;

  // storeNotificationToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  //       .set({'token': token}, SetOptions(merge: true));
  // }

  @override
  void initState() {
    // storeNotificationToken();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNOtificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    setState(() {
      //  this.cartitem = getuser();
    });
    super.initState();
    location.changeSettings(
        interval: 10000, accuracy: loc.LocationAccuracy.low);
    location.enableBackgroundMode(enable: true);
    getcart();
  }

  // @override
  // void initState() {

  //   super.initState();
  // }

  getcart() async {
    this.orderstream = await getuserorders();
    setState(() {});
  }

  sendNotification(String title, String token, String body) async {
    final data = {
      'click_action': 'FLUTTER-NOTIFICATION-CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key = AAAA1qfklY4:APA91bEU_UMUeh08DO3_bupmVBwd22WdGdJslhZm9v0CsjMXMMtL8reCiLPvMqhYCkDR6YFEnMj0WUGgHvxuhgOO96ni_mHMa2mHwbjmi3UMTpuo1cWdzyh6oQtLRrVmT3F9GGBWBlEs',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
          'priority': 'high',
          'data': data,
          'to': token,
        }),
      );

      if (response.statusCode == 200) {
        print("yeh notification sended");
      } else {
        print("nah");
        print(response.statusCode);
      }
    } catch (e) {
      print("mm");
      print('e.message');
    }
  }

  Future<Stream<QuerySnapshot>> getuserorders() async {
    return FirebaseFirestore.instance
        .collection("Orders")
        //.where("status", isNotEqualTo: "Done")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  // final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  _stoplistening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  Future<void> _listenlocation(dynamic map) async {
    // location.changeSettings().
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentloctaion) async {
      print("abcd" + map['orderid']);
      {
        if (map['orderid'] != "") {
          await FirebaseFirestore.instance
              .collection("Orders")
              .doc(map['orderid'])
              .update({
            "driverlat": currentloctaion.latitude,
            "driverlong": currentloctaion.longitude,
            "deliveredby": FirebaseAuth.instance.currentUser!.phoneNumber
          });

          await FirebaseFirestore.instance
              .collection("users")
              .doc(map["Phone"])
              .collection("orders")
              .doc(map['orderid'])
              .update({
            "driverlat": currentloctaion.latitude,
            "driverlong": currentloctaion.longitude,
            "deliveredby": FirebaseAuth.instance.currentUser!.phoneNumber
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
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
            SingleChildScrollView(
              //   height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("Phonenumber",
                        isEqualTo:
                            FirebaseAuth.instance.currentUser!.phoneNumber)
                    // .doc(widget.map['orderid'])
                    .snapshots(),
                //   initialData: initialData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // print("abcd");
                  //  print(snapshot.data.docs[0]['amount']);

                  if (!snapshot.hasData) {
                    return Container(
                      child: Text("y"),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs[0]['approved'] == "yes")
                  // snapshot.data!.docs[0]['approved'] == "") {
                  // return Container();
                  {
                    return StreamBuilder(
                        stream: orderstream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                final now = map['ts'].toDate();
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd');
                                final String formatted = formatter.format(now);
                                final String formattedTime =
                                    DateFormat.Hms().format(now);
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .where("Phonenumber",
                                            isEqualTo: map['Phone'])
                                        // .doc(widget.map['orderid'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snap) {
                                      String? token;
                                      try {
                                        token = snap.data!.docs[0]['token'];
                                        print(token);
                                      } catch (e) {
                                        print(e);
                                      }
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2.0,
                                                  spreadRadius: 0.0,
                                                  offset: Offset(2.0,
                                                      2.0), // shadow direction: bottom right
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xfffe0c00d),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Text(
                                                                formatted,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                        // Container(
                                                        //   child: Text(
                                                        //     token ?? "no",
                                                        //     style: TextStyle(
                                                        //         color: Colors
                                                        //             .black),
                                                        //   ),
                                                        // ),
                                                        Spacer(),
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Text(
                                                                "  " +
                                                                    formattedTime,
                                                                //'${DateTime.parse(map['ts'].toDate().toString())}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                      ],
                                                    ),
                                                    //    SizedBox(height: 10),

                                                    //    children: map['orderlist']
                                                    //   .list((e) =>
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      height: 60,
                                                      // width: 10,
                                                      width: double.infinity,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            map['orderlist']
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            // decoration: BoxDecoration(
                                                            //     color: Colors.black),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            //  height: 100,
                                                            //    width: 100,
                                                            child: Chip(
                                                              label: Text(
                                                                  map['orderlist']
                                                                      [index],
                                                                  // '${e['name']}  X ${e['count']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
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
                                                        "₹" +
                                                            ' ${map['amount']}',
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
                                                    map['status'] != "Accepted"
                                                        ? Row(
                                                            children: [
                                                              Flexible(
                                                                flex: 3,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    _listenlocation(
                                                                        map);

                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "Orders")
                                                                        .doc(map[
                                                                            'orderid'])
                                                                        .update({
                                                                      "status":
                                                                          "Accepted",
                                                                      "deliveredby": FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .phoneNumber
                                                                    });

                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(map[
                                                                            "Phone"])
                                                                        .collection(
                                                                            "orders")
                                                                        .doc(map[
                                                                            'orderid'])
                                                                        .update({
                                                                      "status":
                                                                          "Accepted",
                                                                      "deliveredby": FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .phoneNumber
                                                                    });

                                                                    if (token !=
                                                                        null) {
                                                                      sendNotification(
                                                                          "Your",
                                                                          token,
                                                                          "Order has been accepted");
                                                                    }

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
                                                                      child: const Center(
                                                                          child: Text(
                                                                        "Accept",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                      decoration: BoxDecoration(
                                                                          color: const Color(0xfffe0c00d),
                                                                          border: Border.all(
                                                                            color:
                                                                                const Color(0xfffe0c00d),
                                                                          ),
                                                                          borderRadius: const BorderRadius.all(Radius.circular(5)))),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(children: [
                                                            Flexible(
                                                              flex: 3,
                                                              child:
                                                                  GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .translucent,
                                                                onTap: () {
                                                                  try {
                                                                    _listenlocation(
                                                                        map);

                                                                    MapUtils.openMap(
                                                                        map['latitude'],
                                                                        map['longitude']);
                                                                  } catch (e) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(e as String)));
                                                                  }
                                                                },
                                                                child: Container(
                                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                                    height: 42,
                                                                    child: const Center(
                                                                        child: Text(
                                                                      "Directions",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                    decoration: BoxDecoration(
                                                                        color: const Color(0xfffe0c00d),
                                                                        border: Border.all(
                                                                          color:
                                                                              const Color(0xfffe0c00d),
                                                                        ),
                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)))),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 3,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _stoplistening();

                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "Orders")
                                                                      .doc(map[
                                                                          "orderid"])
                                                                      .delete();

                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(map[
                                                                          "Phone"])
                                                                      .collection(
                                                                          "orders")
                                                                      .doc(map[
                                                                          'orderid'])
                                                                      .update({
                                                                    "status":
                                                                        "Done",
                                                                    "deliveredby": FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .phoneNumber
                                                                  });

                                                                  if (token !=
                                                                      null) {
                                                                    sendNotification(
                                                                        "Your",
                                                                        token,
                                                                        "Order has been delivered");
                                                                  }
                                                                },
                                                                child: Container(
                                                                    margin: EdgeInsets.all(8.0),
                                                                    // width:
                                                                    //     MediaQuery.of(context)
                                                                    //             .size
                                                                    //             .width *
                                                                    //         0.35,
                                                                    height: 42,
                                                                    child: const Center(
                                                                        child: Text(
                                                                      "Delivered",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                    decoration: BoxDecoration(
                                                                        color: const Color(0xfffe0c02d),
                                                                        border: Border.all(
                                                                          color:
                                                                              const Color(0xfffe0c00d),
                                                                        ),
                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Flexible(
                                                              flex: 3,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () async =>
                                                                    await launch(
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
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Color(
                                                                            0xfffe0c00d),
                                                                      ),
                                                                    )),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        border: Border.all(
                                                                          color:
                                                                              const Color(0xfffe0c00d),
                                                                        ),
                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)))),
                                                              ),
                                                            ),
                                                          ])
                                                  ]),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                        ),
                                      );
                                    });
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs[0]['approved'] == "no") {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Avaiting permission",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
