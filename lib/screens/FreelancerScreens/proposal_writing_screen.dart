import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input_test.dart';
import 'package:open_file/open_file.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/job_card_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

import '../../reusable_widgets/notification_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

List<PlatformFile>? _files;
var toAddFile;
List<Map<String, dynamic>> finalFiles = [];

class ProposalWritingScreen extends StatefulWidget {
  const ProposalWritingScreen({super.key});

  @override
  State<ProposalWritingScreen> createState() => _ProposalWritingScreenState();
}

class _ProposalWritingScreenState extends State<ProposalWritingScreen> {
  final TextEditingController _bidController =
      TextEditingController(text: '${CrudFunction.currentJob!['Budget']}');
  final TextEditingController _coverLetterController = TextEditingController();

  late final LocalNotificationService service;
  final _formKey = GlobalKey<FormState>();

  FilePickerResult? result;
  PlatformFile? pickedFile;
  bool isLoading = false;
  bool isNull = true;
  File? fileToDisply;
  String? base64String;

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      List<PlatformFile> newFiles = result.files;
      // Ensure only new, unique files are added
      var existingPaths = _files?.map((file) => file.path).toSet() ?? {};
      newFiles.removeWhere((file) => existingPaths.contains(file.path));

      setState(() {
        _files = _files ?? [];
        _files!.addAll(newFiles);
      });
    }

    for (var f in _files!) {
      fileToDisply = File(f.path.toString());

      List<int> fileBytes = await fileToDisply!.readAsBytes();
      base64String = base64.encode(fileBytes);

      toAddFile = {
        'Name': f.name,
        'File': base64String,
      };
      finalFiles.add(toAddFile);
    }
  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Proposal"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _files = [];
            finalFiles = [];
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FreelancerJobsApply(
                        search: false,
                        search_word: "",
                      )),
              (route) => false,
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Job Details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "${CrudFunction.currentJob!['JobTitle']}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "${CrudFunction.currentJob!['JobDescription']}",
                style: TextStyle(fontSize: 16),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Terms",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "What amount you'd like to bid for this job?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Bid",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Total amount the client will see on your proposal. Please be assured that there will be 10% Skill Crow service charges.",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your bid";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: _bidController,
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
                  fillColor: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Cover Letter",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "A cover letter is required";
                    }
                    return null;
                  },
                  maxLines: 15,
                  controller: _coverLetterController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor:
                        Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Attachments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        _pickFiles();
                      },
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          color: const Color.fromRGBO(0, 255, 132, 1),
                          fontSize: 16,
                        ),
                      )),
              ViewFiles(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "You may attach files here that include work samples or other documents to support your application. Do not attach your resume — your SkillCrow profile is automatically forwarded to the client with your proposal.",
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        print("Submit Proposal Button Pressed");

                        if (_formKey.currentState!.validate()) {
                          await CrudFunction.SubmitProposal(
                              CrudFunction.currentJob!['_id'],
                              CrudFunction.currentJob!['ClientUsername'],
                              CrudFunction.UserFind!['UserName'],
                              int.parse(_bidController.text),
                              _coverLetterController.text,
                              false,
                              finalFiles);
                          await service.showNotification(
                              id: 0,
                              title: 'Proposal Submitted',
                              body:
                                  'You have successfully submitted proposal for ${CrudFunction.currentJob!['JobTitle']}');

                          await CrudFunction.searchJobsByCategory(
                              CrudFunction.currentJob!['JobCategory']);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerJobsApply(
                                      search: false,
                                      search_word: "",
                                    )),
                            (route) => false,
                          );
                          _files = [];
                          finalFiles = [];
                        }
                        ;
                      },
                      child: Text(
                        "Submit Proposal",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          _files = [];
                          finalFiles = [];
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerJobsApply(
                                      search: false,
                                      search_word: "",
                                    )),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromRGBO(0, 255, 132, 1)),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class ViewFiles extends StatefulWidget {
  const ViewFiles({super.key});

  @override
  State<ViewFiles> createState() => _ViewFilesState();
}

class _ViewFilesState extends State<ViewFiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _files != null && _files!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true, // Important to prevent infinite height
                itemCount: _files!.length,
                itemBuilder: (context, index) {
                  final file = _files![index];
                  return ListTile(
                    title: Text(file.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeFile(index),
                    ),
                    onTap: () {
                      _openFile(file);
                    },
                  );
                },
              )
            : Text(
                'No files attached yet.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ],
    );
  }

  void _removeFile(int index) {
    setState(() {
      _files!.removeAt(index);
      finalFiles.removeAt(index);
    });
  }

  void _openFile(PlatformFile file) {
    print(file);
    OpenFile.open(file.path);
  }
}
