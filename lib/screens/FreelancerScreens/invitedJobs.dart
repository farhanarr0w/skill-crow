import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/server.dart';

class InvitedJobs extends StatefulWidget {
  const InvitedJobs({super.key});

  @override
  State<InvitedJobs> createState() => _InvitedJobsState();
}

class _InvitedJobsState extends State<InvitedJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invited Jobs',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FreelancerHomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: CrudFunction.filteredFRInvites!.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              tileColor: Colors.white,
              title: AutoSizeText(
                CrudFunction.filteredFRInvites![index]['JobTitle'],
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
                  AutoSizeText(
                    'Description: ${CrudFunction.filteredFRInvites![index]['JobDescription']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  AutoSizeText(
                    'Budget: \$${CrudFunction.filteredFRInvites![index]['Budget']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    width: 130,
                    height: 40,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 255, 132, 1),
                      borderRadius: BorderRadius.circular((90)),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See Offer',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
