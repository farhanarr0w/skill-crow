import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:csc_picker/csc_picker.dart';

///Color: const Color.fromRGBO(0, 255, 132, 1)
Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 180,
    height: 180,
  );
}

Container Btn(BuildContext context, String InputText, Function onTap) {
  return Container(
    width: 120,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular((90)),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        InputText,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

CSCPicker Country_Picker(TextEditingController _countryTextController) {
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  return CSCPicker(
    showStates: true,
    showCities: true,
    dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
        border: Border.all(color: Colors.grey.shade300, width: 1)),
    countrySearchPlaceholder: "Country",
    stateSearchPlaceholder: "State",
    citySearchPlaceholder: "City",
    countryDropdownLabel: "*Country",
    stateDropdownLabel: "*State",
    cityDropdownLabel: "*City",
    selectedItemStyle: TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    dropdownHeadingStyle: TextStyle(
        color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
    dropdownItemStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    dropdownDialogRadius: 10.0,
    searchBarRadius: 10.0,
    onCountryChanged: (value) {
      countryValue = value;
      _countryTextController.text = value.toString();
    },
    onStateChanged: (value) {
      stateValue = value;
    },
    onCityChanged: (value) {
      cityValue = value;
    },
  );
}

///////////////////////////
///////////////////////////
///SIGNIN TEXT FIELDS
TextFormField Username_SigninField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Username";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.person_outline,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "Username",
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
  );
}

TextFormField Password_SigninField(TextEditingController controller) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter the Password";
        }
        return null;
      },
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Color.fromRGBO(117, 117, 117, 1),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outline,
          color: const Color.fromRGBO(117, 117, 117, 1),
        ),
        labelText: "Password",
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
      ));
}
///////////////////////////
///////////////////////////

///////////////////////////
//////////////////////////
///SIGNUP TEXT FIELDs
TextFormField Username_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Username";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.card_travel_outlined,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "Username",
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
  );
}

TextFormField FirstName_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter First Name";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.person_4_outlined,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "First Name",
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
  );
}

TextFormField LastName_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Last Name";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.person_4_outlined,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "Last Name",
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
  );
}

TextFormField Category_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Working Category";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.work_outline,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "Working Category",
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
  );
}

TextFormField Password_SignUPField(TextEditingController controller) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter the Password";
        }
        return null;
      },
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Color.fromRGBO(117, 117, 117, 1),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outline,
          color: const Color.fromRGBO(117, 117, 117, 1),
        ),
        labelText: "Password",
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
      ));
}

TextFormField Email_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Email";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.mail_outline,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      labelText: "Email",
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
    keyboardType: TextInputType.emailAddress,
  );
}

TextFormField Phone_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Phone";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.phone,
        color: const Color.fromRGBO(117, 117, 117, 1),
      ),
      hintText: '03XX-XXXXXXX',
      labelStyle: const TextStyle(
        color: Color.fromRGBO(3, 3, 3, 1),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(11), // Adjust the length as needed
    ],
    keyboardType: TextInputType.phone,
  );
}

TextFormField ConfirmPassword_SignUPField(TextEditingController controller) {
  return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "ReEnter Password";
        }
        return null;
      },
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Color.fromRGBO(117, 117, 117, 1),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outline,
          color: const Color.fromRGBO(117, 117, 117, 1),
        ),
        labelText: "Confirm Password",
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
      ));
}

TextFormField AboutField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter About";
      } else if (value.length < 200) {
        return "About should be more than 200 charactes";
      }
      return null;
    },
    maxLines: 11,
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      hintText: 'Tell us a bit about yourself...',
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
  );
}

// TextFormField Country_SignUPField(TextEditingController controller) {
//   return TextFormField(
//     validator: (value) {
//       if (value!.isEmpty) {
//         return "Enter Country Name";
//       }
//       return null;
//     },
//     controller: controller,
//     cursorColor: Colors.white,
//     style: const TextStyle(
//       color: Color.fromRGBO(117, 117, 117, 1),
//     ),
//     decoration: InputDecoration(
//       hintText: "Country",
//       labelStyle: const TextStyle(
//         color: Color.fromRGBO(117, 117, 117, 1),
//       ),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30),
//         borderSide: const BorderSide(width: 0, style: BorderStyle.none),
//       ),
//     ),
//   );
// }

TextFormField Education_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Education";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      hintText: "Education",
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
  );
}

TextFormField Language_SignUPField(TextEditingController controller) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return "Enter Language";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.white,
    style: const TextStyle(
      color: Color.fromRGBO(117, 117, 117, 1),
    ),
    decoration: InputDecoration(
      hintText: "Language",
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
  );
}

///
Container Phone_SignUPField1() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 221, 221, 221), // Set the fill color here
    ),
    child: InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print(number.phoneNumber); // You can use the entered phone number
      },
      onInputValidated: (bool value) {
        print(value);
      },
      selectorConfig: SelectorConfig(
        useEmoji: true,
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(
        color: Color.fromRGBO(117, 117, 117, 1),
      ),
      textFieldController: TextEditingController(),
      initialValue: PhoneNumber(isoCode: 'PK'),
      formatInput: false,
      inputDecoration: InputDecoration(
        contentPadding: EdgeInsets.all(20.0),
        hintText: '3XX-XXXXXXX',
        border: OutlineInputBorder(
          borderSide: BorderSide.none, // Set the borderSide to none
        ),
        filled: true,
        fillColor: Colors.transparent,
      ), // Set the fill color here
    ),
  );
}

//////////////////////////////
//////////////////////////////
Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
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

Container CompleteProfileButton(BuildContext context, Function onTap) {
  return Container(
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
        "Complete Profile",
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, String message, String type) {
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
