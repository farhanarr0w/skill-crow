import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 180,
    height: 180,
  );
}

TextFormField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, String typeOfTextField) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        if (typeOfTextField.toLowerCase() == "username") {
          return "Please enter user name";
        } else if (typeOfTextField.toLowerCase() == "password") {
          return "Please enter password";
        } else if (typeOfTextField.toLowerCase() == "email") {
          return "Please enter email";
        }
      }
      return null;
    },
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: text,
      labelStyle: const TextStyle(
        color: Color.fromRGBO(117, 117, 117, 1),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    //width: MediaQuery.of(context).size.width,
    width: 210,
    height: 60,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular((90)),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'Login' : 'Create Account',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(BuildContext context, String message, String type) {
  
  Color backgroundColor = Colors.red;
  if (type == "success") {
    backgroundColor = Colors.green;
  }

  if (type == "warning") {
    backgroundColor = Colors.yellow;
  }

  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: Text(
      message,
      style: const TextStyle(color: Colors.white),
    )),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    width: 300 * 0.9,
  ));
}
