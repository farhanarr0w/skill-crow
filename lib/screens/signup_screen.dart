import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/home_screen.dart';
import 'package:project_skillcrow/screens/signin_screen.dart';
import 'package:project_skillcrow/server.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
                  ),
                ),
                const Text(
                  "Explore with cleverness inside you",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Username", Icons.person_outline, false,
                    _userNameTextController, "email"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Email", Icons.mail_outline, false, _emailTextController, "email"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Password", Icons.lock_outline, true,
                    _passwordTextController, "password"),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  //Insert Function Call
                  CrudFunc.Insert(_userNameTextController.text,
                      _emailTextController.text, _passwordTextController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                }),
                signInOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            "Already have an account?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              " Login",
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
}
