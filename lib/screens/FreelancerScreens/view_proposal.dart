import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_proposals.dart';
import 'package:collection/collection.dart';
import 'package:project_skillcrow/server.dart';

class ViewProposal extends StatefulWidget {
  const ViewProposal({super.key});

  @override
  State<ViewProposal> createState() => _ViewProposalState();
}

class _ViewProposalState extends State<ViewProposal> {
  double receive = CrudFunction.fr_thatProposal['BidAmount'] -
      (0.1 * CrudFunction.fr_thatProposal['BidAmount']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Proposal"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreelancerProposals()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (CrudFunction.fr_thatProposal['ProposalStatus'] == 'declined')
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 228, 228, 228), // Background color
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                          'This proposal has been declined by the client',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(201, 0, 0, 1))),
                    ),
                  ),
                ),
              Text(
                "Job Details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: AutoSizeText(
                  CrudFunction.fr_thatJob['JobTitle'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  minFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CrudFunction.fr_thatJob['JobDescription'],
                style: TextStyle(fontSize: 16),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Your Proposed Terms",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Total price of the project: \$${CrudFunction.fr_thatJob['Budget']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Bid Amount: \$${CrudFunction.fr_thatProposal['BidAmount']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "You'll Receive: \$${receive}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Cover Letter",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                CrudFunction.fr_thatProposal['CoverLetter'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Attachments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ViewFiles(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  if (CrudFunction.fr_thatProposal['ProposalStatus'] !=
                      'declined')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await CrudFunction.WithdrawProposal(
                              CrudFunction.fr_thatProposal);

                          CrudFunction.filterProposals(
                              CrudFunction.UserFind['UserName']);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FreelancerProposals()));
                        },
                        child: Text(
                          'Withdraw Proposal',
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
        CrudFunction.fr_thatProposal['Files'] != null &&
                CrudFunction.fr_thatProposal['Files'].isNotEmpty
            ? ListView.builder(
                shrinkWrap: true, // Important to prevent infinite height
                itemCount: CrudFunction.fr_thatProposal['Files'].length,
                itemBuilder: (context, index) {
                  final file = CrudFunction.fr_thatProposal['Files'][index];
                  return InkWell(
                    onTap: () {
                      openFile(file['Name'], file['File']);
                    },
                    child: ListTile(
                      title: Text(
                        file['Name'],
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  );
                },
              )
            : Text(
                'No files attached.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ],
    );
  }

  Future<void> openFile(String fileName, String fileData) async {
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
