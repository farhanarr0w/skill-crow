import 'dart:convert';

// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skillcrow/screens/Chat/freelancer_chats_list_screen.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:project_skillcrow/abc.dart';
// import 'package:project_skillcrow/screens/Chat/freelancer_chats.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/InsertPortfolio.dart';
// import 'package:project_skillcrow/screens/FreelancerScreens/Savedjobapage.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/ViewAllContracts_screen.dart';
// import 'package:project_skillcrow/screens/FreelancerScreens/invitedJobs.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/seeds_purchase_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_proposals.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/statspage.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/updateportfolio.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
// import 'package:project_skillcrow/user_fetch.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:collection/collection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../reusable_widgets/notification_api.dart';
import 'edit_profile_freelancer.dart';
// import 'navigiationforalert.dart';

class FreelancerHomeScreen extends StatefulWidget {
  const FreelancerHomeScreen({super.key});

  @override
  State<FreelancerHomeScreen> createState() => _FreelancerHomeScreenState();
}

class _FreelancerHomeScreenState extends State<FreelancerHomeScreen> {
  late final LocalNotificationService service;

  String UserName = CrudFunction.UserFind['UserName'];

  int change = 0;
  Uint8List bytes = base64.decode(CrudFunction.UserFind['Image']);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController insertskillcontroller = TextEditingController();
  final TextEditingController unicollegecontroller = TextEditingController();
  final TextEditingController majorcontroller = TextEditingController();
  final TextEditingController insertlanguagecontroller =
      TextEditingController();
  final TextEditingController updateskillcontroller = TextEditingController();
  final TextEditingController updatelanguagecontroller =
      TextEditingController();

  final TextEditingController updateCollegeNamecontroller =
      TextEditingController();
  final TextEditingController updateMajorcontroller = TextEditingController();

  String? PreviousCollegeName;
  String? PreviousMajor;
  String? PreviousDuration;

  String? skill;
  String? unicollege;
  String? major;
  String? language;
  String? PreviousSkill;
  String? PreviousLanguage;

  late WebSocketChannel channel;
  var checkrole = "";

  var _progressTextController;
  var updateDurationcontroller;
  var exchangeSourceOption = ['In progress', 'Completed'];

  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.125:8080/'));
    print('WebSocket connection established');

