import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/ViewAllContracts_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';
import 'package:project_skillcrow/user_fetch.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Chat/freelancer side chat.dart';

List<PlatformFile>? _files;
var toAddFile;
List<Map<String, dynamic>> finalFiles = [];

class ContractsDetailsScreen extends StatefulWidget {
  const ContractsDetailsScreen({super.key});

  @override
  State<ContractsDetailsScreen> createState() => _ContractsDetailsScreenState();
}

class _ContractsDetailsScreenState extends State<ContractsDetailsScreen> {
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
  Widget build(BuildContext context) {
    CrudFunction.fr_thatClient = Server.ClientsList!.firstWhereOrNull(
        (client) =>
            client['UserName'] == CrudFunction.jobContract['ClientUsername']);
    CrudFunction.fr_thatJob = Server.JobPostsList!.firstWhereOrNull(
        (job) => job['_id'] == CrudFunction.jobContract['JobID']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract Room'),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _files = [];
            finalFiles = [];
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ViewAllContractsScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
           if (CrudFunction.jobContract['ProposalID'] != 'Invited Contract')
             for(var chat in Server.chatlist!)...[
               if(chat['ProposalId'].toString() == CrudFunction.jobContract['ProposalID'].toString())...[
                 IconButton(
                   icon: Icon(Icons.message),
                   onPressed: () async {
                     String _proposalid =
                     CrudFunction.jobContract['ProposalID'].toString();
                     String sess = CrudFunction.jobContract['ClientUsername'] +
                         CrudFunction.jobContract['FreelancerUsername'] +
                         CrudFunction.jobContract['ProposalID'].toString();
                     print(sess);
                     print(_proposalid);
                     await CrudFunction.filterchat(sess);
                     print(CrudFunction.chatfind);
                     //await fetching.getChatDataBySession(sess);
                     //print(fetching.chatdataget['Date']);
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => FreelancerSideChatScreen(
                           checkclientfreelancer: 'Freelancer',
                           proposalidget: _proposalid,
                         ),
                       ),
                     );
                   },
                 ),
               ]
             ],
          // if (CrudFunction.jobContract['EscrowAmount'] == 0)
          //   IconButton(
          //     icon: Icon(Icons.more_vert),
          //     onPressed: () async {
          //       String? selected = await _showPopupMenu(context);
          //       print(selected);
          //
          //       if (selected == 'endContract') {
          //         showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return AlertDialog(
          //               title: Text('End Contract'),
          //               content: Text('Do you want to end this contract?'),
          //               actions: <Widget>[
          //                 TextButton(
          //                   onPressed: () async {
          //                     print("ended");
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: Text('End'),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     print("cancel");
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: Text('Cancel'),
          //                 ),
          //               ],
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (CrudFunction.jobContract['ContractStatus'] ==
                  'refundApproved')
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "You Approved the refund",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                    )),
                  ],
                ),
              if (CrudFunction.jobContract['ContractStatus'] ==
                  'refundDeclined')
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Our support will look into this matter, it may take 3 to 4 business days until we come up with any verdict, thank you for your patience",
                        style: TextStyle(
                          color: Color.fromRGBO(196, 218, 51,
                              1), // Text color matching the original background color
                        ),
                      ),
                    )),
                  ],
                ),
              if (CrudFunction.jobContract['ContractStatus'] ==
                  'refundRequested')
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Client requested the refund",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 201, 104,
                                  1), // Text color matching the original background color
                            ),
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              print('Approve Btn Pressed');

                              CrudFunction.approveRefund(
                                  CrudFunction.jobContract["_id"]);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewAllContractsScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Approve Refund",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(
                                  0, 201, 104, 1), // Background color
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextButton(
                          onPressed: () {
                            print("Decline Refund");

                            CrudFunction.declineRefund(
                                CrudFunction.jobContract["_id"]);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewAllContractsScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "Decline",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 201, 104,
                                  1), // Text color matching the original background color
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // Transparent background
                            side: const BorderSide(
                              color: Color.fromRGBO(0, 201, 104, 1),
                              // Border color matching the original background color
                              width: 1, // You can adjust the width as needed
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CrudFunction.fr_thatClient['FirstName'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Canada · Sat 7:14 PM',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              AutoSizeText(
                '${CrudFunction.fr_thatJob['JobTitle']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                minFontSize: 20,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 255, 132, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Overview',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total earnings',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '\$${CrudFunction.jobContract['AmountPaid']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Project price',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$${CrudFunction.jobContract['ProjectPrice']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'In escrow',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$${CrudFunction.jobContract['EscrowAmount']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (CrudFunction.jobContract['SubmissionStatus'] == 'pending')
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        _pickFiles();
                      },
                      child: const Text(
                        "Upload any files",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104, 1),
                          // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await CrudFunction.submitWork(
                              CrudFunction.jobContract['_id'], finalFiles);

                          await CrudFunction.filterContracts(
                              CrudFunction.UserFind['UserName']);

                          _files = [];
                          finalFiles = [];

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewAllContractsScreen()));
                        },
                        child: const Text(
                          "Submit Work",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(
                              0, 201, 104, 1), // Background color
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Work submitted",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104, 1),
                          // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              ViewFiles(),
              if (CrudFunction.jobContract['ContractStatus'] == "completed")
                Column(
                  children: [
                    Text(
                      "Your Review",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    for (var reviews in CrudFunction.UserFind['Reviews'])
                      if (reviews['contractID'] ==
                          CrudFunction.jobContract['_id'].toString()) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Title: ${CrudFunction.fr_thatJob['JobTitle']}",
                                  textAlign: TextAlign.left,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${reviews['Name']}"),
                                    RatingBarIndicator(
                                      rating:
                                          double.tryParse(reviews['rating']) ??
                                              0.0,
                                      itemCount: 5,
                                      itemSize: 15,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${reviews['comment']}",
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        )
                      ]
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _showPopupMenu(BuildContext context) async {
  final selection = await showMenu(
    color: Colors.white,
    context: context,
    position:
        RelativeRect.fromLTRB(20, 80, 0, 0), // Positioning of the popup menu
    items: [
      PopupMenuItem(
        value: 'endContract',
        child: Text('End Contract'),
      )
    ],
    elevation: 8.0,
  );

  // Handle your action (if any) here
  return selection;
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
        if (CrudFunction.jobContract['SubmissionStatus'] != 'submitted')
          ListView.builder(
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
        else if (CrudFunction.jobContract['SubmittedFiles'] != null)
          ListView.builder(
            shrinkWrap: true, // Important to prevent infinite height
            itemCount: CrudFunction.jobContract['SubmittedFiles']!.length,
            itemBuilder: (context, index) {
              final file = CrudFunction.jobContract['SubmittedFiles']![index];
              return ListTile(
                title: Text(file['Name']),
                onTap: () {
                  openSubmittedFile(file['Name'], file['File']);
                },
              );
            },
          )
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

  Future<void> openSubmittedFile(String fileName, String fileData) async {
    // Decode the base64 encoded file data
    List<int> bytes = base64.decode(fileData);

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/$fileName';

    // Write the decoded data to a temporary file
    await File(tempFilePath).writeAsBytes(bytes);

    // Open the temporary file using the open_file package
    await OpenFile.open(tempFilePath);
  }
}
