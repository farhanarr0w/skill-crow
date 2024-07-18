import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_signin_screen.dart';
import 'package:project_skillcrow/screens/email_verification_screen.dart';
import 'package:project_skillcrow/server.dart';

class ClientSignUp extends StatefulWidget {
  const ClientSignUp({super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _catTextController = TextEditingController();
  final TextEditingController _confirmPassTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false; //For email validation

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
                  const Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "Create New Client Account",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Get the best services in best rates",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Username Textfield
                  Username_SignUPField(_userNameTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Name Textfield
                  FirstName_SignUPField(_firstNameTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  LastName_SignUPField(_lastNameTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Email Textfield
                  Email_SignUPField(_emailTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Phone Textfield
                  Phone_SignUPField(_phoneTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Password Textfield
                  Password_SignUPField(_passwordTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Confirm Password Textfield
                  ConfirmPassword_SignUPField(_confirmPassTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  signInSignUpButton(context, false, () {
                    //Signup Function call
                    if (_formKey.currentState!.validate()) {
                      SignUpFunc();
                    }
                  }),
                  signInOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void SignUpFunc() async {
    int uF = await CrudFunction.ClientFinder(
        _userNameTextController.text, _emailTextController.text);
    _isValid = EmailValidator.validate(_emailTextController.text);
    if (uF == 1) {
      show(context, "Username is taken", "error");
    } else if (uF == 2) {
      show(
          context,
          "Email you entered is already registered to another account",
          "error");
    } else if (_phoneTextController.text[0] != "0" ||
        _phoneTextController.text[1] != "3") {
      show(context, "Enter Valid Phone Number", "error");
    } else {
      if (!_isValid) {
        show(context, "Enter Valid Email", "error");
      } else {
        if (_passwordTextController.text == _confirmPassTextController.text) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Email_Verification(
                        email1: _emailTextController.text,
                        userName: _userNameTextController.text,
                        firstName: _firstNameTextController.text,
                        lastName: _lastNameTextController.text,
                        category: _catTextController.text,
                        password: _passwordTextController.text,
                        contactno: int.parse(_phoneTextController.text),
                        check: false,
                        isClient: true,
                      )));
        } else {
          show(
              context, "Password and Confirm Password does not match", "error");
        }
      }
    }
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
                MaterialPageRoute(builder: (context) => const ClientSignIn()));
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