    channel.stream.listen((message) {
      try {
        final data = jsonDecode(message);
        print('Message received: $data');

        if (data['operationType'] == 'insert') {
          if (data['fullDocument'] != null &&
              data['fullDocument']['Messages'] != null) {
            setState(() {
              if (UserName != data['fullDocument']['Messages'].last['role']) {
                service.showNotification(
                  id: 1, // Use a unique id for each notification
                  title:
                      'New Message From ${data['fullDocument']['Messages'].last['role']}',
                  body:
                      '${data['fullDocument']['Messages'].last['messageContent']}',
                );
              }
            });
          } else {
            print(
                'Received data does not contain expected fullDocument or Messages.');
          }
        } else if (data['operationType'] == 'update') {
          if (data['updateDescription'] != null &&
              data['updateDescription']['updatedFields'] != null) {
            data['updateDescription']['updatedFields'].forEach((key, value) {
              if (key.startsWith('Messages.') &&
                  value['messageContent'] != null) {
                setState(() {
                  if (UserName != value['role']) {
                    service.showNotification(
                      id: 2, // Use a unique id for each notification
                      title: 'New Message From ${value['role']}',
                      body: '${value['messageContent']}',
                    );
                  }
                });
              }
            });
          } else {
            print(
                'Received data does not contain expected updateDescription or updatedFields.');
          }
        }
      } catch (e) {
        print('Error processing message: $e');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  Widget build(BuildContext context) {
    // Widget cardstarted = SizedBox(
    //   height: 400,
    //   child: ListView.builder(
    //     itemCount: CrudFunction.filteredFRContracts!.length,
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: [
    //           if (CrudFunction.filteredFRContracts![index]['ContractStatus'] ==
    //               "started") ...[
    //             Card(
    //               color: const Color.fromARGB(255, 255, 255, 255),
    //               elevation: 3,
    //               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //               child: ListTile(
    //                 tileColor: Colors.white,
    //                 title: AutoSizeText(
    //                   Server.JobPostsList!.firstWhereOrNull((job) =>
    //                               job['_id'] ==
    //                               CrudFunction.filteredFRContracts![index]
    //                                   ['JobID'])!['JobTitle'] ==
    //                           null
    //                       ? 'No Title'
    //                       : (Server.JobPostsList?.firstWhereOrNull((job) =>
    //                           job['_id'] ==
    //                           CrudFunction.filteredFRContracts![index]
    //                               ['JobID']))?['JobTitle'],
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 22,
    //                   ),
    //                   maxLines: 1,
    //                   minFontSize: 22,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 subtitle: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       'Project Price: \$${CrudFunction.filteredFRContracts![index]['ProjectPrice']}',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 7,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ]
    //         ],
    //       );
    //     },
    //   ),
    // );

    // Widget cardcompleted = SizedBox(
    //   height: 400,
    //   child: ListView.builder(
    //     itemCount: CrudFunction.filteredFRContracts!.length,
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: [
    //           if (CrudFunction.filteredFRContracts![index]['ContractStatus'] ==
    //               "completed") ...[
    //             Card(
    //               color: const Color.fromARGB(255, 255, 255, 255),
    //               elevation: 3,
    //               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //               child: ListTile(
    //                 tileColor: Colors.white,
    //                 title: AutoSizeText(
    //                   Server.JobPostsList!.firstWhereOrNull((job) =>
    //                               job['_id'] ==
    //                               CrudFunction.filteredFRContracts![index]
    //                                   ['JobID'])!['JobTitle'] ==
    //                           null
    //                       ? 'No Title'
    //                       : (Server.JobPostsList?.firstWhereOrNull((job) =>
    //                           job['_id'] ==
    //                           CrudFunction.filteredFRContracts![index]
    //                               ['JobID']))?['JobTitle'],
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 22,
    //                   ),
    //                   maxLines: 1,
    //                   minFontSize: 22,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 subtitle: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       'Project Price: \$${CrudFunction.filteredFRContracts![index]['ProjectPrice']}',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 7,
    //                     ),
    //                     Column(
    //                       children: [
    //                         for (var reviews
    //                             in CrudFunction.UserFind['Reviews'])
    //                           if (reviews['contractID'] ==
    //                               CrudFunction.filteredFRContracts![index]
    //                                       ['_id']
    //                                   .toString()) ...[
    //                             Card(
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(15.0),
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         RatingBarIndicator(
    //                                           rating: double.tryParse(
    //                                                   reviews['rating']) ??
    //                                               0.0,
    //                                           itemCount: 5,
    //                                           itemSize: 15,
    //                                           itemBuilder: (context, _) => Icon(
    //                                             Icons.star,
    //                                             color: Colors.amber,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                     SizedBox(
    //                                       height: 5,
    //                                     ),
    //                                     SizedBox(
    //                                       height: 5,
    //                                     ),
    //                                     Text(
    //                                       "${reviews['comment']}",
    //                                       textAlign: TextAlign.left,
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             )
    //                           ]
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ]
    //         ],
    //       );
    //     },
    //   ),
    // );

    return Scaffold(
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
                            CrudFunction.UserFind['Image'] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      bytes,
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
                                      CrudFunction.UserFind['FirstName'],
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      //Name here
                                      ' ${CrudFunction.UserFind['LastName'][0]}.',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  CrudFunction.UserFind['Title'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const editProfileFreelancer()));
                          },
                          icon: Icon(
                            Icons.menu_outlined,
                            size: 30,
                          ),
                          color: Color.fromRGBO(0, 255, 132, 1),
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
                      CrudFunction.UserFind['Badge'] == 'none'
                          ? 'Rising Talent'
                          : CrudFunction.UserFind['Badge'],
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
                      CrudFunction.UserFind['JSS'] == 0
                          ? 'No Jobs'
                          : '${CrudFunction.UserFind['JSS']}% job Success',
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
                      "Available Seeds: ${CrudFunction.UserFind['Seeds']}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ConnectsPurchase())));
                      },
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
                            "\$${CrudFunction.UserFind['TotalEarnings']}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${CrudFunction.UserFind['TotalJobs']}',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${CrudFunction.UserFind['JobsInProgress']}',
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
                        CrudFunction.UserFind['About'],
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
                                                      //children: [cardstarted],
                                                      ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Container(
                                                  child: Column(
                                                      //children: [cardcompleted],
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
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Color.fromRGBO(0, 255, 132, 1),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  insertPortfolio()));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                            .UserFind['Portfolio'])
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
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              int index = CrudFunction.UserFind['Portfolio'].indexOf(portfolio);

                                                                              // insertLanguage(
                                                                              //     language!);
                                                                              //skillupdate(updateskillcontroller.text, PreviousSkill!);
                                                                              deletePortfolio(portfolio['Image'], portfolio['Title'], index);
                                                                            },
                                                                            child:
                                                                                Text("Delete")),
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              int index = CrudFunction.UserFind['Portfolio'].indexOf(portfolio);

                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => portfolioUpdateFreelancer(
                                                                                            imagepath: portfolio['Image'],
                                                                                            name: portfolio['Title'],
                                                                                            index: index,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Text("Update")),
                                                                      ],
                                                                    ),
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
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          child: IconButton(
                            onPressed: () {
                              showGeneralDialog(
                                barrierLabel: "Skill Insert",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 700),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 50, left: 12, right: 12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Scaffold(
                                            body: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              height: 500,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Form(
                                                      key: _formKey,
                                                      // child: TextFormField(
                                                      //   validator: (value) {
                                                      //     if (value!.isEmpty) {
                                                      //       return "Required";
                                                      //     }
                                                      //     return null;
                                                      //   },
                                                      //   onChanged: (value) {
                                                      //     skill = value;
                                                      //   },
                                                      //   controller:
                                                      //       insertskillcontroller,
                                                      //   cursorColor:
                                                      //       Colors.white,
                                                      //   style: const TextStyle(
                                                      //     color: Color.fromRGBO(
                                                      //         117, 117, 117, 1),
                                                      //   ),
                                                      //   decoration:
                                                      //       InputDecoration(
                                                      //     suffixIcon: Container(
                                                      //       height: 60.0,
                                                      //       width: 60.0,
                                                      //       //padding: EdgeInsets.all(10),
                                                      //       decoration: BoxDecoration(
                                                      //           borderRadius:
                                                      //               BorderRadius
                                                      //                   .circular(
                                                      //                       30),
                                                      //           border: Border.all(
                                                      //               width: 2,
                                                      //               color: Color
                                                      //                   .fromARGB(
                                                      //                       255,
                                                      //                       221,
                                                      //                       221,
                                                      //                       221))),
                                                      //     ),
                                                      //     prefixIcon: Icon(
                                                      //       Icons.credit_score,
                                                      //       color: const Color
                                                      //           .fromRGBO(117,
                                                      //           117, 117, 1),
                                                      //     ),
                                                      //     labelText:
                                                      //         "Type Skill",
                                                      //     labelStyle:
                                                      //         const TextStyle(
                                                      //       color:
                                                      //           Color.fromRGBO(
                                                      //               117,
                                                      //               117,
                                                      //               117,
                                                      //               1),
                                                      //     ),
                                                      //     filled: true,
                                                      //     floatingLabelBehavior:
                                                      //         FloatingLabelBehavior
                                                      //             .never,
                                                      //     fillColor:
                                                      //         Color.fromARGB(
                                                      //                 255,
                                                      //                 221,
                                                      //                 221,
                                                      //                 221)
                                                      //             .withOpacity(
                                                      //                 1),
                                                      //     border:
                                                      //         OutlineInputBorder(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(
                                                      //                   30),
                                                      //       borderSide:
                                                      //           const BorderSide(
                                                      //               width: 0,
                                                      //               style: BorderStyle
                                                      //                   .none),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      child:
                                                          FormBuilderDropdown(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .disabled,
                                                        name: 'exchangesource',
                                                        initialValue: skill,
                                                        onChanged: (value) {
                                                          skill =
                                                              value.toString();
                                                          //print(_catTextController);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Type Skill",
                                                          labelStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          fillColor:
                                                              Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)
                                                                  .withOpacity(
                                                                      1),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle
                                                                        .none),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.credit_score,
                                                            color: const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                          ),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required()
                                                        ]),
                                                        items:
                                                            filterSkillsWhichIsNotAdded()!
                                                                .map((skill) {
                                                          return DropdownMenuItem(
                                                            value: skill[
                                                                'SkillName'],
                                                            child: Text(
                                                                '${skill['SkillName']}'),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                insertskill(
                                                                    skill!);
                                                              }
                                                            },
                                                            child:
                                                                Text("Insert")),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: Offset(0, 1),
                                            end: Offset(0, 0))
                                        .animate(anim1),
                                    child: child,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
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
                        for (var index in CrudFunction.UserFind['Skills'])
                          InkWell(
                              onTap: () {
                                updateskillcontroller.text = index.toString();
                                print(updateskillcontroller.text);
                                PreviousSkill = index.toString();
                                showGeneralDialog(
                                  barrierLabel: "Skill Update",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  transitionDuration:
                                      Duration(milliseconds: 700),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 500,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 50, left: 12, right: 12),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Scaffold(
                                              body: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                height: 500,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Form(
                                                        key: _formKey,
                                                        // child: TextFormField(
                                                        //   validator: (value) {
                                                        //     if (value!
                                                        //         .isEmpty) {
                                                        //       return "Required";
                                                        //     }
                                                        //     return null;
                                                        //   },
                                                        //   onChanged: (value) {
                                                        //     updateskillcontroller
                                                        //         .text = value;
                                                        //   },
                                                        //   initialValue:
                                                        //       updateskillcontroller
                                                        //           .text,
                                                        //   cursorColor:
                                                        //       Colors.white,
                                                        //   style:
                                                        //       const TextStyle(
                                                        //     color:
                                                        //         Color.fromRGBO(
                                                        //             117,
                                                        //             117,
                                                        //             117,
                                                        //             1),
                                                        //   ),
                                                        //   decoration:
                                                        //       InputDecoration(
                                                        //     suffixIcon:
                                                        //         Container(
                                                        //       height: 60.0,
                                                        //       width: 60.0,
                                                        //       //padding: EdgeInsets.all(10),
                                                        //       decoration: BoxDecoration(
                                                        //           borderRadius:
                                                        //               BorderRadius
                                                        //                   .circular(
                                                        //                       30),
                                                        //           border: Border.all(
                                                        //               width: 2,
                                                        //               color: Color.fromARGB(
                                                        //                   255,
                                                        //                   221,
                                                        //                   221,
                                                        //                   221))),
                                                        //     ),
                                                        //     prefixIcon: Icon(
                                                        //       Icons
                                                        //           .credit_score,
                                                        //       color: const Color
                                                        //           .fromRGBO(117,
                                                        //           117, 117, 1),
                                                        //     ),
                                                        //     labelStyle:
                                                        //         const TextStyle(
                                                        //       color: Color
                                                        //           .fromRGBO(
                                                        //               117,
                                                        //               117,
                                                        //               117,
                                                        //               1),
                                                        //     ),
                                                        //     filled: true,
                                                        //     floatingLabelBehavior:
                                                        //         FloatingLabelBehavior
                                                        //             .never,
                                                        //     fillColor: Color
                                                        //             .fromARGB(
                                                        //                 255,
                                                        //                 221,
                                                        //                 221,
                                                        //                 221)
                                                        //         .withOpacity(1),
                                                        //     border:
                                                        //         OutlineInputBorder(
                                                        //       borderRadius:
                                                        //           BorderRadius
                                                        //               .circular(
                                                        //                   30),
                                                        //       borderSide:
                                                        //           const BorderSide(
                                                        //               width: 0,
                                                        //               style: BorderStyle
                                                        //                   .none),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        child:
                                                            FormBuilderDropdown(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .disabled,
                                                          name:
                                                              'exchangesource',
                                                          initialValue: skill,
                                                          onChanged: (value) {
                                                            updateskillcontroller
                                                                    .text =
                                                                value
                                                                    .toString();
                                                            //print(_catTextController);
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                updateskillcontroller
                                                                    .text,
                                                            labelStyle:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      117,
                                                                      117,
                                                                      117,
                                                                      1),
                                                            ),
                                                            filled: true,
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .never,
                                                            fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        221,
                                                                        221,
                                                                        221)
                                                                .withOpacity(1),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width: 0,
                                                                      style: BorderStyle
                                                                          .none),
                                                            ),
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .credit_score,
                                                              color: const Color
                                                                  .fromRGBO(117,
                                                                  117, 117, 1),
                                                            ),
                                                          ),
                                                          validator:
                                                              FormBuilderValidators
                                                                  .compose([
                                                            FormBuilderValidators
                                                                .required()
                                                          ]),
                                                          items:
                                                              filterSkillsWhichIsNotAdded()!
                                                                  .map((skill) {
                                                            return DropdownMenuItem(
                                                              value: skill[
                                                                  'SkillName'],
                                                              child: Text(
                                                                  '${skill['SkillName']}'),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  // insertLanguage(
                                                                  //     language!);
                                                                  //skillupdate(updateskillcontroller.text, PreviousSkill!);
                                                                  skilldelete(
                                                                      PreviousSkill!);
                                                                }
                                                              },
                                                              child: Text(
                                                                  "Delete")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  // insertLanguage(
                                                                  //     language!);
                                                                  skillupdate(
                                                                      updateskillcontroller
                                                                          .text,
                                                                      PreviousSkill!);
                                                                }
                                                              },
                                                              child: Text(
                                                                  "Update")),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              },
                              child: Chip(label: Text(index))),
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
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          child: IconButton(
                            onPressed: () {
                              showGeneralDialog(
                                barrierLabel: "Language Insert",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 700),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 50, left: 12, right: 12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Scaffold(
                                            body: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              height: 500,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    // Form(
                                                    //   key: _formKey,
                                                    //   child: TextFormField(
                                                    //     validator: (value) {
                                                    //       if (value!.isEmpty) {
                                                    //         return "Required";
                                                    //       }
                                                    //       return null;
                                                    //     },
                                                    //     onChanged: (value) {
                                                    //       language = value;
                                                    //     },
                                                    //     controller:
                                                    //         insertlanguagecontroller,
                                                    //     cursorColor:
                                                    //         Colors.white,
                                                    //     style: const TextStyle(
                                                    //       color: Color.fromRGBO(
                                                    //           117, 117, 117, 1),
                                                    //     ),
                                                    //     decoration:
                                                    //         InputDecoration(
                                                    //       suffixIcon: Container(
                                                    //         height: 60.0,
                                                    //         width: 60.0,
                                                    //         //padding: EdgeInsets.all(10),
                                                    //         decoration: BoxDecoration(
                                                    //             borderRadius:
                                                    //                 BorderRadius
                                                    //                     .circular(
                                                    //                         30),
                                                    //             border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: Color
                                                    //                     .fromARGB(
                                                    //                         255,
                                                    //                         221,
                                                    //                         221,
                                                    //                         221))),
                                                    //       ),
                                                    //       prefixIcon: Icon(
                                                    //         Icons.credit_score,
                                                    //         color: const Color
                                                    //             .fromRGBO(117,
                                                    //             117, 117, 1),
                                                    //       ),
                                                    //       labelText:
                                                    //           "Type Language",
                                                    //       labelStyle:
                                                    //           const TextStyle(
                                                    //         color:
                                                    //             Color.fromRGBO(
                                                    //                 117,
                                                    //                 117,
                                                    //                 117,
                                                    //                 1),
                                                    //       ),
                                                    //       filled: true,
                                                    //       floatingLabelBehavior:
                                                    //           FloatingLabelBehavior
                                                    //               .never,
                                                    //       fillColor:
                                                    //           Color.fromARGB(
                                                    //                   255,
                                                    //                   221,
                                                    //                   221,
                                                    //                   221)
                                                    //               .withOpacity(
                                                    //                   1),
                                                    //       border:
                                                    //           OutlineInputBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     30),
                                                    //         borderSide:
                                                    //             const BorderSide(
                                                    //                 width: 0,
                                                    //                 style: BorderStyle
                                                    //                     .none),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    Form(
                                                      key: _formKey,
                                                      // child: TextFormField(
                                                      //   validator: (value) {
                                                      //     if (value!.isEmpty) {
                                                      //       return "Required";
                                                      //     }
                                                      //     return null;
                                                      //   },
                                                      //   onChanged: (value) {
                                                      //     skill = value;
                                                      //   },
                                                      //   controller:
                                                      //       insertskillcontroller,
                                                      //   cursorColor:
                                                      //       Colors.white,
                                                      //   style: const TextStyle(
                                                      //     color: Color.fromRGBO(
                                                      //         117, 117, 117, 1),
                                                      //   ),
                                                      //   decoration:
                                                      //       InputDecoration(
                                                      //     suffixIcon: Container(
                                                      //       height: 60.0,
                                                      //       width: 60.0,
                                                      //       //padding: EdgeInsets.all(10),
                                                      //       decoration: BoxDecoration(
                                                      //           borderRadius:
                                                      //               BorderRadius
                                                      //                   .circular(
                                                      //                       30),
                                                      //           border: Border.all(
                                                      //               width: 2,
                                                      //               color: Color
                                                      //                   .fromARGB(
                                                      //                       255,
                                                      //                       221,
                                                      //                       221,
                                                      //                       221))),
                                                      //     ),
                                                      //     prefixIcon: Icon(
                                                      //       Icons.credit_score,
                                                      //       color: const Color
                                                      //           .fromRGBO(117,
                                                      //           117, 117, 1),
                                                      //     ),
                                                      //     labelText:
                                                      //         "Type Skill",
                                                      //     labelStyle:
                                                      //         const TextStyle(
                                                      //       color:
                                                      //           Color.fromRGBO(
                                                      //               117,
                                                      //               117,
                                                      //               117,
                                                      //               1),
                                                      //     ),
                                                      //     filled: true,
                                                      //     floatingLabelBehavior:
                                                      //         FloatingLabelBehavior
                                                      //             .never,
                                                      //     fillColor:
                                                      //         Color.fromARGB(
                                                      //                 255,
                                                      //                 221,
                                                      //                 221,
                                                      //                 221)
                                                      //             .withOpacity(
                                                      //                 1),
                                                      //     border:
                                                      //         OutlineInputBorder(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(
                                                      //                   30),
                                                      //       borderSide:
                                                      //           const BorderSide(
                                                      //               width: 0,
                                                      //               style: BorderStyle
                                                      //                   .none),
                                                      //     ),
                                                      //   ),
                                                      // ),

                                                      child:
                                                          FormBuilderDropdown(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .disabled,
                                                        name: 'exchangesource',
                                                        initialValue: language,
                                                        onChanged: (value) {
                                                          language =
                                                              value.toString();
                                                          //print(_catTextController);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Select Language",
                                                          labelStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          fillColor:
                                                              Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)
                                                                  .withOpacity(
                                                                      1),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle
                                                                        .none),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.credit_score,
                                                            color: const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                          ),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required()
                                                        ]),
                                                        items:
                                                            filterLanguagesWhichIsNotAdded()!
                                                                .map(
                                                                    (language) {
                                                          return DropdownMenuItem(
                                                            value: language[
                                                                'language'],
                                                            child: Text(
                                                                '${language['language']}'),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),

                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                insertLanguage(
                                                                    language!);
                                                              }
                                                            },
                                                            child:
                                                                Text("Insert")),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: Offset(0, 1),
                                            end: Offset(0, 0))
                                        .animate(anim1),
                                    child: child,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
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
                        for (var index in CrudFunction.UserFind['Languages'])
                          InkWell(
                              onTap: () {
                                updatelanguagecontroller.text =
                                    index.toString();
                                print(updatelanguagecontroller.text);
                                PreviousLanguage = index.toString();
                                showGeneralDialog(
                                  barrierLabel: "Languages Update",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  transitionDuration:
                                      Duration(milliseconds: 700),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 50, left: 12, right: 12),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Scaffold(
                                              body: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                height: 500,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Form(
                                                        key: _formKey,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Required";
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            updatelanguagecontroller
                                                                .text = value;
                                                          },
                                                          initialValue:
                                                              updatelanguagecontroller
                                                                  .text,
                                                          cursorColor:
                                                              Colors.white,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                            suffixIcon:
                                                                Container(
                                                              height: 60.0,
                                                              width: 60.0,
                                                              //padding: EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          221,
                                                                          221,
                                                                          221))),
                                                            ),
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .credit_score,
                                                              color: const Color
                                                                  .fromRGBO(117,
                                                                  117, 117, 1),
                                                            ),
                                                            labelStyle:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      117,
                                                                      117,
                                                                      117,
                                                                      1),
                                                            ),
                                                            filled: true,
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .never,
                                                            fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        221,
                                                                        221,
                                                                        221)
                                                                .withOpacity(1),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width: 0,
                                                                      style: BorderStyle
                                                                          .none),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  // insertLanguage(
                                                                  //     language!);
                                                                  //skillupdate(updateskillcontroller.text, PreviousSkill!);
                                                                  Languagedelete(
                                                                      PreviousLanguage!);
                                                                }
                                                              },
                                                              child: Text(
                                                                  "Delete")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  // insertLanguage(
                                                                  //     language!);
                                                                  Languageupdate(
                                                                      updatelanguagecontroller
                                                                          .text,
                                                                      PreviousLanguage!);
                                                                }
                                                              },
                                                              child: Text(
                                                                  "Update")),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              },
                              child: Chip(label: Text(index))),
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
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                          child: IconButton(
                            onPressed: () {
                              showGeneralDialog(
                                barrierLabel: "Education Insert",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 700),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 500,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 50, left: 12, right: 12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Scaffold(
                                            body: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              height: 500,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Required";
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (value) {
                                                              unicollege =
                                                                  value;
                                                            },
                                                            controller:
                                                                unicollegecontroller,
                                                            cursorColor:
                                                                Colors.white,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      117,
                                                                      117,
                                                                      117,
                                                                      1),
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  Container(
                                                                height: 60.0,
                                                                width: 60.0,
                                                                //padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            221,
                                                                            221,
                                                                            221))),
                                                              ),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .credit_score,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                              ),
                                                              labelText:
                                                                  "College/University Name",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        117,
                                                                        117,
                                                                        117,
                                                                        1),
                                                              ),
                                                              filled: true,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                              fillColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          221,
                                                                          221)
                                                                  .withOpacity(
                                                                      1),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        width:
                                                                            0,
                                                                        style: BorderStyle
                                                                            .none),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextFormField(
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Required";
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (value) {
                                                              major = value;
                                                            },
                                                            controller:
                                                                majorcontroller,
                                                            cursorColor:
                                                                Colors.white,
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      117,
                                                                      117,
                                                                      117,
                                                                      1),
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  Container(
                                                                height: 60.0,
                                                                width: 60.0,
                                                                //padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            221,
                                                                            221,
                                                                            221))),
                                                              ),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .credit_score,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                              ),
                                                              labelText:
                                                                  "Major Name",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        117,
                                                                        117,
                                                                        117,
                                                                        1),
                                                              ),
                                                              filled: true,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                              fillColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          221,
                                                                          221)
                                                                  .withOpacity(
                                                                      1),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        width:
                                                                            0,
                                                                        style: BorderStyle
                                                                            .none),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          FormBuilderDropdown(
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .disabled,
                                                            name: 'iscompleted',
                                                            onChanged: (value) {
                                                              _progressTextController =
                                                                  value;
                                                              print(
                                                                  _progressTextController);
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Staus',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        117,
                                                                        117,
                                                                        117,
                                                                        1),
                                                              ),
                                                              filled: true,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                              fillColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          221,
                                                                          221,
                                                                          221)
                                                                  .withOpacity(
                                                                      1),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        width:
                                                                            0,
                                                                        style: BorderStyle
                                                                            .none),
                                                              ),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .person_outline,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                              ),
                                                            ),
                                                            validator:
                                                                FormBuilderValidators
                                                                    .compose([
                                                              FormBuilderValidators
                                                                  .required()
                                                            ]),
                                                            //allowClear: true,
                                                            items: exchangeSourceOption
                                                                .map((exchangeOptions) =>
                                                                    DropdownMenuItem(
                                                                        value:
                                                                            exchangeOptions,
                                                                        child: Text(
                                                                            '$exchangeOptions')))
                                                                .toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                print(major! +
                                                                    ' ' +
                                                                    unicollege! +
                                                                    ' ' +
                                                                    _progressTextController);
                                                                insertEducation(
                                                                    unicollege!,
                                                                    major!,
                                                                    _progressTextController
                                                                        .toString());
                                                              }
                                                            },
                                                            child:
                                                                Text("Insert")),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: Offset(0, 1),
                                            end: Offset(0, 0))
                                        .animate(anim1),
                                    child: child,
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var education in CrudFunction.UserFind['Education'])
                      InkWell(
                        onTap: () {
                          int index = CrudFunction.UserFind['Education']
                              .indexOf(education);
                          updateCollegeNamecontroller.text =
                              education['CollegeName'].toString();
                          updateMajorcontroller.text =
                              education['Major'].toString();
                          updateDurationcontroller =
                              education['Duration'].toString();
                          print(updateCollegeNamecontroller.text);
                          print(updateMajorcontroller.text);
                          print(updateDurationcontroller);
                          PreviousCollegeName =
                              education['CollegeName'].toString();
                          PreviousMajor = education['Major'].toString();
                          PreviousDuration = education['Duration'].toString();
                          showGeneralDialog(
                            barrierLabel: "Education Update",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: Duration(milliseconds: 700),
                            context: context,
                            pageBuilder: (context, anim1, anim2) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 50, left: 12, right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Scaffold(
                                        body: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          height: 500,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Required";
                                                          }
                                                          return null;
                                                        },
                                                        onChanged: (value) {
                                                          updateCollegeNamecontroller
                                                              .text = value;
                                                        },
                                                        initialValue:
                                                            updateCollegeNamecontroller
                                                                .text,
                                                        cursorColor:
                                                            Colors.white,
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon: Container(
                                                            height: 60.0,
                                                            width: 60.0,
                                                            //padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            221,
                                                                            221,
                                                                            221))),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.credit_score,
                                                            color: const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          fillColor:
                                                              Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)
                                                                  .withOpacity(
                                                                      1),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle
                                                                        .none),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Required";
                                                          }
                                                          return null;
                                                        },
                                                        onChanged: (value) {
                                                          updateMajorcontroller
                                                              .text = value;
                                                        },
                                                        initialValue:
                                                            updateMajorcontroller
                                                                .text,
                                                        cursorColor:
                                                            Colors.white,
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              117, 117, 117, 1),
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon: Container(
                                                            height: 60.0,
                                                            width: 60.0,
                                                            //padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            221,
                                                                            221,
                                                                            221))),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.credit_score,
                                                            color: const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                          ),
                                                          labelStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          fillColor:
                                                              Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)
                                                                  .withOpacity(
                                                                      1),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle
                                                                        .none),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      FormBuilderDropdown(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .disabled,
                                                        name: 'iscompleted',
                                                        onChanged: (value) {
                                                          updateDurationcontroller =
                                                              value;
                                                          print(
                                                              updateDurationcontroller);
                                                        },
                                                        initialValue:
                                                            updateDurationcontroller
                                                                .toString(),
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    117,
                                                                    117,
                                                                    117,
                                                                    1),
                                                          ),
                                                          filled: true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          fillColor:
                                                              Color.fromARGB(
                                                                      255,
                                                                      221,
                                                                      221,
                                                                      221)
                                                                  .withOpacity(
                                                                      1),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle
                                                                        .none),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .person_outline,
                                                            color: const Color
                                                                .fromRGBO(117,
                                                                117, 117, 1),
                                                          ),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required()
                                                        ]),
                                                        //allowClear: true,
                                                        items: exchangeSourceOption
                                                            .map((exchangeOptions) =>
                                                                DropdownMenuItem(
                                                                    value:
                                                                        exchangeOptions,
                                                                    child: Text(
                                                                        '$exchangeOptions')))
                                                            .toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            print(updateMajorcontroller
                                                                    .text +
                                                                ' ' +
                                                                updateCollegeNamecontroller
                                                                    .text +
                                                                ' ' +
                                                                updateDurationcontroller);
                                                            deleteEducation(
                                                                updateCollegeNamecontroller
                                                                    .text,
                                                                updateMajorcontroller
                                                                    .text,
                                                                updateDurationcontroller
                                                                    .toString(),
                                                                index);
                                                          }
                                                        },
                                                        child: Text("Delete")),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            print(updateMajorcontroller
                                                                    .text +
                                                                ' ' +
                                                                updateCollegeNamecontroller
                                                                    .text +
                                                                ' ' +
                                                                updateDurationcontroller);
                                                            updateEducation(
                                                                updateCollegeNamecontroller
                                                                    .text,
                                                                updateMajorcontroller
                                                                    .text,
                                                                updateDurationcontroller
                                                                    .toString(),
                                                                index);
                                                          }
                                                        },
                                                        child: Text("Insert")),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            transitionBuilder: (context, anim1, anim2, child) {
                              return SlideTransition(
                                position: Tween(
                                        begin: Offset(0, 1), end: Offset(0, 0))
                                    .animate(anim1),
                                child: child,
                              );
                            },
                          );
                        },
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
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print("Stats Pressed");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StatsPageFreelancer()));
                      },
                      child: const Text(
                        "Stats",
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
                    //Apply For job button Starts
                    ElevatedButton(
                      onPressed: () async {
                        print("apply for Job Pressed");
                        CrudFunction.searchJobsByCategory(
                            CrudFunction.UserFind['Title']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerJobsApply(
                                      search: false,
                                      search_word: "",
                                    )));
                      },
                      child: const Text(
                        "Apply For a Job",
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

                    ElevatedButton(
                      onPressed: () async {
                        print("view chats Pressed");
                        CrudFunction.searchJobsByCategory(
                            CrudFunction.UserFind['Title']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FreelancerChatsListScreen()));
                      },
                      child: const Text(
                        "View Chats",
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
                    //

                    //
                    //Apply For job button Ends

                    //View All Contracts Button Starts
                    ElevatedButton(
                      onPressed: () async {
                        print("View All Contracts Button Pressed");

                        await CrudFunction.filterContracts(
                            CrudFunction.UserFind['UserName']);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewAllContractsScreen()));
                      },
                      child: const Text(
                        "View All Contracts",
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
                    //View All Contracts Button Ends
                    //View Posted Porposal Button Starts
                    ElevatedButton(
                      onPressed: () {
                        CrudFunction.filterProposals(
                            CrudFunction.UserFind['UserName']);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreelancerProposals()));
                      },
                      child: const Text(
                        "View Posted Proposals",
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
                    //View Posted Porposal Button Ends

                    //Messages Button Starts

                    ElevatedButton(
                      onPressed: () {
                        CrudFunction.freelancer = null;
                        CrudFunction.thatJob = null;
                        CrudFunction.thatProposal = null;
                        CrudFunction.UserFind = null;
                        CrudFunction.ClientFind = null;
                        Server.refresh();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color.fromARGB(248, 231, 28, 28);
                          }
                          return const Color.fromARGB(248, 231, 28, 28);
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void insertskill(String newSkill) async {
    print("Inserting Skill");
    CrudFunction.insertskill(UserName, newSkill);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("skill inserted")),
    );
  }

  void skillupdate(String newSkill, String PreviousSkill) async {
    print("Inserting Skill");
    CrudFunction.skillupdate(UserName, newSkill, PreviousSkill);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("skill Updated")),
    );
  }

  void skilldelete(String PreviousSkill) async {
    print("Inserting Skill");
    CrudFunction.skilldelete(UserName, PreviousSkill);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("skill Deleted")),
    );
  }

  void insertLanguage(String newLanguage) async {
    print("Inserting Language");
    CrudFunction.insertLanguages(UserName, newLanguage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Language inserted")),
    );
  }

  void Languageupdate(String newLanguage, String PreviousLanguage) async {
    print("Inserting Skill");
    CrudFunction.Languageupdate(UserName, newLanguage, PreviousLanguage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Language Updated")),
    );
  }

  void Languagedelete(String PreviousLanguage) async {
    print("Inserting Skill");
    CrudFunction.Languagedelete(UserName, PreviousLanguage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Language Deleted")),
    );
  }

  void insertEducation(
      String collegeName, String major, String duration) async {
    print("Insering Education!!!!");
    CrudFunction.insertEducation(UserName, collegeName, major, duration);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Education inserted")),
    );
  }

  void updateEducation(
      String collegeName, String major, String duration, int index) async {
    print("Updating Education!!!!");
    print(index);
    CrudFunction.updateEducation(UserName, collegeName, major, duration, index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Education Updated")),
    );
  }

  void deleteEducation(
      String collegeName, String major, String duration, int index) async {
    print("Deleting Education!!!!");
    print(index);
    CrudFunction.deleteEducation(UserName, collegeName, major, duration, index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Education Deleted")),
    );
  }

  List<Map<String, dynamic>>? filterSkillsWhichIsNotAdded() {
    // Create a growable list instead of a fixed-length list
    var userSkillWhichNotAdded = <Map<String, dynamic>>[];
    var skillsInDb = Server.SkillsList!.toList();
    var userSkills = CrudFunction.UserFind['Skills'].cast<String>();

    for (var skillInDb in skillsInDb) {
      if (!userSkills.contains(skillInDb['SkillName'])) {
        userSkillWhichNotAdded.add({'SkillName': skillInDb['SkillName']});
      }
    }

    return userSkillWhichNotAdded;
  }

  List<Map<String, dynamic>>? filterLanguagesWhichIsNotAdded() {
    // Create a growable list instead of a fixed-length list
    var userLanguagesWhichNotAdded = <Map<String, dynamic>>[];
    var languagesInDb = Server.languagesList!.toList();
    var userLanguage = CrudFunction.UserFind['Languages'].cast<String>();

    for (var languageInDb in languagesInDb) {
      if (!userLanguage.contains(languageInDb['language'])) {
        userLanguagesWhichNotAdded.add({'language': languageInDb['language']});
      }
    }

    return userLanguagesWhichNotAdded;
  }

  void deletePortfolio(String image, String title, int index) async {
    print("Deleting Portfolio!!!!");
    print(index);
    await CrudFunction.deletePortfolio(UserName, image, title, index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreelancerHomeScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Portfolio Deleted")),
    );
  }
}
