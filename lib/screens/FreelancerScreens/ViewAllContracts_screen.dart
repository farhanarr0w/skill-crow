import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Contract_details_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/view_offer.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';

class ViewAllContractsScreen extends StatefulWidget {
  const ViewAllContractsScreen({super.key});

  @override
  State<ViewAllContractsScreen> createState() => _ViewAllContractsScreenState();
}

class _ViewAllContractsScreenState extends State<ViewAllContractsScreen> {
  @override
  Widget build(BuildContext context) {
    String UserName = CrudFunction.UserFind['UserName'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contracts',
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
        itemCount: CrudFunction.filteredFRContracts!.length,
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
                            CrudFunction.filteredFRContracts![index]
                                ['JobID'])!['JobTitle'] ==
                        null
                    ? 'No Title'
                    : (Server.JobPostsList?.firstWhereOrNull((job) =>
                        job['_id'] ==
                        CrudFunction.filteredFRContracts![index]
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
                    'Project Price: \$${CrudFunction.filteredFRContracts![index]['ProjectPrice']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'Escrow: \$${CrudFunction.filteredFRContracts![index]['EscrowAmount']}',
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
                    '${CrudFunction.filteredFRContracts![index]['ContractDescription']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (CrudFunction.filteredFRContracts![index]
                          ['ContractStatus'] !=
                      'declined')
                    TextButton(
                      onPressed: () async {
                        CrudFunction.jobContract = Server.ContractsList!
                            .firstWhereOrNull((contract) =>
                                contract['_id'] ==
                                CrudFunction.filteredFRContracts![index]
                                    ['_id']);

                        if (CrudFunction.filteredFRContracts![index]
                                    ['ContractStatus'] ==
                                'started' ||
                            CrudFunction.filteredFRContracts![index]
                                    ['ContractStatus'] ==
                                'refundRequested' ||
                            CrudFunction.filteredFRContracts![index]
                                    ['ContractStatus'] ==
                                'refundDeclined' ||
                            CrudFunction.filteredFRContracts![index]
                                    ['ContractStatus'] ==
                                'refundApproved'||
                            CrudFunction.filteredFRContracts![index]
                            ['ContractStatus'] ==
                                'completed') {


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ContractsDetailsScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOffer()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text(
                          "See Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(0, 201, 104, 1), // Background color
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text(
                          "Offer Declined",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(201, 0, 0, 1), // Background color
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
