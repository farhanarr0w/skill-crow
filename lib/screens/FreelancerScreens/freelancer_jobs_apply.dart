import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Freelancer_Widgets/Categorybuttons.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Freelancer_Widgets/JobCard.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';

import '../../server.dart';
import 'Freelancer_Widgets/jobsearchcard.dart';

class FreelancerJobsApply extends StatefulWidget {
  final bool search;
  final String search_word;
  const FreelancerJobsApply(
      {super.key, required this.search, required this.search_word});

  @override
  State<FreelancerJobsApply> createState() =>
      _FreelancerJobsApplyState(search, search_word);
}

class _FreelancerJobsApplyState extends State<FreelancerJobsApply> {
  bool search;
  String search_word;
  int change = 0;

  _FreelancerJobsApplyState(this.search, this.search_word);

  final TextEditingController searchcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? searchWord;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'See Jobs',
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
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Search Here....";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      searchWord = value;
                    },
                    controller: searchcontroller,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 255, 132, 1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromARGB(255, 221, 221, 221))),
                          child: IconButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print("Search Job Pressed");
                                CrudFunction.searchJobsByCategoryandtitle(
                                    CrudFunction.UserFind['Title'],
                                    searchWord!);
                                print('in page:');
                                print(CrudFunction.filteredJobFrsearch!);
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerJobsApply(
                                                search: true,
                                                search_word: searchWord!,
                                              )));
                                });
                              } else {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerJobsApply(
                                                search: false,
                                                search_word: "",
                                              )));
                                });
                              }
                            },
                            icon: Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            ),
                          )),
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color.fromRGBO(117, 117, 117, 1),
                      ),
                      labelText: search_word,
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                          Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
              ),
              if (search == false) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 22, 16, 10),
                          child: Row(
                            children: [
                              CategoryButtons(
                                  refreshCallback: refreshJobCardView),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(0, 0, 0, 120),
                      //   height: 620,
                      //   child: JobCard(),
                      // ),
                      JobCardView(refreshCallback: refreshJobCardView),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        Server.JobCategoriesList!.length,
                                        (index) {
                                          return Container(
                                            margin: EdgeInsets.fromLTRB(
                                                16, 0, 0, 0),
                                            child: TextButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    0, 255, 132, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onPressed: () async {
                                                String selectedCat =
                                                    Server.JobCategoriesList![
                                                        index]['CategoryName'];
                                                print(selectedCat +
                                                    " " +
                                                    search_word);
                                                CrudFunction
                                                    .searchJobsByCategoryandtitle(
                                                        selectedCat,
                                                        search_word);
                                                setState(() {
                                                  // Call the callback to trigger the update of JobCardView
                                                  if (refreshJobSearchCardView !=
                                                      null) {
                                                    print('Here');
                                                    refreshJobSearchCardView!();
                                                  }
                                                });
                                              },
                                              child: Text(
                                                Server.JobCategoriesList![index]
                                                    ['CategoryName'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 650,
                        //   child: JobSearchCard(),
                        // ),
                        JobSearchCardView(refreshCallback: refreshJobCardView),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void refreshJobCardView() {
    setState(() {
      JobCardView(refreshCallback: refreshJobCardView);
    });
  }

  void refreshJobSearchCardView() {
    setState(() {
      JobSearchCardView(refreshCallback: refreshJobCardView);
    });
  }
}

class JobSearchCardView extends StatefulWidget {
  final VoidCallback? refreshCallback; //
  const JobSearchCardView({Key? key, this.refreshCallback}) : super(key: key);

  @override
  State<JobSearchCardView> createState() => _JobSearchCardViewState();
}

class _JobSearchCardViewState extends State<JobSearchCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 120),
      height: 620,
      child: JobSearchCard(),
    );
  }
}

class JobCardView extends StatefulWidget {
  final VoidCallback? refreshCallback; // Define callback function

  const JobCardView({Key? key, this.refreshCallback}) : super(key: key);

  @override
  State<JobCardView> createState() => _JobCardViewState();
}

class _JobCardViewState extends State<JobCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 120),
      height: 620,
      child: JobCard(),
    );
  }
}
