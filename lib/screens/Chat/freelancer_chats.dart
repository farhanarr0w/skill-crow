// import 'package:flutter/material.dart';
// import 'package:project_skillcrow/screens/Chat/client%20side%20Chat.dart';
// import 'package:project_skillcrow/screens/Chat/freelancer%20side%20chat.dart';
// import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
//
// import '../../server.dart';
// import '../../user_fetch.dart';
//
// class freelancerChats extends StatefulWidget {
//   const freelancerChats({Key? key}) : super(key: key);
//
//   @override
//   State<freelancerChats> createState() => _freelancerChatsState();
// }
//
// class _freelancerChatsState extends State<freelancerChats> {
//   fetching f = new fetching();
//   String UserName = CrudFunction.UserFind['UserName'];
//   String length = fetching.chatdataget.length.toString();
//
//   @override
//   Widget build(BuildContext context) {
//     print(UserName);
//     print(length);
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(0, 255, 132, 1),
//         title: Text("Chats"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => FreelancerHomeScreen()),
//                   (route) => false,
//             );
//           },
//         ),
//       ),
//       body: Padding(
//         padding:
//         const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: int.parse(length),
//                 itemBuilder: (BuildContext context, int index) {
//                   var lastMessage =
//                       fetching.chatdataget[index]['Messages'].last;
//                   return Card(
//                     child: InkWell(
//                       onTap: () async {
//                         String _proposalid = fetching.chatdataget[index]
//                         ['ProposalId']
//                             .toString();
//                         String sess = fetching.chatdataget[index]
//                         ['ClientName'] +
//                             fetching.chatdataget[index]['FreelancerName'] +
//                             fetching.chatdataget[index]['ProposalId']
//                                 .toString();
//                         print(sess);
//                         print(_proposalid);
//                         await fetching.getChatDataBySession(sess);
//                         //print(fetching.chatdataget['Date']);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => FreelancerSideChatScreen(
//                               checkclientfreelancer: 'Freelancer',
//                               proposalidget: _proposalid,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(100),
//                                     child: Image.asset(
//                                       'assets/images/pic_signin.png',
//                                       height: 60,
//                                       width: 60,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 30,
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(fetching.chatdataget[index]
//                                       ['ClientName']),
//                                       if (lastMessage['isfile'] == false) ...[
//                                         Text(lastMessage['messageContent'])
//                                       ],
//                                       if (lastMessage['isfile'] == true) ...[
//                                         Row(
//                                           children: [
//                                             Icon(Icons.file_copy),
//                                             Text('File'),
//                                           ],
//                                         )
//                                       ],
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               Text(lastMessage['time']),
//                             ],
//                           ),
//                           Divider(),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
