// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/forget_password.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/signup_screen.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

import 'navigiationforalert.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isHiddenPassword = true;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
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
                  logoWidget("assets/images/pic_signin.png"),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Let's Login.",
                      style:
                          TextStyle(fontSize: 58, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Explore with cleverness",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Username Textfield
                  Username_SigninField(_userNameTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Password Textfield
                  Password_SigninField(_passwordTextController),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  forgetPassword(),
                  signInSignUpButton(context, true, () {
                    //Login Function call

                    if (_formKey.currentState!.validate()) {
                      print("Login function");
                      LoginFunc();
                    }
                  }),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            "Don't have account?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              " create an account",
              style: TextStyle(
                color: Color.fromRGBO(0, 255, 132, 1),
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  Row forgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
          child: Text(
            "Forget your password?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgetPassword(
                          isClient: false,
                        )));
          },
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: Text(
              " click here",
              style: TextStyle(
                color: Color.fromRGBO(0, 255, 132, 1),
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  void LoginFunc() async {
    bool isV = await CrudFunction.LoginUser(
        _userNameTextController.text.toLowerCase(),
        _passwordTextController.text);

    //Conditions
    if (isV == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FreelancerHomeScreen(),
        ),
      );
    } else if (isV == false) {
      show(context, "Either username or password is wrong", "error");
    } else {
      print("nothing is ok!!!");
    }
  }
}
