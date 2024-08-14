import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/Chat/contract_based_chats_list.dart';
import 'package:project_skillcrow/screens/Chat/proposal_based_chats.dart';

class ClientChatsListScreen extends StatefulWidget {
  const ClientChatsListScreen({Key? key}) : super(key: key);

  @override
  _ClientChatsListScreenState createState() => _ClientChatsListScreenState();
}

class _ClientChatsListScreenState extends State<ClientChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Contract Based",),
                Tab(text: "Proposal Based",),  
              ],
            ),
            title: const Text('Chats'),
          ),
          body: TabBarView(
            children: [
              ContractBasedChats(userType: "client",),
              ProposalBasedChats(userType: "client",),
            ],
          ),
        ),
      ),
    );
  }
}
