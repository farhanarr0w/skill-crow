import 'package:flutter/material.dart';

import '../server.dart';
import '../user_fetch.dart';
import 'FreelancerScreens/edit_profile_freelancer.dart';

class chnagePassword extends StatefulWidget {
  const chnagePassword({Key? key}) : super(key: key);

  @override
  State<chnagePassword> createState() => _chnagePasswordState();
}

class _chnagePasswordState extends State<chnagePassword> {
  bool isHiddenPassword = true;
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController newpasswordController =
      new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();
  String password = '';
  String newpassword = '';
  String confirmPassword = '';
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  GlobalKey<FormState> _FormKey1 = GlobalKey<FormState>();

  String UserName = CrudFunction.UserFind['UserName'];
  String email = CrudFunction.UserFind['Email'];

  @override
  Widget build(BuildContext context) {
    print(UserName);

    return Scaffold(
      body: Form(
        key: _FormKey1,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w900),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_FormKey1.currentState?.validate() == true) {
                            updatePassword(newpassword);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("All fields are required")));
                          }
                        },
                        icon: Icon(Icons.done_outline),
                        color: Color.fromRGBO(0, 255, 132, 1),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            style: const TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: _toggle,
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_rounded),
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: const Color.fromRGBO(117, 117, 117, 1),
                              ),
                              labelText: "Current Password",
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Color.fromARGB(255, 221, 221, 221)
                                  .withOpacity(1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                            ),
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (val) {
                              if (val?.isEmpty == true) {
                                return 'Password is required!';
                              }
                              if (val != CrudFunction.UserFind['Password']) {
                                return 'Incorrect Password';
                              }
                              return null;
                            },
                            obscureText: _obscureText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: newpasswordController,
                            style: const TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: _toggle,
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_rounded),
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: const Color.fromRGBO(117, 117, 117, 1),
                              ),
                              labelText: "New Password",
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Color.fromARGB(255, 221, 221, 221)
                                  .withOpacity(1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                            ),
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              newpassword = value;
                            },
                            validator: (val) {
                              if (val?.isEmpty == true) {
                                return 'Password is required!';
                              }
                              if (val!.length <= 5) {
                                return 'Password length is too short';
                              }
                              if (val.contains(' ') == true) {
                                return 'Space is not allowed';
                              }
                              return null;
                            },
                            obscureText: _obscureText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: confirmPasswordController,
                            style: const TextStyle(
                              color: Color.fromRGBO(117, 117, 117, 1),
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: _toggle,
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_rounded),
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: const Color.fromRGBO(117, 117, 117, 1),
                              ),
                              labelText: "Confirm New Password",
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Color.fromARGB(255, 221, 221, 221)
                                  .withOpacity(1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                            ),
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              confirmPassword = value;
                            },
                            validator: (val) {
                              if (val?.isEmpty == true) {
                                return 'Password is required!';
                              }
                              if (val != newpassword) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            obscureText: _obscureText,
                          ),
                        ),
                      ],
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

  void updatePassword(String _pass) async {
    print("Updating password!!!!");
    CrudFunction.updatepass(UserName, _pass);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const editProfileFreelancer(),
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Password Updated")));
  }
}
