import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';

import 'package:bson/src/classes/object_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_view_proposal.dart';
import 'package:project_skillcrow/screens/ClientScreens/send_contract.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

import '../Chat/client side Chat.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ProposalsViewScreen extends StatefulWidget {
  const ProposalsViewScreen({super.key});

  @override
  State<ProposalsViewScreen> createState() => _ProposalsViewScreenState();
}

class _ProposalsViewScreenState extends State<ProposalsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        title: Text("Proposals"),
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
      body: Container(
        child: ListView.builder(
          itemCount: CrudFunction.filteredProposals!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(1, 2),
                  )
                ],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: ListTile(
                title: Text(CrudFunction.filteredProposals![index]
                    ['FreelancerUsername']),
                tileColor: Color.fromARGB(255, 255, 255, 255),
                leading: Icon(Icons.book_online),
                onTap: () {
                  CrudFunction.thatProposal =
                      Server.ProposalsList?.firstWhereOrNull((proposal) =>
                          proposal['_id'] ==
                          CrudFunction.filteredProposals![index]['_id']);

                  bottomsheets(
                      context,
                      CrudFunction.filteredProposals![index]
                          ['FreelancerUsername'],
                      CrudFunction.filteredProposals![index]['ClientUsername'],
                      CrudFunction.filteredProposals![index]['CoverLetter'],
                      CrudFunction.filteredProposals![index]['BidAmount'],
                      CrudFunction.filteredProposals![index]['_id'],
                      CrudFunction.filteredProposals![index]['JobID'],
                      CrudFunction.filteredProposals![index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

void bottomsheets(
    context,
    String FreelancerUsername,
    String ClientUsername,
    String CoverLetter,
    int BidAmount,
    mongo.ObjectId id,
    mongo.ObjectId JobID,
    var theProposal) {
  CrudFunction.freelancer = Server.FreelancersList?.firstWhereOrNull(
      (user) => user['UserName'] == FreelancerUsername);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FreelancerUsername,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                IconButton(
                  onPressed: () async {
                    String? selected = await _showPopupMenu(context);
                    print(selected);

                    if (selected == 'Send Message') {
                      String sess =
                          ClientUsername + FreelancerUsername + id.toString();
                      await CrudFunction.filterchat(sess);
                      print(CrudFunction.chatfind);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientSideChatScreen(
                            checkclientfreelancer: 'Client',
                            proposalidget: id.toString(),
                          ),
                        ),
                      );
                    } else if (selected == 'Send Contract') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SendContract()),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.more_vert_outlined),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Cover Letter: " + CoverLetter,
                  style: TextStyle(fontSize: 14),
                  minFontSize: 14,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    'Bid Amount: \$${BidAmount}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print(id);
                          CrudFunction.cl_thatProposal = theProposal;

                          CrudFunction.cl_thatJob = Server.JobPostsList!
                              .firstWhereOrNull((job) => job['_id'] == JobID);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClientViewProposal()));
                        },
                        child: const Text(
                          "View Proposal",
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
          ],
        ),
      ),
    ),
  );
}

Future<String?> _showPopupMenu(BuildContext context) async {
  final selection = await showMenu(
    color: Colors.white,
    context: context,
    position: RelativeRect.fromLTRB(
        100.0, 380.0, 50, 100.0), // Positioning of the popup menu
    items: [
      PopupMenuItem(
        value: 'Send Message',
        child: Text('Send Message'),
      ),
      if (CrudFunction.thatProposal['ContractSent'] != true)
        PopupMenuItem(
          value: 'Send Contract',
          child: Text('Send Contract'),
        )
    ],
    elevation: 8.0,
  );

  // Handle your action (if any) here
  return selection;
}
