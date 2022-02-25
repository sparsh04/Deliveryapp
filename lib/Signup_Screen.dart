import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Login_Screen.dart';
import 'package:delivery/Otp_screen.dart';
import 'package:delivery/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  MobileVerificationState currentstate =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phonenumbercontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationi;
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
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(80))),
              ),
              Positioned(
                bottom: 35,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: const BoxDecoration(
                      color: yellowcolor,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80))),
                ),
              ),
              Positioned(
                bottom: 70,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: const BoxDecoration(
                      color: Color(0xfff35751f),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Signup",
                          style: TextStyle(
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
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: Height / 20,
                          width: Width * 0.6 + 10,
                          child: TextFormField(
                            controller: firstnamecontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: "  Enter your First Name",
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
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: Height / 20,
                          width: Width * 0.6 + 10,
                          child: TextFormField(
                            controller: lastnamecontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: "  Enter your Last Name",
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
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: Height / 20,
                          width: Width * 0.6 + 10,
                          child: TextFormField(
                            controller: phonenumbercontroller,
                            validator: mobilevalidtor,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: MaterialButton(
                      height: Height / 20,
                      minWidth: Width * 0.6 + 10,
                      onPressed: () async {
                        if (phonenumbercontroller.text != "" &&
                            lastnamecontroller != "" &&
                            firstnamecontroller != "") {
                          setState(() {
                            showloading = true;
                          });

                          Map<String, String> userInfoMap = {
                            "Firstname": firstnamecontroller.text,
                            "lastname": lastnamecontroller.text,
                            "Fullname": firstnamecontroller.text +
                                lastnamecontroller.text,
                            "Phonenumber": "+91" + phonenumbercontroller.text,
                            'photourl':
                                'https://i0.wp.com/i1.wp.com/clarkstontolldentalpractice.com/wp-content/uploads/2020/06/default-img-2-1.jpg',
                            'uid': '',
                          };

                          final snapshot = await FirebaseFirestore.instance
                              .collection("users")
                              .doc("+91" + phonenumbercontroller.text)
                              .get();

                          if (phonenumbercontroller.text.length < 10 ||
                              phonenumbercontroller.text.length > 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter a Valid Number")));
                          } else if (snapshot.exists &&
                              phonenumbercontroller.text.length == 10) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "User Already Exists . Login Please")));
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                        userInfoMap: userInfoMap,
                                        phonenumber:
                                            "+91" + phonenumbercontroller.text,
                                        firstname: firstnamecontroller.text +
                                            lastnamecontroller.text,
                                      )),
                            );
                          }

                          //   await Navigator.pushNamed(context, "/BottomBar");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Fill up the Details Please")));
                        }
                      },
                      color: const Color(0xfffeda704),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    //  margin: EdgeInsets.only(top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: orangecolor),
                        ),
                        GestureDetector(
                          child: const Text(
                            " Click here",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: orangecolor),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        ),
                      ],
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
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
