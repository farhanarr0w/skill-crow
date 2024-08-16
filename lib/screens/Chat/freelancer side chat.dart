import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../server.dart';
import '../../user_fetch.dart';
import '../ClientScreens/proposals_view_screen.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:web_socket_channel/status.dart' as status;

class FreelancerSideChatScreen extends StatefulWidget {
  final String? checkclientfreelancer, proposalidget;
  const FreelancerSideChatScreen(
      {Key? key,
      required this.checkclientfreelancer,
      required this.proposalidget})
      : super(key: key);

  @override
  State<FreelancerSideChatScreen> createState() =>
      _FreelancerSideChatScreenState(checkclientfreelancer!, proposalidget!);
}

class _FreelancerSideChatScreenState extends State<FreelancerSideChatScreen> {

  String? checkclientfreelancer;
  String? proposalidget;
  _FreelancerSideChatScreenState(
      this.checkclientfreelancer, this.proposalidget);


  String freelancername = CrudFunction.chatfind['FreelancerName'];
  String clientname = CrudFunction.chatfind['ClientName'];
  mongo.ObjectId jobid = CrudFunction.chatfind['JobID'];
  String proposalid = CrudFunction.chatfind['ProposalId'];
  ScrollController _scrollController = ScrollController();

  final TextEditingController messageController = TextEditingController();
  List<String> messages = []; // Store messages
  List<String> rolearray = [];
  List<bool> isfilearray = [];
  late WebSocketChannel channel;
  var checkrole = "";

  final contentController = TextEditingController();
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedFile;
  bool isLoading = false;
  bool isNull = true;
  File? fileToDisply;
  String? base64String;
  String? filetemp;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        isNull = false;
        _fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisply = File(pickedFile!.path.toString());

