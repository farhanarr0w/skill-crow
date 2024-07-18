import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_signup_screen.dart';
import 'package:project_skillcrow/screens/forget_password.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class ClientSignIn extends StatefulWidget {
  const ClientSignIn({super.key});

  @override
  State<ClientSignIn> createState() => _ClientSignInState();
}

class _ClientSignInState extends State<ClientSignIn> {
  final TextEditingController _passwordTextController = TextEditingController();
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
                      "Providing Opportunity?",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Login and Get your work Done.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                  const SizedBox(
                    height: 20,
                  ),
                  forgetPassword(),
                  signInSignUpButton(context, true, () {
                    //Login Function call
                    if (_formKey.currentState!.validate()) {
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

  void LoginFunc() async {
    print("Client Login Function!!!!");

    bool isV = await CrudFunction.LoginClient(
        _userNameTextController.text.toLowerCase(),
        _passwordTextController.text);
    if (isV == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ClientHome(),
        ),
      );
    } else if (isV == false) {
      show(context, "Either username or password is wrong", "error");
    } else {
      print("nothing is ok!!!");
    }
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
                MaterialPageRoute(builder: (context) => const ClientSignUp()));
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
                    builder: (context) =>
                        const ForgetPassword(isClient: true)));
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
}
