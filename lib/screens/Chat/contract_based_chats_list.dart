import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/Chat/client%20side%20Proposal%20Chat.dart';
import 'package:project_skillcrow/screens/Chat/client_chats_list_screen.dart';
import 'package:project_skillcrow/screens/Chat/client_side_chat.dart';
import 'package:project_skillcrow/screens/Chat/freelancer%20side%20chat.dart';
import 'package:project_skillcrow/server.dart';

class ContractBasedChats extends StatefulWidget {
  final userType;
  ContractBasedChats({super.key, required this.userType});

  @override
  State<ContractBasedChats> createState() => _ContractBasedChatsState();
}

class _ContractBasedChatsState extends State<ContractBasedChats> {
  List chats = List.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.userType=="freelancer"){
      chats= CrudFunction.findContractBasedChatsFreelancer(CrudFunction.UserFind['UserName'].toString());
    }else{
      chats=CrudFunction.findContractBasedChatsClient(
      CrudFunction.ClientFind['UserName'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("chats: +$chats");
    return Scaffold(
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (itemBuilder, index) {
            dynamic proposalId = chats[index]['ProposalId'];
            String lastMessage = chats[index]['Messages'].isNotEmpty
                ? chats[index]['Messages'].last['messageContent']
                : '';

            var image = CrudFunction.freelancerProfilePic(
                chats[index]['FreelancerName']);

            Uint8List bytes = base64.decode(image!);

            return ListTile(
              leading: (image.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.memory(
                        bytes,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                          height: 80,
                          width: 80,
                          'assets/images/pic_signin.png')),
              title: (widget.userType == "client")
                  ? Text(chats[index]['FreelancerName'])
                  : Text(chats[index]['ClientName']),
              subtitle: Text(lastMessage),
              onTap: () async {
                String sess = chats[index]['ClientName'] +
                    chats[index]['FreelancerName'] +
                    proposalId.toString();
                print(sess);
                //await fetching.getChatDataBySession(sess);
                await CrudFunction.filterchat(sess);
                print(proposalId);
                await CrudFunction.getProposals(proposalId);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>(widget.userType=="client")? ClientSideChat(
                      checkclientfreelancer: 'Client',
                      proposalidget: proposalId.toString(),
                      chatCredentials: {
                        "FreelancerUsername": chats[index]['FreelancerName'],
                        "ClientUsername":
                            CrudFunction.ClientFind['UserName'].toString(),
                        "JobID": chats[index]['JobID'],
                        "_id": "Invited Contract",
                        "Session": sess
                      },
                    ):FreelancerSideChatScreen(checkclientfreelancer: 'freelancer', proposalidget: proposalId.toString()),
                  ),
                );
              },
            );
          }),
    );
  }
}