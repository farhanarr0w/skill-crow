import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/recommendation_api_service.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/screens/ClientScreens/invite_freelancers_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/proposals_view_screen.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:collection/collection.dart';

class JobActivity extends StatefulWidget {
  const JobActivity({super.key});

  @override
  State<JobActivity> createState() => _JobActivityState();
}

class _JobActivityState extends State<JobActivity> {
  final ApiService apiService =
      ApiService(baseUrl: 'http://192.168.40.219:5000');
  Map<dynamic, dynamic> recommendedFreelancers = {};

  Future<void> getRecommendations(String title, String description) async {
    try {
      Map<dynamic, dynamic> recommendations =
          await apiService.getRecommendedFreelancers(title, description);
      setState(() {
        recommendedFreelancers = recommendations;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    CrudFunction.recommendedFreelancers = [];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Job Activity"),
          backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
          elevation: 2,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AutoSizeText(
                "${CrudFunction.cl_thatJob['JobTitle']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 20,
                maxLines: 3,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(
                  "${CrudFunction.cl_thatJob['JobDescription']}",
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              ),
              Divider(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    Text(
                      "Budget: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${CrudFunction.cl_thatJob['Budget']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Expertise Level: ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    CrudFunction.cl_thatJob['ExpertiseLevel'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Activity on this job",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "No. of Proposals: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${CrudFunction.cl_thatJob['NoOfProposals']}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Invites Sent: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${CrudFunction.cl_thatJob['NoOfInvites']}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 40,
              ),
              if (CrudFunction.cl_thatJob["NoOfInvites"] == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          print('Invite Freelancers');

                          await getRecommendations(
                              CrudFunction.cl_thatJob['JobTitle'],
                              CrudFunction.cl_thatJob['JobDescription']);
                          for (var freelancerId in recommendedFreelancers[
                              'recommended_freelancers']) {
                            var person = Server.FreelancersList!
                                .firstWhereOrNull((freelancer) =>
                                    freelancer['_id'].toHexString() ==
                                    freelancerId);

                            if (person != null) {
                              // Check if recommendedFreelancers is null, initialize if it is
                              CrudFunction.recommendedFreelancers ??= [];
                              CrudFunction.recommendedFreelancers!.add(person);
                              print('Person Added');
                            } else {
                              print('No person found with id: $freelancerId');
                            }
                          }

                          for (var prop
                              in CrudFunction.cl_thatJob['Proposals']) {
                            for (int i = 0;
                                i < CrudFunction.recommendedFreelancers.length;
                                i++) {
                              var fr = CrudFunction.recommendedFreelancers[i];
                              if (prop['FreelancerUsername'] ==
                                  fr['UserName']) {
                                print('matched!!!');
                                print(CrudFunction.recommendedFreelancers);
                                CrudFunction.recommendedFreelancers.removeAt(i);
                                i--; // Decrement index because the list size is reduced
                              }
                            }
                          }

                          CrudFunction.JobInfoForInvite =
                              CrudFunction.cl_thatJob;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InviteFreelancersScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Invite a Freelancer",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('View Proposals');

                        CrudFunction.viewProposals(
                            CrudFunction.cl_thatJob['_id']);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProposalsViewScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "View Proposals",
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
            ]),
          ),
        ));
  }
}
