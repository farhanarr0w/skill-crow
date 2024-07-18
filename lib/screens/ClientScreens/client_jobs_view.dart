import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/screens/ClientScreens/edit_job_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/job_activity.dart';
import 'package:project_skillcrow/screens/ClientScreens/proposals_view_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class ClientedJobsView extends StatefulWidget {
  const ClientedJobsView({super.key});

  @override
  State<ClientedJobsView> createState() => _ClientedJobsViewState();
}

class _ClientedJobsViewState extends State<ClientedJobsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        title: Text("View your posted jobs"),
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
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: CrudFunction.filteredJobsCl!.length,
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
                title: AutoSizeText(
                  CrudFunction.filteredJobsCl![index]['JobTitle'],
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 16,
                ),
                tileColor: Color.fromARGB(255, 255, 255, 255),
                leading: Icon(Icons.book_online),
                onTap: () {
                  bottomsheets(
                      context,
                      CrudFunction.filteredJobsCl![index]['JobStatus'],
                      CrudFunction.filteredJobsCl![index]['JobTitle'],
                      CrudFunction.filteredJobsCl![index]['JobDescription'],
                      CrudFunction.filteredJobsCl![index]['JobCategory'],
                      CrudFunction.filteredJobsCl![index]['Budget'],
                      CrudFunction.filteredJobsCl![index]['_id']);
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
    String jobStatus,
    String jobTitle,
    String jobDescription,
    String jobCategory,
    int jobBudget,
    mongo.ObjectId JobID) {
  CrudFunction.thatJob =
      Server.JobPostsList?.firstWhereOrNull((job) => job['_id'] == JobID);
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
        padding: const EdgeInsets.fromLTRB(15, 15, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (jobStatus == 'closed')
              AutoSizeText(
                "Job Closed",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                minFontSize: 25,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.red),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    jobTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    minFontSize: 25,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                if (jobStatus != 'closed')
                  IconButton(
                    onPressed: () async {
                      String? selected = await _showPopupMenu(context);
                      print(selected);

                      if (selected == 'deleteJob') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Job'),
                              content: Text(
                                  'Are you sure you want to delete this job?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await CrudFunction.closeJob(JobID);
                                    Navigator.of(context).pop();

                                    CrudFunction.searchJobsByClient(
                                        CrudFunction.ClientFind['UserName']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientedJobsView()));
                                  },
                                  child: Text('Delete'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (selected == 'editJob') {
                        CrudFunction.cl_editingJob = CrudFunction.thatJob;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditJobScreen()));
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: AutoSizeText(
                    jobDescription,
                    style: TextStyle(fontSize: 12),
                    minFontSize: 14,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Category: ' + jobCategory,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    'Budget: \$${jobBudget}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                if (jobStatus != 'closed')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular((90)),
                            ),
                            child: TextButton(
                              onPressed: () {
                                CrudFunction.viewProposals(JobID);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProposalsViewScreen()),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                "VIEW PROPOSALS",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color.fromRGBO(0, 255, 132, 1);
                                  }
                                  return const Color.fromRGBO(0, 255, 132, 1);
                                }),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular((90)),
                            ),
                            child: TextButton(
                              onPressed: () {
                                CrudFunction.cl_thatJob = Server.JobPostsList!
                                    .firstWhereOrNull(
                                        (job) => job['_id'] == JobID);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobActivity()),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                "VIEW JOB ACTIVITY",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color.fromRGBO(0, 255, 132, 1);
                                  }
                                  return const Color.fromRGBO(0, 255, 132, 1);
                                }),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
        100.0, 380.0, 70, 100.0), // Positioning of the popup menu
    items: [
      PopupMenuItem(
        value: 'editJob',
        child: Text('Edit Job'),
      ),
      PopupMenuItem(
        value: 'deleteJob',
        child: Text('Delete Job'),
      )
    ],
    elevation: 8.0,
  );

  // Handle your action (if any) here
  return selection;
}
