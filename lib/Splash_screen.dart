import 'dart:async';
import 'package:location/location.dart';
import 'package:delivery/Login_Screen.dart';
import 'package:delivery/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import 'package:my_kisan/screens/Login_Screen.dart';

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  final Location location = Location();
  PermissionStatus? _permissionGranted;
  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestResult =
          await location.requestPermission();

      setState(() {
        _permissionGranted = permissionRequestResult;
      });
    }
  }

  String? currentuser;
  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _requestPermission();
    // startTime();
  }

  _onlaund() async {
    Timer(const Duration(seconds: 2), () async {
      try {
        currentuser = FirebaseAuth.instance.currentUser!.uid;
        if (currentuser == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (route) => false);
        } else if (currentuser != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BottomBar(0),
              ),
              (route) => false);
        }
      } catch (e) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _onlaund(),
          builder: (context, snapshot) {
            return Stack(
              children: [
                Container(decoration: const BoxDecoration()),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: SvgPicture.asset("assets/icons/logo.svg"),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
