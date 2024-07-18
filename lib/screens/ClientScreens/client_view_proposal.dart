import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:project_skillcrow/screens/Chat/client%20side%20Chat.dart';
import 'package:project_skillcrow/screens/ClientScreens/proposals_view_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/send_contract.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class ClientViewProposal extends StatefulWidget {
  const ClientViewProposal({super.key});

  @override
  State<ClientViewProposal> createState() => _ClientViewProposalState();
}

class _ClientViewProposalState extends State<ClientViewProposal> {
  double receive = CrudFunction.cl_thatProposal['BidAmount'] -
      (0.1 * CrudFunction.cl_thatProposal['BidAmount']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposal"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProposalsViewScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: AutoSizeText(
                  CrudFunction.cl_thatJob['JobTitle'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  minFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                CrudFunction.cl_thatJob['JobDescription'],
                style: TextStyle(fontSize: 16),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Proposed Terms",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Total price of the project: \$${CrudFunction.cl_thatJob['Budget']}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Bid Amount: \$${CrudFunction.cl_thatProposal['BidAmount']}",
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
                CrudFunction.cl_thatProposal['CoverLetter'],
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
                  if (CrudFunction.thatProposal['ContractSent'] != true)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print("Send Contract");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => SendContract()),
                            ),
                          );
                        },
                        child: Text(
                          'Send Contract',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(
                              0, 201, 104, 1), // Background color
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Contract Sent',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(
                              255, 117, 117, 117), // Background color
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        print("Send Message");
                        String sess = CrudFunction
                                .cl_thatProposal['ClientUsername'] +
                            CrudFunction.cl_thatProposal['FreelancerUsername'] +
                            CrudFunction.cl_thatProposal['_id'].toString();
                       // await fetching.getChatDataBySession(sess);

                        await CrudFunction.filterchat(sess);
                        print(CrudFunction.chatfind);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientSideChatScreen(
                              checkclientfreelancer: 'Client',
                              proposalidget: CrudFunction.cl_thatProposal['_id']
                                  .toString(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Send Message',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(0, 201, 104, 1), // Background color
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (CrudFunction.thatProposal['ContractSent'] != true)
                ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      CrudFunction.DeclineProposal(
                          CrudFunction.cl_thatProposal['_id'],
                          CrudFunction.cl_thatJob['_id']);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProposalsViewScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Decline Proposal',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromRGBO(201, 0, 0, 1), // Background color
                    ),
                  ),
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
        CrudFunction.cl_thatProposal['Files'] != null &&
                CrudFunction.cl_thatProposal['Files'].isNotEmpty
            ? ListView.builder(
                shrinkWrap: true, // Important to prevent infinite height
                itemCount: CrudFunction.cl_thatProposal['Files'].length,
                itemBuilder: (context, index) {
                  final file = CrudFunction.cl_thatProposal['Files'][index];
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
