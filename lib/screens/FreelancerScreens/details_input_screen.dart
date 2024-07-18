import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class DetailsInputScreen extends StatefulWidget {
  final String userName, eMail, passWord, firstName, lastName, workCat;
  final int phone;
  const DetailsInputScreen(
      {super.key,
      required this.userName,
      required this.eMail,
      required this.passWord,
      required this.firstName,
      required this.lastName,
      required this.workCat,
      required this.phone});

  @override
  State<DetailsInputScreen> createState() => _DetailsInputScreenState(
      userName, eMail, passWord, firstName, lastName, workCat, phone);
}

class _DetailsInputScreenState extends State<DetailsInputScreen> {
  final TextEditingController _aboutTextController = TextEditingController();

  final TextEditingController _educationTextController =
      TextEditingController();
  final TextEditingController _languageTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final String userName, eMail, passWord, firstName, lastName, workCat;
  final int phone;
  _DetailsInputScreenState(this.userName, this.eMail, this.passWord,
      this.firstName, this.lastName, this.workCat, this.phone);

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  final TextEditingController _countryTextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _stateTextController = TextEditingController();

  List<String> displaySkills = CrudFunction.displaySkills;
  List<dynamic> allSkills = CrudFunction.AllSkills;
  String? selectValue;

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
                      "Enter Details Please",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //About Textfield
                  AboutField(_aboutTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  //Country Textfield
                  CSCPicker(
                    showStates: true,
                    showCities: true,
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color:
                            Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
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
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    dropdownDialogRadius: 10.0,
                    searchBarRadius: 10.0,
                    onCountryChanged: (value) {
                      countryValue = value;
                      print("country: " + countryValue!);
                    },
                    onStateChanged: (value) {
                      stateValue = value;
                    },
                    onCityChanged: (value) {
                      cityValue = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Skills Required

                  FormBuilderDropdown(
                    autovalidateMode: AutovalidateMode.disabled,
                    name: 'SkillsDropdown',
                    onChanged: (value) {
                      setState(() {
                        displaySkills.add(value.toString());
                        allSkills.remove(value);
                        selectValue = allSkills.isNotEmpty &&
                                selectValue != allSkills.first
                            ? allSkills.first
                            : null;
                        displaySkills.isEmpty
                            ? SkillsDisplay(
                                displaySkills: displaySkills,
                                allSkills: allSkills,
                                onSkillRemoved: (skill) {
                                  setState(() {
                                    displaySkills.remove(skill);

                                    allSkills.add(skill);
                                  });
                                },
                              )
                            : null;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Skills Required',
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
                        Icons.handyman,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                    initialValue: selectValue,
                    items: allSkills
                        .map((skills) => DropdownMenuItem(
                            value: skills, child: Text('$skills')))
                        .toList(),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Tap on the skill to remove it from the list',
                        style: TextStyle(color: Colors.black),
                      )),
                  //Skills View

                  SkillsDisplay(
                    displaySkills: displaySkills,
                    allSkills: allSkills,
                    onSkillRemoved: (skill) {
                      setState(() {
                        displaySkills.remove(skill);

                        allSkills.add(skill);
                      });
                    },
                  ),
                  CompleteProfileButton(context, () {
                    //Signup Function call
                    if (_formKey.currentState!.validate()) {
                      CompleteProfileFunc();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void CompleteProfileFunc() async {
    print("Complete Profile Button Pressed!!!");
    await CrudFunction.InsertFreelancer(
        '',
        userName.toLowerCase(),
        eMail.toLowerCase(),
        passWord,
        phone,
        firstName,
        lastName,
        workCat,
        'none',
        0,
        false,
        0,
        0,
        0,
        0,
        _aboutTextController.text,
        displaySkills,
        countryValue,
        cityValue,
        stateValue,
        [],
        [],
        [],
        50,[],[]);

    await Server.refresh();
    await CrudFunction.LoginUser(userName, passWord);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
}

class SkillsDisplay extends StatefulWidget {
  final List<String> displaySkills;
  final List<dynamic> allSkills;
  final Function(String) onSkillRemoved;

  SkillsDisplay({
    Key? key,
    required this.displaySkills,
    required this.allSkills,
    required this.onSkillRemoved,
  }) : super(key: key);

  @override
  State<SkillsDisplay> createState() => _SkillsDisplayState();
}

class _SkillsDisplayState extends State<SkillsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 218, 218, 218),
        borderRadius: BorderRadius.circular(0), // Border radius
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10.0, // spacing between chips
        runSpacing: 5.0, // spacing between rows
        children: [
          for (var index in widget.displaySkills)
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.onSkillRemoved(index);
                });
              },
              child: Chip(label: Text(index)),
            ),
        ],
      ),
    );
  }
}
