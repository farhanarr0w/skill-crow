import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../server.dart';
import 'adminhomepage.dart';



class AdminJobsPage extends StatefulWidget {
  const AdminJobsPage({Key? key}) : super(key: key);

  @override
  State<AdminJobsPage> createState() => _AdminJobsPageState();
}

class _AdminJobsPageState extends State<AdminJobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => adminHomepage()),
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
                    Text(
                      'Jobs List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true, // Ensure ListView takes only the required space
                      physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                      itemCount: Server.JobPostsList!.length,
                      itemBuilder: (context, index) {
                        var Jobs = Server.JobPostsList![index];
                        int indextemp = index+1;
                        return Card(
                          child: ListTile(
                            leading:   Text(indextemp.toString()),
                            title: Text(Jobs['JobTitle']),
                            subtitle: Column(
                              children: [
                                AutoSizeText(
                                    '${Jobs['JobDescription']}',
                                  maxLines: 2,
                                ),
                                Text('....')
                              ],
                            ),
                            trailing: Text('Budget: \$${Jobs['Budget']}'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
