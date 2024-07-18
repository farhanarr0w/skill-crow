import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/job_card_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

import '../freelancer_home_screen.dart';

class JobCard extends StatelessWidget {

  JobCard({super.key});

  String UserName = CrudFunction.UserFind['UserName'];

  @override
  Widget build(BuildContext context) {

    bool limitCheck = false;
    bool check = false;


    if (CrudFunction.filteredJobsFr!.length > 0)
      return ListView.builder(
        itemCount: CrudFunction.filteredJobsFr!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
            padding: EdgeInsets.fromLTRB(16, 20, 5, 16),
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
              color: Color(0xFFe9fbf2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (LimitCheck(
                            CrudFunction.filteredJobsFr![index]
                                ['NoOfProposals'],
                            limitCheck) ==
                        true)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          'Limit for submitting Proposals on this job has been reached',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF4d4d4d)),
                        ),
                      ),
                    if (Checker(
                            CrudFunction.filteredJobsFr![index]['Proposals'],
                            check) ==
                        true)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          'You have submitted proposal for this job',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF4d4d4d)),
                        ),
                      ),
                    AutoSizeText(
                      '${CrudFunction.filteredJobsFr![index]['JobTitle']}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      minFontSize: 22,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        '${CrudFunction.filteredJobsFr![index]['JobCategory']}',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF4d4d4d)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: AutoSizeText(
                        '${CrudFunction.filteredJobsFr![index]['JobDescription']}',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF4d4d4d)),
                        minFontSize: 16,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proposals: ${CrudFunction.filteredJobsFr![index]['NoOfProposals']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Invites: ${CrudFunction.filteredJobsFr![index]['NoOfInvites']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print("See Details Button Pressed");

                        String currentJob =
                            CrudFunction.filteredJobsFr![index]['JobTitle'];

                        CrudFunction.currentJobUpdater(currentJob);

                        check = Checker(
                            CrudFunction.filteredJobsFr![index]['Proposals'],
                            check);
                        limitCheck = LimitCheck(
                            CrudFunction.filteredJobsFr![index]['NoOfProposals'],
                            limitCheck);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobCardScreen(
                                    check: check,
                                    limitCheck: limitCheck,
                                  )),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "See Details",
                        style: TextStyle(
                            color: Color.fromARGB(255, 43, 43, 43),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color.fromRGBO(0, 255, 132, 1);
                          }
                          return const Color.fromRGBO(0, 255, 132, 1);
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    if (Checker(
                        CrudFunction.filteredJobsFr![index]['Proposals'],
                        check) ==
                        false)...[
                      if (!CrudFunction.UserFind['SavedJobs']
                          .any((education) => education['jobid'] == CrudFunction.filteredJobsFr![index]['_id'].toString()))
                        ElevatedButton(
                          onPressed: () async {
                            print("Save Job Button Pressed");
                            insertsavedjob(
                              context, // Pass context here
                              CrudFunction.filteredJobsFr![index]['_id'].toString(),
                              CrudFunction.filteredJobsFr![index]['JobTitle'],
                              CrudFunction.filteredJobsFr![index]['NoOfProposals'].toString(),
                            );
                          },
                          child: const Text(
                            "Save Job",
                            style: TextStyle(
                                color: Color.fromARGB(255, 43, 43, 43),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromRGBO(0, 255, 132, 1);
                              }
                              return const Color.fromRGBO(0, 255, 132, 1);
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            print("UnSave Job Button Pressed");

                            deletesavedjob(
                              context, // Pass context here
                              CrudFunction.filteredJobsFr![index]['_id'].toString(),
                              CrudFunction.filteredJobsFr![index]['JobTitle'],
                              CrudFunction.filteredJobsFr![index]['NoOfProposals'].toString(),

                            );
                          },
                          child: const Text(
                            "Unsave",
                            style: TextStyle(
                                color: Color.fromARGB(255, 43, 43, 43),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromRGBO(0, 255, 132, 1);
                              }
                              return const Color.fromRGBO(0, 255, 132, 1);
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),


                    ]

                  ],
                ),
              ],
            ),
          );
        },
      );
    else
      return Center(
          child: Text(
        'No jobs in this category',
        style:
            TextStyle(fontSize: 18, color: Color.fromARGB(255, 159, 159, 159)),
      ));
  }

  void insertsavedjob(BuildContext context, String jobid,
      String jobname, String proposalslimit) async {
    print("Insering Saved job!!!!");
    print(jobid + jobname + proposalslimit);
    CrudFunction.insertsavedjobs(UserName, jobid, jobname, proposalslimit);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved Job inserted")),
    );
  }

  void deletesavedjob(
      BuildContext context, String jobid,
      String jobname, String proposalslimit) async {
    print(jobid + jobname + proposalslimit);

    print("Removing Saved job!!!!");
   // print(index);
    CrudFunction.deletesavedjobs(UserName, jobid, jobname, proposalslimit);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Removing Job inserted")),
    );
  }

  bool Checker(var Fj, bool _check) {
    for (var item in Fj) {
      if (item['FreelancerUsername'] == CrudFunction.UserFind['UserName']) {
        print('Already Applied');
        _check = true;
        return _check;
      }
    }
    return _check;
  }



  bool LimitCheck(var NOP, bool _limitCheck) {
    if (NOP >= 10) {
      _limitCheck = true;
      return _limitCheck;
    } else {
      _limitCheck = false;
      return _limitCheck;
    }
  }
}