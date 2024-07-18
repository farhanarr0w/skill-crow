import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_signin_screen.dart';
import 'package:project_skillcrow/screens/email_verification_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/signin_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

final TextEditingController _emailTextController = TextEditingController();
final TextEditingController _userNameTextController = TextEditingController();
final TextEditingController _catTextController = TextEditingController();
final TextEditingController _passwordTextController = TextEditingController();
final TextEditingController _phoneTextController = TextEditingController();

class ForgetPassword extends StatefulWidget {
  final bool isClient;
  const ForgetPassword({super.key, required this.isClient});

  @override
  State<ForgetPassword> createState() => ForgetPasswordState(isClient);
}

class ForgetPasswordState extends State<ForgetPassword> {
  bool _isValid = false; //For email validation
  final bool isClient;
  var userValid;

  ForgetPasswordState(this.isClient);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Forget Password?",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Please enter your email to reset your password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Email Textfield
                  Email_SignUPField(_emailTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _isValid =
                          EmailValidator.validate(_emailTextController.text);

                      if (!_isValid) {
                        show(context, "Enter Valid Email", "error");
                      } else {
                        if (isClient) {
                          userValid = CrudFunction.ClientFinder(
                              'username', _emailTextController.text);
                          print(userValid);
                          if (userValid == 2) {
                            print("Client Found: ${userValid}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Email_Verification(
                                          email1: _emailTextController.text,
                                          userName:
                                              _userNameTextController.text,
                                          category: _catTextController.text,
                                          password:
                                              _passwordTextController.text,
                                          contactno: 0,
                                          check: true,
                                          firstName: '',
                                          lastName: '',
                                          isClient: isClient,
                                        )));
                          } else {
                            show(context, "Client Not Found", "error");
                          }
                        } else {
                          userValid = CrudFunction.Finder(
                              'username', _emailTextController.text);
                          if (userValid == 2) {
                            print("User Found: ${userValid}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Email_Verification(
                                          email1: _emailTextController.text,
                                          userName:
                                              _userNameTextController.text,
                                          category: _catTextController.text,
                                          password:
                                              _passwordTextController.text,
                                          contactno: 0,
                                          check: true,
                                          firstName: '',
                                          lastName: '',
                                          isClient: isClient,
                                        )));
                          } else {
                            show(context, "User Not Found", "error");
                          }
                        }
                      }
                    },
                    child: Text(
                      "Enter",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final bool isClient;
  const ResetPasswordScreen({super.key, required this.isClient});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState(isClient);
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _repasswordTextController =
      TextEditingController();
  final bool isClient;

  _ResetPasswordScreenState(this.isClient);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Reset Password?",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Enter new password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Password Textfield
                  Password_SignUPField(_repasswordTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isClient) {
                        print("is Client: ${isClient}");

                        CrudFunction.resetPassword(_emailTextController.text,
                            _repasswordTextController.text, isClient);

                        show(context, "Password Reset Successfull", "success");

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ClientSignIn()));
                      } else {
                        print("is Client: ${isClient}");

                        CrudFunction.resetPassword(_emailTextController.text,
                            _repasswordTextController.text, isClient);

                        show(context, "Password Reset Successfull", "success");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      }
                    },
                    child: Text(
                      "Enter",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
