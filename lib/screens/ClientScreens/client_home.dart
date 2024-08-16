// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_skillcrow/abc.dart';
import 'package:project_skillcrow/screens/Chat/client_chats_list_screen.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_job_post.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/screens/ClientScreens/view_all_client_contracts.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../reusable_widgets/notification_api.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHome();
}

class _ClientHome extends State<ClientHome> {
  late final LocalNotificationService service;

  late WebSocketChannel channel;
  var checkrole = "";
  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.40.219:8080/'));
    print('WebSocket connection established');

    channel.stream.listen((message) {
      try {
        final data = jsonDecode(message);
        print('Message received: $data');
        String UserName = CrudFunction.ClientFind['UserName'];


        if (data['operationType'] == 'insert') {
          if (data['fullDocument'] != null &&
              data['fullDocument']['Messages'] != null) {
            setState(() {
              if(UserName != data['fullDocument']['Messages'].last['role']){
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
                  if(UserName != value['role']){
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
    CrudFunction.displaySkills = [];
    CrudFunction.AllSkills = [];
    for (var items in Server.SkillsList!) {
      CrudFunction.AllSkills.add(items['SkillName']);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: const Color.fromRGBO(0, 255, 132, 1),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage('assets/images/pic_signin.png'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                CrudFunction.ClientFind['FirstName'],
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 7),
                              InkWell(
                                onTap: () {},
                                child: const CircleAvatar(
                                  radius: 12,
                                  child: Icon(Icons.check_circle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((90)),
                  ),
                  child: ElevatedButton(
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      CrudFunction.searchJobsByClient(
                          CrudFunction.ClientFind['UserName']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientedJobsView(),
                        ),
                      );
                    },
                    child: const Text(
                      "View Your Posted Jobs",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  width: 200,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((90)),
                  ),
                  child: ElevatedButton(
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientJobPost(),
                        ),
                      );
                    },
                    child: const Text(
                      "Post a new Job",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  width: 200,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((90)),
                  ),
                  child: ElevatedButton(
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      print("View All Contracts Button Pressed");

                      await CrudFunction.filterClientContracts(
                          CrudFunction.ClientFind['UserName']);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAllClientContracts()));
                    },
                    child: const Text(
                      "View Contracts",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                Container(
                  width: 200,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((90)),
                  ),
                  child: ElevatedButton(
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      print("View All Contracts Button Pressed");

                      await CrudFunction.filterClientContracts(
                          CrudFunction.ClientFind['UserName']);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>const ClientChatsListScreen()));
                    },
                    child: const Text(
                      "View Chats",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                
                Container(
                  width: 200,
                  height: 55,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((90)),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(255, 255, 255, 255);
                        }
                        return const Color.fromARGB(255, 255, 255, 255);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 231, 6, 6))),
                      ),
                    ),
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
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          color: Color.fromARGB(255, 231, 6, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
