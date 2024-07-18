import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../server.dart';
import 'adminhomepage.dart';

class AdminClientPage extends StatefulWidget {
  const AdminClientPage({Key? key}) : super(key: key);

  @override
  State<AdminClientPage> createState() => _AdminClientPageState();
}

class _AdminClientPageState extends State<AdminClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clients',
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
                      'Clients List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true, // Ensure ListView takes only the required space
                      physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                      itemCount: Server.ClientsList!.length,
                      itemBuilder: (context, index) {
                        var clients = Server.ClientsList![index];
                        Uint8List bytes = base64.decode(clients['Image']);

                        return Card(
                          child: ListTile(
                            leading:   clients['Image'] != ""
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.memory(
                                bytes!,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                                : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                    height: 50,
                                    width: 50,
                                    'assets/images/pic_signin.png')),
                            title: Text(clients['UserName']),
                            subtitle: Text('${clients['Title']}'),
                            trailing: Text('Jobs Completed: ${clients['JobsCompleted']}'),
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
