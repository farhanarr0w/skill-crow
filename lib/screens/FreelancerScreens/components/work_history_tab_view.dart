import 'package:flutter/material.dart';
import '../../../server.dart';

class WorkHistoryTabView extends StatefulWidget {
  final String submissionStatus, contractStatus;
  const WorkHistoryTabView({super.key, required this.submissionStatus, required this.contractStatus});

  @override
  State<WorkHistoryTabView> createState() => _WorkHistoryTabViewState();
}

class _WorkHistoryTabViewState extends State<WorkHistoryTabView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: CrudFunction.findWorkHistoryOfFreelancer(
        CrudFunction.UserFind['UserName'], 
        widget.submissionStatus, 
        widget.contractStatus
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Centered loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'), // Centered error message
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Display the list of jobs if data is available
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var job = snapshot.data![index];
              return ListTile(
                title: Text(job['JobTitle']),
                subtitle: Text(job['JobDescription']),
              );
            },
          );
        } else {
          return Center(
            child: Text('No jobs found.'), // Centered empty message
          );
        }
      },
    );
  }
}
