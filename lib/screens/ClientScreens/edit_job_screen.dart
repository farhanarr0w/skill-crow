import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/server.dart';

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({super.key});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  List<String> displaySkills =
      CrudFunction.cl_editingJob['SkillsRequired'].whereType<String>().toList();
  List<dynamic> allSkills = CrudFunction.AllSkills;
  String? selectValue;

  final TextEditingController _jobTitle =
      TextEditingController(text: CrudFunction.cl_editingJob['JobTitle']);
  final TextEditingController _jobDescription =
      TextEditingController(text: CrudFunction.cl_editingJob['JobDescription']);
  var _jobCategory;
  var _seedsReq;
  var _expertise;
  final TextEditingController _jobBudget = TextEditingController(
      text: CrudFunction.cl_editingJob['Budget'].toString());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Job"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ClientedJobsView()),
              (route) => false,
            );
          },
        ),
      ),
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
                  const Text(
                    "Edit Job",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Job Title
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Job Title";
                      }
                      return null;
                    },
                    controller: _jobTitle,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      hintText: "Job Title",
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: const Color.fromARGB(255, 221, 221, 221)
                          .withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Job Description
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Job Details";
                      } else if (value.length < 8) {
                        return "Enter atleast 8 characters";
                      }
                      return null;
                    },
                    maxLines: 11,
                    controller: _jobDescription,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Provide some details about your job',
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
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  //Job Category
                  FormBuilderDropdown(
                    autovalidateMode: AutovalidateMode.disabled,
                    name: 'CategoryDropdown',
                    onChanged: (value) {
                      _jobCategory = value;
                      print(_jobCategory);
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
                        Icons.category,
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
                  //Job Budget
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Job Budget";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _jobBudget,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: const Color.fromARGB(255, 221, 221, 221)
                          .withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Seeds Required
                  FormBuilderDropdown(
                    autovalidateMode: AutovalidateMode.disabled,
                    name: 'SeedsDropdown',
                    onChanged: (value) {
                      _seedsReq = value;
                      print(_seedsReq);
                    },
                    decoration: InputDecoration(
                      labelText: 'Seeds Required',
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
                        Icons.category,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: [2, 4, 6, 8]
                        .map((seeds) => DropdownMenuItem(
                            value: seeds, child: Text('${seeds}')))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 30,
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
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 30,
                  ),
                  //Expertise Level
                  FormBuilderDropdown(
                    autovalidateMode: AutovalidateMode.disabled,
                    name: 'ExpertiseDropdown',
                    onChanged: (value) {
                      _expertise = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Expertise Level',
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
                        Icons.run_circle,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: ['Beginner', 'Intermediate', 'Expert']
                        .map((level) => DropdownMenuItem(
                            value: level, child: Text('${level}')))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 210,
                    height: 60,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((90)),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        var bsonDate = DateTime.fromMillisecondsSinceEpoch(
                            now.millisecondsSinceEpoch,
                            isUtc: true);

                        if (_formKey.currentState!.validate()) {
                          if (displaySkills.isEmpty) {
                            show(context, "Enter Required Skills", "error");
                          } else {
                            await CrudFunction.editJob(
                                CrudFunction.cl_editingJob['_id'],
                                _jobTitle.text,
                                _jobDescription.text,
                                _jobCategory,
                                int.parse(_jobBudget.text),
                                _seedsReq,
                                displaySkills,
                                _expertise,
                                bsonDate);
                            await CrudFunction.searchJobsByClient(
                                CrudFunction.ClientFind['UserName']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        ClientedJobsView())));
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color.fromRGBO(0, 255, 132, 1);
                          }
                          return const Color.fromRGBO(0, 255, 132, 1);
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Update Job",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
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
