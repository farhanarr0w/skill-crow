import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_signin_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/details_input_screen.dart';
import 'package:project_skillcrow/screens/email_verification_screen.dart';
import 'package:project_skillcrow/screens/forget_password.dart';
import 'package:project_skillcrow/server.dart';
import 'emailOTP.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineSmall,  //it was headline6
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String email1, userName, firstName, lastName, category, password;
  final int contactno;
  final bool check, isClient;
  OtpScreen(
      {Key? key,
      required this.myauth,
      required this.email1,
      required this.userName,
      required this.category,
      required this.password,
      required this.contactno,
      required this.check,
      required this.isClient,
      required this.firstName,
      required this.lastName})
      : super(key: key);
  final EmailOTP myauth;
  @override
  State<OtpScreen> createState() => _OtpScreenState(email1, userName, firstName,
      lastName, category, password, contactno, check, isClient);
}

class _OtpScreenState extends State<OtpScreen> {
  String email1, userName, firstName, lastName, category, password;
  int contactno;
  bool check, isClient;
  _OtpScreenState(this.email1, this.userName, this.firstName, this.lastName,
      this.category, this.password, this.contactno, this.check, this.isClient);
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/logo_icon/Skill Crow-01.png",
                height: 350,
              ),
            ),
            const Icon(Icons.dialpad_rounded, size: 50),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Verification",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter verification code number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Otp(
                  otpController: otp1Controller,
                ),
                Otp(
                  otpController: otp2Controller,
                ),
                Otp(
                  otpController: otp3Controller,
                ),
                Otp(
                  otpController: otp4Controller,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                if (await widget.myauth.verifyOTP(
                        otp: otp1Controller.text +
                            otp2Controller.text +
                            otp3Controller.text +
                            otp4Controller.text) ==
                    true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("OTP is verified"),
                  ));
                  if (check) {
                    //means user has forget the password
                    print("Check is: ${check}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen(
                                  isClient: isClient,
                                )));
                  } else {
                    //means user is creating account
                    print("Check is: ${check}");
                    if (isClient) {
                      await CrudFunction.InsertClient("", userName, email1,
                          password, contactno, firstName, lastName, 0 ,0 ,0 ,0 , "", "", "", "", "",[]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClientSignIn()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsInputScreen(
                                    userName: userName,
                                    eMail: email1,
                                    passWord: password,
                                    firstName: firstName,
                                    lastName: lastName,
                                    workCat: category,
                                    phone: contactno,
                                  )));
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid OTP"),
                  ));
                }
              },
              child: const Text(
                'Verify',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arvo'),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromRGBO(0, 255, 132, 1);
                  }
                  return const Color.fromRGBO(0, 255, 132, 1);
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FittedBox(
                  child: Text(
                    "Didn't Recieve Email? ",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Email_Verification(
                          email1: email1,
                          userName: userName,
                          firstName: firstName,
                          lastName: lastName,
                          category: category,
                          password: password,
                          contactno: contactno,
                          check: check,
                          isClient: isClient,
                        );
                      }));
                    },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: Colors.blue),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
