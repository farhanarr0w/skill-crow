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
import 'package:project_skillcrow/screens/ClientScreens/view_all_client_contracts.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/ViewAllContracts_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';
import 'package:project_skillcrow/user_fetch.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../Chat/client side Proposal Chat.dart';

List<PlatformFile>? _files;
var toAddFile;
List<Map<String, dynamic>> finalFiles = [];

class ClientContractDetailsScreen extends StatefulWidget {
  const ClientContractDetailsScreen({super.key});

  @override
  State<ClientContractDetailsScreen> createState() =>
      _ClientContractDetailsScreenState();
}

class _ClientContractDetailsScreenState
    extends State<ClientContractDetailsScreen> {
  final _formKey =
      GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var reviewController = new TextEditingController();
  var ratingController;
  FilePickerResult? result;
  PlatformFile? pickedFile;
  bool isLoading = false;
  bool isNull = true;
  File? fileToDisply;
  String? base64String;

  @override
  Widget build(BuildContext context) {
    CrudFunction.cl_thatFreelancer = Server.FreelancersList!.firstWhereOrNull(
        (user) =>
            user['UserName'] == CrudFunction.jobContract['FreelancerUsername']);
    CrudFunction.cl_thatJob = Server.JobPostsList!.firstWhereOrNull(
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
              MaterialPageRoute(builder: (context) => ViewAllClientContracts()),
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
          String sess = CrudFunction.jobContract['ClientUsername'] +
              CrudFunction.jobContract['FreelancerUsername'] +
              CrudFunction.jobContract['ProposalID'].toString();
          print(sess);
          //await fetching.getChatDataBySession(sess);
          await CrudFunction.filterchat(sess);
          print(CrudFunction.chatfind);
          await CrudFunction.getProposals(
              CrudFunction.jobContract['ProposalID']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientSideChatScreen(
                checkclientfreelancer: 'Client',
                proposalidget:
                    CrudFunction.jobContract['ProposalID'].toString(),
              ),
            ),
          );
        },
      ),
      ]
    ],

          if (CrudFunction.jobContract['ContractStatus'] != "completed") ...[
            if (CrudFunction.jobContract['EscrowAmount'] == 0) ...[
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () async {
                  String? selected = await _showPopupMenu(context);
                  print(selected);

                  if (selected == 'endContract') {
                    showGeneralDialog(
                      barrierLabel: "Show Image",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 700),
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return Center(
                          child: SizedBox(
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 50, left: 12, right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Scaffold(
                                  body: Center(
                                    child: Column(children: [
                                      FormBuilder(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 0,
                                              bottom: 20),
                                          child: Column(children: [
                                            FormBuilderTextField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: reviewController,
                                              name: 'Comments',
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                  labelText: 'Enter Comments'),
                                              validator: FormBuilderValidators
                                                  .compose([
                                                FormBuilderValidators.required()
                                              ]),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Select Rating :',
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            RatingBar.builder(
                                              itemSize: 35,
                                              initialRating: 1,
                                              minRating: 0.5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.blueAccent,
                                              ),
                                              onRatingUpdate: (rating) {
                                                ratingController = rating;
                                                print(rating);
                                              },
                                            ),
                                          ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ClientContractDetailsScreen()));
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return const Color.fromRGBO(
                                                        0, 255, 132, 1);
                                                  }
                                                  return const Color.fromRGBO(
                                                      0, 255, 132, 1);
                                                }),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                String contractid = CrudFunction
                                                    .jobContract['_id']
                                                    .toString();
                                                String freelancerUserName =
                                                    CrudFunction.jobContract[
                                                        'FreelancerUsername'];
                                                String ClientUsername =
                                                    CrudFunction.jobContract[
                                                        'ClientUsername'];
                                                String Clientname = CrudFunction
                                                            .ClientFind[
                                                        'FirstName'] +
                                                    CrudFunction
                                                        .ClientFind['LastName'];
                                                insertreviews(
                                                    contractid,
                                                    freelancerUserName,
                                                    Clientname,
                                                    ClientUsername,
                                                    reviewController.text,
                                                    ratingController);
                                              },
                                              child: const Text(
                                                "Send & End the Contract",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return const Color.fromRGBO(
                                                        0, 255, 132, 1);
                                                  }
                                                  return const Color.fromRGBO(
                                                      0, 255, 132, 1);
                                                }),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                  .animate(anim1),
                          child: child,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ],
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
                        "Your refund request has been approved by the Freelancer.",
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
                        "Your refund request has been declined by the Freelancer. Our support will look into this matter, it may take 3 to 4 business days until we come up with any verdict, thank you for your patience",
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
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "You have requested the refund, please wait for freelancer to approve your refund",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                  ],
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
                        CrudFunction.cl_thatFreelancer['FirstName'],
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
                '${CrudFunction.cl_thatJob['JobTitle']}',
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
                                'Amount paid',
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
                      onPressed: () {},
                      child: Text(
                        "${CrudFunction.cl_thatFreelancer['FirstName']} hasn't submitted the work yet",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "${CrudFunction.cl_thatFreelancer['FirstName']} have submitted the work",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                  ],
                ),
              if (CrudFunction.jobContract['SubmissionStatus'] != 'pending')
                SizedBox(
                  height: 20,
                ),
              ViewFiles(),
              if (CrudFunction.jobContract['ContractStatus'] ==
                  "completed") ...[
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

                  // (CrudFunction.ClientFind['Reviews'].length>0)
                    // for (var reviews in CrudFunction.ClientFind['Reviews'])
                    //   if (reviews['contractID'] ==
                    //       CrudFunction.jobContract['_id'].toString()) ...[
                    //     Card(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(15.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Job Title: ${CrudFunction.cl_thatJob['JobTitle']}",
                    //               textAlign: TextAlign.left,
                    //             ),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text("${reviews['Name']}"),
                    //                 RatingBarIndicator(
                    //                   rating:
                    //                       double.tryParse(reviews['rating']) ??
                    //                           0.0,
                    //                   itemCount: 5,
                    //                   itemSize: 15,
                    //                   itemBuilder: (context, _) => Icon(
                    //                     Icons.star,
                    //                     color: Colors.amber,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 5,
                    //             ),
                    //             SizedBox(
                    //               height: 5,
                    //             ),
                    //             Text(
                    //               "${reviews['comment']}",
                    //               textAlign: TextAlign.left,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     )
                    //   ]
                    
                    ],
                ),
              ],
              SizedBox(
                height: 20,
              ),
              if (CrudFunction.jobContract['EscrowAmount'] != 0 &&
                  CrudFunction.jobContract['ContractStatus'] !=
                      'refundRequested' &&
                  CrudFunction.jobContract['ContractStatus'] !=
                      'refundDeclined' &&
                  CrudFunction.jobContract['ContractStatus'] !=
                      'refundApproved')
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        print("Requesting Refund");

                        CrudFunction.requestRefund(
                            CrudFunction.jobContract['_id']);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllClientContracts()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Request Refund",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Text color matching the original background color
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 201, 104,
                              1), // Border color matching the original background color
                          width: 1, // You can adjust the width as needed
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          print('AP Btn Pressed');

                          CrudFunction.approvePayment(
                              CrudFunction.jobContract['FreelancerUsername'],
                              CrudFunction.jobContract['ClientUsername'],
                              CrudFunction.jobContract['_id'],
                              CrudFunction.jobContract['EscrowAmount']);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllClientContracts()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Approve Payment",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(
                              0, 201, 104, 1), // Background color
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void insertreviews(
    String contractid,
    String freelancerUserName,
    String Name,
    String ClientUsername,
    String comment,
    double rating,
  ) async {
    print(freelancerUserName +
        Name +
        ClientUsername +
        comment +
        rating.toString());
    print("Inserting Reviews");
    CrudFunction.insertReviews(contractid, freelancerUserName, Name,
        ClientUsername, comment, rating.toString());
    CrudFunction.contractCompleted(CrudFunction.jobContract['_id']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientContractDetailsScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reviews inserted & Contract Ended")),
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
