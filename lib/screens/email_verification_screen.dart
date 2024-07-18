import 'package:flutter/material.dart';

import 'OTP/codeinfo_screen.dart';
import 'OTP/emailOTP.dart';

class Email_Verification extends StatefulWidget {
  final String email1, userName, firstName, lastName, category, password;
  final int contactno;
  final bool check, isClient;

  const Email_Verification({
    Key? key,
    required this.email1,
    required this.userName,
    required this.category,
    required this.password,
    required this.contactno,
    required this.check,
    required this.firstName,
    required this.lastName,
    required this.isClient,
  }) : super(key: key);

  @override
  State<Email_Verification> createState() => _Email_VerificationState(
      email1,
      userName,
      firstName,
      lastName,
      category,
      password,
      contactno,
      check,
      isClient);
}

class _Email_VerificationState extends State<Email_Verification> {
  String email1, userName, firstName, lastName, category, password;
  int contactno;
  bool check, isClient;
  _Email_VerificationState(
      this.email1,
      this.userName,
      this.firstName,
      this.lastName,
      this.category,
      this.password,
      this.contactno,
      this.check,
      this.isClient);
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                "assets/logo_icon/Skill Crow-01.png",
                height: 250,
                width: 250,
              ),
              const SizedBox(
                height: 50,
                child: Text(
                  "We'll send OTP to the email address you entered for verification",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Container(
                      width: 210,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          taptap();
                        },
                        child: Text(
                          'Send OTP',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color.fromARGB(255, 4, 209, 110);
                            }
                            return const Color.fromRGBO(0, 255, 132, 1);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void taptap() async {
    myauth.setConfig(
        appEmail: "aleemonline2001@gmail.com",
        appName: "Skill Crow",
        userEmail: email1,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                  email1: email1,
                  userName: userName,
                  firstName: firstName,
                  lastName: lastName,
                  category: category,
                  password: password,
                  contactno: contactno,
                  check: check,
                  isClient: isClient,
                  myauth: myauth)));
    } else {
      print("otp not sent");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP failed"),
      ));
    }
  }
}
