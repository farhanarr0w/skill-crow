import 'package:flutter/material.dart';
import 'package:project_skillcrow/screens/Chat/contract_based_chats_list.dart';
import 'package:project_skillcrow/screens/Chat/proposal_based_chats.dart';

class FreelancerChatsListScreen extends StatefulWidget {
  const FreelancerChatsListScreen({super.key});

  @override
  State<FreelancerChatsListScreen> createState() => _FreelancerChatsListScreenState();
}

class _FreelancerChatsListScreenState extends State<FreelancerChatsListScreen> {
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
              ContractBasedChats(userType: "freelancer",),
              ProposalBasedChats(userType:"freelancer"),
            ],
          ),
        ),
      ),
    );
  }
}