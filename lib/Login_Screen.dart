import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Otp_screen.dart';

import 'package:delivery/Signup_Screen.dart';
import 'package:delivery/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentstate =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phonenumbercontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationid;
  bool showloading = false;

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: Height / 3,
                width: Width,
                decoration: const BoxDecoration(
                    color: whitedark,
                    borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(80))),
              ),
              Positioned(
                bottom: 35,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: const BoxDecoration(
                      color: yellowcolor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(80))),
                ),
              ),
              Positioned(
                bottom: 70,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: const BoxDecoration(
                      color: Color(0xfff35751f),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(80))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -380,
                child: Container(
                  margin: const EdgeInsets.only(left: 60),
                  height: Height * 0.5,
                  width: Width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 33,
                            color: const Color(0xffd3d3d3).withOpacity(.90))
                      ]),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const Text(
                    "Hello,Welcome back to our\naccount please login with your\nphone number",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            height: Height / 20,
                            width: Width * 0.6 + 10,
                            child: TextFormField(
                              validator: mobilevalidtor,
                              keyboardType: TextInputType.number,
                              controller: phonenumbercontroller,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textcolorgrey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  prefixStyle:
                                      const TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 140,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: MaterialButton(
                      height: Height / 20,
                      minWidth: Width * 0.6 + 10,
                      onPressed: () async {
                        setState(() {
                          showloading = true;
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('Phonenumber',
                                isEqualTo: "+91" + phonenumbercontroller.text)
                            .get()
                            .then((value) => {
                                  if (value.docs.isNotEmpty)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return OtpScreen(
                                              userInfoMap: {},
                                              phonenumber: "+91" +
                                                  phonenumbercontroller.text,
                                              firstname: '',
                                            );
                                          },
                                        ),
                                      ),
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please Signup First',
                                            style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 0.5),
                                          ),
                                        ),
                                      ),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const SignupScreen();
                                          },
                                        ),
                                      )
                                    }
                                });
                      },
                      color: const Color(0xfffeda704),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Login",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    //  margin: EdgeInsets.only(top: 35),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: orangecolor),
                          ),
                          GestureDetector(
                            child: const Text(
                              "  Click here",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: orangecolor),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? mobilevalidtor(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
