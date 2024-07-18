import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_skillcrow/abc.dart';
import 'package:project_skillcrow/screens/Chat/freelancer_chats.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/screens/ClientScreens/invite_freelancers_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/job_activity.dart';
import 'package:project_skillcrow/screens/ClientScreens/send_contract.dart';
import 'package:project_skillcrow/screens/ClientScreens/send_invited_contract.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/InsertPortfolio.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Savedjobapage.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/ViewAllContracts_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/seeds_purchase_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_proposals.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/statspage.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/updateportfolio.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:collection/collection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../reusable_widgets/notification_api.dart';

class FreelancerProfileView extends StatefulWidget {
  const FreelancerProfileView({super.key});

  @override
  State<FreelancerProfileView> createState() => _FreelancerProfileViewState();
}

class _FreelancerProfileViewState extends State<FreelancerProfileView> {
  String UserName = CrudFunction.InviteUserView['UserName'];

  int change = 0;
  Uint8List bytes = base64.decode(CrudFunction.InviteUserView['Image']);

  @override
  Widget build(BuildContext context) {
    Widget cardstarted = SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: CrudFunction.filteredFRContracts!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (CrudFunction.filteredFRContracts![index]['ContractStatus'] ==
                  "started") ...[
                Card(
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
                      ],
                    ),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
    Widget cardcompleted = SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: CrudFunction.filteredFRContracts!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              if (CrudFunction.filteredFRContracts![index]['ContractStatus'] ==
                  "completed") ...[
                Card(
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
                        Column(
                          children: [
                            for (var reviews
                                in CrudFunction.InviteUserView['Reviews'])
                              if (reviews['contractID'] ==
                                  CrudFunction.filteredFRContracts![index]
                                          ['_id']
                                      .toString()) ...[
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RatingBarIndicator(
                                              rating: double.tryParse(
                                                      reviews['rating']) ??
                                                  0.0,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${reviews['comment']}",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite Freelancers"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => JobActivity()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 25, 5, 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CrudFunction.InviteUserView['Image'] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      bytes!,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                        height: 80,
                                        width: 80,
                                        'assets/images/pic_signin.png')),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      //Name here
                                      CrudFunction.InviteUserView['FirstName'],
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      //Name here
                                      ' ${CrudFunction.InviteUserView['LastName'][0]}.',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  CrudFunction.InviteUserView['Title'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
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
              Container(
                padding: EdgeInsets.fromLTRB(18, 0, 10, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      child: Icon(
                        Icons.badge_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      CrudFunction.InviteUserView['Badge'] == 'none'
                          ? 'Rising Talent'
                          : CrudFunction.InviteUserView['Badge'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    CircleAvatar(
                      radius: 15,
                      child: Icon(
                        Icons.double_arrow_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      CrudFunction.InviteUserView['JSS'] == 0
                          ? 'No Jobs'
                          : '${CrudFunction.InviteUserView['JSS']}% job Success',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Seeds: ${CrudFunction.InviteUserView['Seeds']}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Buy Seeds',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(13, 146, 82, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Total Earning",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          Text('Total jobs',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          Text('In Progress',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "\$${CrudFunction.InviteUserView['TotalEarnings']}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${CrudFunction.InviteUserView['TotalJobs']}',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${CrudFunction.InviteUserView['JobsInProgress']}',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            change = 0;
                          });
                        },
                        child: const Text(
                          'ABOUT',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 43, 43, 43),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            change = 1;
                          });
                        },
                        child: const Text(
                          'WORK HISTORY',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 43, 43, 43),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            change = 2;
                          });
                        },
                        child: const Text(
                          'PORTFOLIO',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 43, 43, 43),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              (change == 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        CrudFunction.InviteUserView['About'],
                      ),
                    ) //modify UI
                  : (change == 1)
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Column(
                            children: [
                              DefaultTabController(
                                  length: 2, // length of tabs
                                  initialIndex: 0,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          child: TabBar(
                                            labelColor:
                                                Color.fromRGBO(0, 255, 132, 1),
                                            unselectedLabelColor: Colors.black,
                                            tabs: [
                                              Tab(text: 'In Progress'),
                                              Tab(text: 'Completed'),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            height: 400, //height of TabBarView
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5))),
                                            child:
                                                TabBarView(children: <Widget>[
                                              SingleChildScrollView(
                                                child: Container(
                                                  child: Column(
                                                    children: [cardstarted],
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Container(
                                                  child: Column(
                                                    children: [cardcompleted],
                                                  ),
                                                ),
                                              ),
                                            ]))
                                      ])),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'PORTFOLIO',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (var portfolio in CrudFunction
                                            .InviteUserView['Portfolio'])
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                showGeneralDialog(
                                                  barrierLabel: "Show Image",
                                                  barrierDismissible: true,
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionDuration: Duration(
                                                      milliseconds: 700),
                                                  context: context,
                                                  pageBuilder:
                                                      (context, anim1, anim2) {
                                                    return Center(
                                                      child: SizedBox(
                                                        height: 600,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 50,
                                                                  left: 12,
                                                                  right: 12),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Scaffold(
                                                              body: Center(
                                                                // This Center widget ensures the content is centered horizontally and vertically
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          400,
                                                                      child: Image
                                                                          .memory(
                                                                        base64.decode(
                                                                            portfolio['Image']),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                        "${portfolio['Title']}"),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  transitionBuilder: (context,
                                                      anim1, anim2, child) {
                                                    return SlideTransition(
                                                      position: Tween(
                                                              begin:
                                                                  Offset(0, 1),
                                                              end: Offset(0, 0))
                                                          .animate(anim1),
                                                      child: child,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 200,
                                                    height: 150,
                                                    child: Image.memory(
                                                      base64.decode(
                                                          portfolio['Image']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("${portfolio['Title']}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    //skills widgets here
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10.0, // spacing between chips
                      runSpacing: 5.0, // spacing between rows
                      children: [
                        for (var index in CrudFunction.InviteUserView['Skills'])
                          InkWell(
                              onTap: () {}, child: Chip(label: Text(index))),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Languages',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    //skills widgets here
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10.0, // spacing between chips
                      runSpacing: 5.0, // spacing between rows
                      children: [
                        for (var index
                            in CrudFunction.InviteUserView['Languages'])
                          InkWell(
                              onTap: () {}, child: Chip(label: Text(index))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Education',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var education
                        in CrudFunction.InviteUserView['Education'])
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${education['CollegeName']}"),
                                      SizedBox(
                                          height:
                                              5), // Adjust spacing between elements as needed
                                      Text("${education['Major']}"),
                                    ],
                                  ),
                                  Text("${education['Duration']}"),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              ///INVITE BUTTON HERE
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          print("Invite Pressed");

                          await CrudFunction.sendInvite(
                              CrudFunction.JobInfoForInvite['_id'], UserName);

                          CrudFunction.thatJob = CrudFunction.cl_thatJob;
                          CrudFunction.freelancer = CrudFunction.InviteUserView;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendInvitedContract()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Invite",
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
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