        List<int> fileBytes = await fileToDisply!.readAsBytes();
        base64String = base64.encode(fileBytes);
        print("File Name: $_fileName");
        setState(() {
          contentController.text = _fileName!;
          isfilearray.add(true);
          messages.add(base64String!);
          rolearray.add("Freelancer");
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize WebSocket connection
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.40.219:8080/'));
    print('WebSocket connection established');

    // Listen for incoming messages
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      print('Message received: $data');
      if (data['operationType'] == 'insert') {
        if (data['fullDocument'] != null &&
            data['fullDocument']['Messages'] != null) {
          setState(() {
            checkrole = data['fullDocument']['Messages'].last['role'];
            if (checkrole == clientname) {
              messages
                  .add(data['fullDocument']['Messages'].last['messageContent']);
            }
            scrollToBottom();
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
                checkrole = value['role'];
                if (checkrole == clientname) {
                  messages.add(value['messageContent']);
                  rolearray.add("Client");
                  if (value['isfile'] == true) {
                    isfilearray.add(true);
                  } else {
                    isfilearray.add(false);
                  }
                }
                scrollToBottom();
              });
            }
          });
        } else {
          print(
              'Received data does not contain expected updateDescription or updatedFields.');
        }
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });

    // Scroll to the bottom when the widget is first built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollToBottom();
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  Widget build(BuildContext context) {
    Server.refresh();
    print(proposalid);
    String sessionfromdatabase;
    int messagelength;
    if (CrudFunction.chatfind != null) {
      sessionfromdatabase =
      CrudFunction.chatfind['Session']; // Use the value of session as needed
      messagelength = CrudFunction.chatfind['Messages'].length;
    } else {
      sessionfromdatabase = "";
      messagelength = 0;
      // Handle the case when fetching.chatdataget is null
    }

    DateTime now = DateTime.now();
    print(checkclientfreelancer);
    print('currentsession: ' + sessionfromdatabase);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        title: Text("Chat With $clientname"),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false, // Reverse the list to start from the bottom
              itemCount: messagelength + messages.length,
              itemBuilder: (BuildContext context, int index) {
                // Check if the message is from the fetched data or the new messages
                if (CrudFunction.chatfind != null || index != 0) {
                  if (index < CrudFunction.chatfind['Messages'].length) {
                    // Message from fetched data
                    var message = CrudFunction.chatfind['Messages'][index];
                    bool isClientMessage;
                    if (message['role'] ==
                        CrudFunction.chatfind['FreelancerName']) {
                      isClientMessage = true;
                    } else {
                      isClientMessage = false;
                    }

                    Uint8List? bytes;

                    if (message['isfile'] == true) {
                      bytes = base64.decode(message['messageContent']);
                    }

                    print('indexcount' + index.toString());
                    return Align(
                      alignment: isClientMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isClientMessage ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message['isfile'] == false) ...[
                              Text(
                                message['messageContent'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              // Adding space between message content and date
                              Text(
                                message['time'],
                                // Assuming 'date' is the key for the message date
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10), // Adjust font size as needed
                              ),
                            ],
                            if (message['isfile'] == true) ...[
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Image"),
                                        content: Image.memory(
                                          bytes!,
                                          fit: BoxFit.cover,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                              // Optionally, you can trigger any further action here
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.memory(
                                      bytes!,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 5),
                                    // Adding space between message content and date
                                    Text(
                                      message['time'],
                                      // Assuming 'date' is the key for the message date
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              10), // Adjust font size as needed
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Message from new messages

                    print(isfilearray);
                    print(messages);
                    print(rolearray);
                    if (index < messagelength + messages.length || index != 0) {
                      var newMessageIndex = index - messagelength;
                      print(isfilearray[newMessageIndex]);
                      print(messages[newMessageIndex]);
                      print(rolearray[newMessageIndex]);
                      print('index' + newMessageIndex.toString());
                      return MessageBubble(
                        message: messages[newMessageIndex],
                        role: rolearray[newMessageIndex],
                        isfile: isfilearray[newMessageIndex],
                      );
                      // Rest of the code
                    }
                  }
                }
              },
            ),
          ),
          BottomAppBar(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ValueListenableBuilder(
                          valueListenable: contentController,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Text(
                                        "Attachments",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    isLoading
                                        ? CircularProgressIndicator()
                                        : TextButton(
                                            onPressed: () {
                                              pickFile();
                                            },
                                            child: Text(
                                              "Upload",
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    0, 255, 132, 1),
                                                fontSize: 16,
                                              ),
                                            )),
                                    SizedBox(
                                      child: Text(
                                        isNull
                                            ? ''
                                            : contentController
                                                .text!, // Updated to use filenametemp
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 65, 140, 253),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        "You may attach files here that include work samples or other documents to support your application. Do not attach your resume — your SkillCrow profile is automatically forwarded to the client with your proposal.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 107, 107, 107)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            String date =
                                                "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}";
                                            String time =
                                                "${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";
                                            if (contentController
                                                .text.isEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Fail"),
                                                      content: Text(
                                                          "Please Selecte a file"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                            // Optionally, you can trigger any further action here
                                                          },
                                                          child: Text("OK"),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              //messages.add(contentController.text);
                                              insertchat(
                                                  freelancername,
                                                  clientname,
                                                  base64String.toString(),
                                                  date,
                                                  time,
                                                  jobid,
                                                  proposalidget!,
                                                  checkclientfreelancer!,
                                                  true);
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Success"),
                                                    content: Text(
                                                        "Your file is submitted."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          // Optionally, you can trigger any further action here
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.upload,
                      size: 30,
                    ),
                    color: Color.fromRGBO(0, 255, 132, 1),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2,
                              color: Color.fromARGB(255, 221, 221, 221),
                            ),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.credit_score,
                          color: const Color.fromRGBO(117, 117, 117, 1),
                        ),
                        labelText: "Enter Message",
                        labelStyle: const TextStyle(
                          color: Color.fromRGBO(117, 117, 117, 1),
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor:
                            Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        setState(() {
                          String date =
                              "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}";
                          String time =
                              "${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";
                          print(messageController.text +
                              freelancername +
                              clientname +
                              date +
                              time);
                          print(jobid);
                          print(proposalid);
                          messages.add(messageController.text);
                          rolearray.add('Freelancer');
                          isfilearray.add(false);
                          insertchat(
                              freelancername,
                              clientname,
                              messageController.text,
                              date,
                              time,
                              jobid,
                              proposalidget!,
                              checkclientfreelancer!,
                              false);
                          messageController.clear();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Color(0), // Set background color to transparent
                            duration: Duration(seconds: 1),
                            content: Container(
                              margin: EdgeInsets.only(bottom: 70.0),
                              padding: EdgeInsets.all(
                                  10.0), // Optional: Add padding to the text
                              decoration: BoxDecoration(
                                color: Colors
                                    .black, // Set text background color to black
                                borderRadius: BorderRadius.circular(
                                    8.0), // Optional: Add border radius for rounded corners
                              ),
                              child: Text(
                                'Message is required!',
                                style: TextStyle(
                                    color: Colors
                                        .white), // Optional: Set text color
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                    ),
                    color: Color.fromRGBO(0, 255, 132, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String role;
  final bool isfile;

  const MessageBubble(
      {required this.message, required this.role, required this.isfile});

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;

    if (isfile == true) {
      bytes = base64.decode(message);
    }
    print(isfile.toString() + '' + message);
    DateTime now = DateTime.now();
    String time =
        "${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";

    bool isClientMessage;
    if (role == 'Freelancer') {
      isClientMessage = true;
    } else {
      isClientMessage = false;
    }

    return Align(
      alignment: isClientMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isClientMessage
              ? Colors.green
              : Colors
                  .grey, // Use green for client message and grey for freelancer message
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            if (isfile == true) ...[
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Image"),
                        content: Image.memory(
                          bytes!,
                          fit: BoxFit.cover,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Optionally, you can trigger any further action here
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Image.memory(
                      bytes!,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 5),
                    // Adding space between message content and date
                    Text(
                      time,
                      // Assuming 'date' is the key for the message date
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10), // Adjust font size as needed
                    ),
                  ],
                ),
              ),
            ],
            if (isfile == false) ...[
              Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                      height:
                          5), // Adding space between message content and date
                  Text(
                    time, // Assuming 'date' is the key for the message date
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10), // Adjust font size as needed
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Helper function to format single-digit numbers with leading zeros
String _formatNumber(int number) {
  return number.toString().padLeft(2, '0');
}

void insertchat(
    String _freelancername,
    String _clientname,
    String _messageContent,
    String _date,
    String _time,
    mongo.ObjectId _jobid,
    String _proposalid,
    String role,
    bool _isfile) async {
  print("Insert Chat Function!!!!");
  var _id = mongo.ObjectId();
  print(_clientname + _freelancername + _id.toString());
  String session = _clientname + _freelancername + _proposalid;
  Map<String, dynamic> message;

  if (role == "Client") {
    message = {
      'messageContent': _messageContent,
      'role': _clientname, // Assuming the client is the sender
      'time': _time, 'isfile': _isfile,
    };
  } else {
    message = {
      'messageContent': _messageContent,
      'role': _freelancername, // Assuming the client is the sender
      'time': _time, 'isfile': _isfile,
    };
  }
  // Check if the session already exists
  final db = await mongo.Db.create(MONGO_URL);
  await db.open();
  final collection = db.collection(CHAT_COLLECTION);
  final query = mongo.where.eq('Session', session);
  final existingSession = await collection.findOne(query);

  if (existingSession != null) {
    // If session exists, update the chat data by adding the new message
    final update = mongo.ModifierBuilder().push('Messages', message);
    await collection.update(query, update);
    Server.refresh();


  } else {
    // If session does not exist, insert the whole data including the new message
    CrudFunction.InsertChat(
      _clientname,
      _freelancername,
      _jobid,
      _proposalid,
      [message], // Pass the message as a single-element list
      _date,
      session,
    );
  }

  await db.close();
}
