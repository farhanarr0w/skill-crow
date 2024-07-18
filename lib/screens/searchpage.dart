// import 'package:flutter/material.dart';
//
// import '../user_fetch.dart';
// import 'FreelancerScreens/Freelancer_Widgets/JobCard.dart';
// import 'FreelancerScreens/freelancer_jobs_apply.dart';
//
// class searchPage extends StatefulWidget {
//   final String searchword;
//   const searchPage({Key? key, required this.searchword}) : super(key: key);
//
//   @override
//   State<searchPage> createState() => _searchPageState(searchword);
// }
//
// class _searchPageState extends State<searchPage> {
//   fetching f = new fetching();
//
//
//   String searchword;
//   _searchPageState(this.searchword);
//   @override
//   Widget build(BuildContext context) {
//
//
//     print(searchword);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Search results',
//           style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
//         ),
//         backgroundColor: Color.fromRGBO(0, 255, 132, 1),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => FreelancerJobsApply()),
//                   (route) => false,
//             );
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Container(
//             height: 572,
//             child: ListView.builder(
//               itemCount: f.getsearchList().length,
//               itemBuilder: (context, index) {
//                 //if(f.getListByCat()[index]['JobTitle'] == searchword){
//                   return Container(
//                     height: 300,
//                     margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
//                     padding: EdgeInsets.fromLTRB(16, 16, 5, 16),
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 0,
//                           blurRadius: 2,
//                           offset: Offset(1, 2),
//                         )
//                       ],
//                       borderRadius: const BorderRadius.all(Radius.circular(20)),
//                       color: Color(0xFFe9fbf2),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${f.getListByCat()[index]['JobTitle']}',
//                               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '${f.getListByCat()[index]['JobCategory']}',
//                               style: TextStyle(fontSize: 18, color: Color(0xFF4d4d4d)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                               child: Text(
//                                 '${f.getListByCat()[index]['JobDescription']}',
//                                 style: TextStyle(fontSize: 18, color: Color(0xFF4d4d4d)),
//                               ),
//                             ),
//                           ],
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             //show(context, "You have applied to this job", "success");
//                           },
//                           child: const Text(
//                             "Apply For a Job",
//                             style: TextStyle(
//                                 color: Color.fromARGB(255, 43, 43, 43),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith((states) {
//                               if (states.contains(MaterialState.pressed)) {
//                                 return const Color.fromRGBO(0, 255, 132, 1);
//                               }
//                               return const Color.fromRGBO(0, 255, 132, 1);
//                             }),
//                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 // }
//                 // else{
//                 //   return Container();
//                 // }
//               },
//             ),
//           )),
//      );
//   }
// }
