import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_proposals.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';

class ViewOffer extends StatefulWidget {
  const ViewOffer({super.key});

  @override
  State<ViewOffer> createState() => _ViewOfferState();
}

class _ViewOfferState extends State<ViewOffer> {
  @override
  Widget build(BuildContext context) {
    
    CrudFunction.fr_thatClient = Server.ClientsList!.firstWhereOrNull(
        (client) =>
            client['UserName'] == CrudFunction.jobContract['ClientUsername']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Contract',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Congratulations! You have received a contract from ${CrudFunction.fr_thatClient['FirstName']}!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Please review the contract details below carefully before making your decision.',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'This contract is binding and outlines the terms and conditions agreed upon by both parties.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Project Price: \$${CrudFunction.jobContract['ProjectPrice']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Escrow: \$${CrudFunction.jobContract['EscrowAmount']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Project Brief: ${CrudFunction.jobContract['ContractDescription']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        if (CrudFunction.jobContract['FileName'] != null)
                          Row(
                            children: [
                              Icon(Icons.attachment),
                              SizedBox(width: 5),
                              Text('${CrudFunction.jobContract['FileName']}'),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (CrudFunction.jobContract['ProposalID'] ==
                            'Invited Contract') {
                          await CrudFunction.acceptInvitedContract(
                              CrudFunction.jobContract['_id']);
                        } else {
                          await CrudFunction.acceptContract(
                              CrudFunction.jobContract['_id'],
                              CrudFunction.jobContract['ProposalID'],
                              CrudFunction.UserFind['UserName']);
                        }

                        show(context, "Offer Accepted", 'success');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerHomeScreen()));
                      },
                      child: Text(
                        'Accept Offer',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(0, 201, 104, 1), // Background color
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        CrudFunction.declineContract(
                            CrudFunction.jobContract['_id'],
                            CrudFunction.jobContract['ProposalID']);
                        show(context, "Offer Declined", 'error');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerHomeScreen()));
                      },
                      child: Text('Decline Offer',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Decline usually in red
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
