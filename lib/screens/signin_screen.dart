import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/home_screen.dart';
import 'package:project_skillcrow/screens/signup_screen.dart';
import 'package:project_skillcrow/server.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
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
                logoWidget("assets/images/pic_signin.png"),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Let's Login.",
                    style: TextStyle(fontSize: 58, fontWeight: FontWeight.w900),
                  ),
                ),
                const Text(
                  "Explore with cleverness",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  //Login Function call
                  LoginFunc();
                }),
                signUpOption(),
              ],
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

  void LoginFunc() async {
    bool isV = await CrudFunc.LoginUser(
        _userNameTextController.text, _passwordTextController.text);

    print("isVal is: ${isV}");
    //Conditions
    if (isV == true) {
      print("All ok!!!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else if (isV == false) {
      print("All not ok!!!");
    } else {
      print("nothing is ok!!!");
    }
  }
}
