import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../server.dart';
import 'adminhomepage.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
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
                      'Categories List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true, // Ensure ListView takes only the required space
                      physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                      itemCount: Server.JobCategoriesList!.length,
                      itemBuilder: (context, index) {
                        var Categories = Server.JobCategoriesList![index];
                        int indextemp = index+1;
                        return Card(
                          child: ListTile(
                            leading:   Text(indextemp.toString()),
                            title: Text(Categories['CategoryName']),
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
    );  }
}
