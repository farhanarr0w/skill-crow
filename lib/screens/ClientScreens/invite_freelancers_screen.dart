import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_skillcrow/screens/ClientScreens/freelancerProfileView.dart';
import 'package:project_skillcrow/screens/ClientScreens/job_activity.dart';
import 'package:project_skillcrow/server.dart';

class InviteFreelancersScreen extends StatefulWidget {
  const InviteFreelancersScreen({super.key});

  @override
  State<InviteFreelancersScreen> createState() =>
      _InviteFreelancersScreenState();
}

class _InviteFreelancersScreenState extends State<InviteFreelancersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'Search for freelancers...',
                  filled: true,
                  fillColor: Color.fromARGB(255, 218, 218, 218),
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  )),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(child: FreelancersList(searchQuery: _searchQuery)),
        ],
      ),
    );
  }
}

class FreelancersList extends StatefulWidget {
  final String searchQuery;
  const FreelancersList({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _FreelancersListState createState() => _FreelancersListState();
}

class _FreelancersListState extends State<FreelancersList> {
  var freelancers;

  @override
  void initState() {
    super.initState();
    // Simulating data fetching from the database
    fetchFreelancers();
  }

  void fetchFreelancers() {
    // Simulated data
    var data = CrudFunction.recommendedFreelancers;
    setState(() {
      freelancers = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filteredFreelancers = freelancers
        .where((freelancer) =>
            freelancer['FirstName']
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()) ||
            freelancer['Title']
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredFreelancers.length,
      itemBuilder: (context, index) {
        return FreelancerCard(freelancer: filteredFreelancers[index]);
      },
    );
  }
}

class FreelancerCard extends StatefulWidget {
  final Map<String, dynamic> freelancer;

  const FreelancerCard({
    Key? key,
    required this.freelancer,
  }) : super(key: key);

  @override
  _FreelancerCardState createState() => _FreelancerCardState();
}

class _FreelancerCardState extends State<FreelancerCard> {
  bool isButtonActive = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Adds shadow effect
      shadowColor: Colors.grey.withOpacity(0.5), // Customize shadow color
      margin: EdgeInsets.all(10),
      child: ListTile(
        iconColor: Color.fromARGB(255, 0, 255, 72),
        splashColor: Color.fromARGB(255, 0, 255, 149),
        tileColor: Color.fromARGB(255, 255, 255, 255),
        leading: CircleAvatar(
          child: Text(widget.freelancer['FirstName'][0]),
        ),
        title: Text(
          widget.freelancer['FirstName'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${widget.freelancer['Title']}'),
            Text('Total Jobs Done: ${widget.freelancer['TotalJobs']}'),
            Text('Job Success Score: ${widget.freelancer['JSS']}%'),
            Text('Total Earnings: \$${widget.freelancer['TotalEarnings']}'),
            Text('Skills: ${widget.freelancer['Skills']}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.person_add),
          onPressed: isButtonActive
              ? () async {
                  CrudFunction.InviteUserView = widget.freelancer;
                  await CrudFunction.filterContracts(
                      CrudFunction.InviteUserView['UserName']);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FreelancerProfileView()),
                    (route) => false,
                  );
                  setState(() {
                    isButtonActive = false;
                  });
                }
              : null,
        ),
        onTap: () {
          print(
              '${widget.freelancer['FirstName']} ${widget.freelancer['LastName']}');
          // Add your freelancer details page navigation here
        },
      ),
    );
  }
}
