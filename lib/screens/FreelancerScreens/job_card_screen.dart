import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/proposal_writing_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class JobCardScreen extends StatefulWidget {
  final bool check;
  final bool limitCheck;
  const JobCardScreen({
    Key? key,
    required this.check,
    required this.limitCheck,
  }) : super(key: key);

  @override
  State<JobCardScreen> createState() => _JobCardScreenState(check, limitCheck);
}

class _JobCardScreenState extends State<JobCardScreen> {
  bool check;
  bool limitCheck;
  _JobCardScreenState(this.check, this.limitCheck);

  @override
  Widget build(BuildContext context) {
    print("Check: ${check}");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Job Details"),
          backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => FreelancerJobsApply(
                          search: false,
                          search_word: "",
                        )),
                (route) => false,
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            elevation: 1,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (check == true)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Applied",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                        backgroundColor: Color.fromARGB(255, 117, 117, 117),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  )
                else if (limitCheck == true)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Limit Reached",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                        backgroundColor: Color.fromARGB(255, 117, 117, 117),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProposalWritingScreen()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Apply Now",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  )
              ],
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${CrudFunction.currentJob!['JobTitle']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      children: [
                        Text(
                          "Send a proposal for: ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 107, 107, 107)),
                        ),
                        Text(
                          "${CrudFunction.currentJob!['SeedsRequired']} seeds",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 107, 107, 107)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Available Seeds: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 107, 107, 107)),
                      ),
                      Text(
                        "${CrudFunction.UserFind['Seeds']}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 107, 107, 107)),
                      ),
                    ],
                  ),
                  Divider(
                    height: 40,
                  ),
                  Text(
                    "${CrudFunction.currentJob!['JobDescription']}",
                    style: TextStyle(fontSize: 16),
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
                          "\$${CrudFunction.currentJob!['Budget']}",
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
                        "${CrudFunction.currentJob!['ExpertiseLevel']}",
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
                          "${CrudFunction.currentJob!['NoOfProposals']}",
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
                          "${CrudFunction.currentJob!['NoOfInvites']}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
