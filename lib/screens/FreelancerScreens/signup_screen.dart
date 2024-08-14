// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart' as Em;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/details_input_screen.dart';
import 'package:project_skillcrow/screens/email_verification_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/signin_screen.dart';
import 'package:project_skillcrow/server.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _confirmPassTextController =
      TextEditingController();
  var _catTextController;
  var exchangeSourceOption = [
    'Design and Creative',
    'Website and Development',
    'Editing and Animation',
    'Banking and Finance',
    'Creative Writing'
  ];
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false; //For email validation

  // String? countryValue = "";
  // String? stateValue = "";
  // String? cityValue = "";

  @override
  Widget build(BuildContext context) {
    CrudFunction.displaySkills = [];
    CrudFunction.AllSkills = [];
    for (var items in Server.SkillsList!) {
      CrudFunction.AllSkills.add(items['SkillName']);
    }
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
                      "Create Account",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Text(
                    "Explore with cleverness inside you",
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
                  FormBuilderDropdown(
                    autovalidateMode: AutovalidateMode.disabled,
                    name: 'exchangesource',
                    onChanged: (value) {
                      _catTextController = value;
                      print(_catTextController);
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                          Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: Server.JobCategoriesList!
                        .map((categories) => DropdownMenuItem(
                            value: categories['CategoryName'],
                            child: Text('${categories['CategoryName']}')))
                        .toList(),
                  ),
                  
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
    int uF = await CrudFunction.Finder(
        _userNameTextController.text.toLowerCase(),
        _emailTextController.text.toLowerCase());

    _isValid = Em.EmailValidator.validate(_emailTextController.text);

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
                        email1: _emailTextController.text.toLowerCase(),
                        userName: _userNameTextController.text.toLowerCase(),
                        firstName: _firstNameTextController.text,
                        lastName: _lastNameTextController.text,
                        category: _catTextController.toString(),
                        password: _passwordTextController.text,
                        contactno: int.parse(_phoneTextController.text),
                        check: false,
                        isClient: false,
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
