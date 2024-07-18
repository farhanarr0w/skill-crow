import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Contract_details_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/view_offer.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/view_proposal.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';

class FreelancerProposals extends StatefulWidget {
  const FreelancerProposals({super.key});

  @override
  State<FreelancerProposals> createState() => _FreelancerProposalsState();
}

class _FreelancerProposalsState extends State<FreelancerProposals> {
  var job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Proposals',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreelancerHomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: CrudFunction.filteredFRProposals!.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              tileColor: Colors.white,
              title: AutoSizeText(
                Server.JobPostsList!.firstWhereOrNull((job) =>
                            job['_id'] ==
                            CrudFunction.filteredFRProposals![index]
                                ['JobID'])!['JobTitle'] ==
                        null
                    ? 'No Title'
                    : (Server.JobPostsList?.firstWhereOrNull((job) =>
                        job['_id'] ==
                        CrudFunction.filteredFRProposals![index]
                            ['JobID']))?['JobTitle'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                maxLines: 1,
                minFontSize: 22,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bid Amount: \$${CrudFunction.filteredFRProposals![index]['BidAmount']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  AutoSizeText(
                    'Cover Letter: ${CrudFunction.filteredFRProposals![index]['CoverLetter']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  for (var file in (CrudFunction.filteredFRProposals![index]
                          ['Files'] as List? ??
                      []))
                    AutoSizeText(
                      'Attachment: ${file['Name']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 76, 255),
                      ),
                      maxLines: 1,
                      minFontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (CrudFunction.filteredFRProposals![index]
                          ['ContractSent'] ==
                      true)
                    Container(
                      width: 110,
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((90)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          CrudFunction.jobContract = Server.ContractsList!
                              .firstWhereOrNull((contract) =>
                                  contract['ProposalID'] ==
                                  CrudFunction.filteredFRProposals![index]
                                      ['_id']);

                          if (CrudFunction.jobContract['ContractStatus'] !=
                              'started') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewOffer()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContractsDetailsScreen()));
                          }
                        },
                        child: Text(
                          'View Offer',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
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
                      ),
                    ),
                  Container(
                    width: 130,
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 255, 132, 1),
                      borderRadius: BorderRadius.circular((90)),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          CrudFunction.fr_thatProposal =
                              CrudFunction.filteredFRProposals![index];

                          CrudFunction.fr_thatJob = Server.JobPostsList!
                              .firstWhereOrNull((job) =>
                                  job['_id'] ==
                                  CrudFunction.filteredFRProposals![index]
                                      ['JobID']);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProposal()));
                        },
                        child: Text(
                          'See Proposal',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
