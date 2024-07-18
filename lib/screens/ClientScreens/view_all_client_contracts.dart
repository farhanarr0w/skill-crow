import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_contract_details_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';

class ViewAllClientContracts extends StatefulWidget {
  const ViewAllClientContracts({super.key});

  @override
  State<ViewAllClientContracts> createState() => _ViewAllClientContractsState();
}

class _ViewAllClientContractsState extends State<ViewAllClientContracts> {
  @override
  Widget build(BuildContext context) {
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
              MaterialPageRoute(builder: (context) => ClientHome()),
              (route) => false,
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: CrudFunction.filteredCLContracts!.length,
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
                            CrudFunction.filteredCLContracts![index]
                                ['JobID'])!['JobTitle'] ==
                        null
                    ? 'No Title'
                    : (Server.JobPostsList?.firstWhereOrNull((job) =>
                        job['_id'] ==
                        CrudFunction.filteredCLContracts![index]
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
                    'Project Price: \$${CrudFunction.filteredCLContracts![index]['ProjectPrice']}',
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
                    'Escrow: \$${CrudFunction.filteredCLContracts![index]['EscrowAmount']}',
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
                    '${CrudFunction.filteredCLContracts![index]['ContractDescription']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (CrudFunction.filteredCLContracts![index]
                              ['ContractStatus'] ==
                          'started' ||
                      CrudFunction.filteredCLContracts![index]
                              ['ContractStatus'] ==
                          'refundRequested' ||
                      CrudFunction.filteredCLContracts![index]
                              ['ContractStatus'] ==
                          'refundDeclined' ||
                      CrudFunction.filteredCLContracts![index]
                              ['ContractStatus'] ==
                          'refundApproved' ||
                      CrudFunction.filteredCLContracts![index]
                      ['ContractStatus'] ==
                          'completed')
                    TextButton(
                      onPressed: () {
                        CrudFunction.jobContract = Server.ContractsList!
                            .firstWhereOrNull((contract) =>
                                contract['_id'] ==
                                CrudFunction.filteredCLContracts![index]
                                    ['_id']);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ClientContractDetailsScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text(
                          "See details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(0, 201, 104, 1), // Background color
                      ),
                    )
                  else if (CrudFunction.filteredCLContracts![index]
                          ['ContractStatus'] ==
                      'declined')
                    TextButton(
                      onPressed: () {
                        print(CrudFunction.filteredCLContracts![index]
                            ['ContractStatus']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text(
                          "Offer declined",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(177, 7, 7, 1), // Background color
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        print(CrudFunction.filteredCLContracts![index]
                            ['ContractStatus']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text(
                          "Waiting to accept",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(0, 201, 104, 1), // Background color
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
