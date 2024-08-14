import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skillcrow/payment.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_jobs_view.dart';
import 'package:project_skillcrow/screens/ClientScreens/proposals_view_screen.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/server.dart';

class SendContract extends StatefulWidget {
  const SendContract({super.key});

  @override
  State<SendContract> createState() => _SendContractState();
}

class _SendContractState extends State<SendContract> {
  TextEditingController _amountController =
      TextEditingController(text: '${CrudFunction.thatJob!['Budget']}');
  TextEditingController _contractDescriptionController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Contract"),
        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProposalsViewScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contract Details",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  CrudFunction.thatJob['JobTitle'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 40,
              ),
              Text(
                CrudFunction.thatJob['JobDescription'],
                style: TextStyle(fontSize: 16),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Terms",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Set a fixed amount for the contract",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Amount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Total amount you will pay to the freelancer upon completion of the project.",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter amount to put in the escrow";
                  } else if (double.parse(value) < 10) {
                    return "Minimum amount for any contract is \$10";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: _amountController,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Color.fromRGBO(117, 117, 117, 1),
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: const Color.fromRGBO(117, 117, 117, 1),
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
              ),
              Divider(
                height: 40,
              ),
              Text(
                "Contract Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Contract description is required";
                    }
                    return null;
                  },
                  maxLines: 15,
                  controller: _contractDescriptionController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Provide a description about the project...',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor:
                        Color.fromARGB(255, 221, 221, 221).withOpacity(1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // double payAmount =
                          //     double.parse(_amountController.text) * 100;
                          //int convertedAmount = payAmount.toInt();
                        
                          // bool _transaction = await Payment.makePayment(
                          //     convertedAmount.toString());
                        
                          // if (_transaction == true) {
                            print("Payment is Successful");
                        
                            // var now = DateTime.now();
                            // var bsonDate = DateTime.fromMillisecondsSinceEpoch(
                            //     now.millisecondsSinceEpoch,
                            //     isUtc: true);
                        
                            CrudFunction.sendContract(
                                CrudFunction.thatProposal['_id'],
                                CrudFunction.thatJob['_id'],
                                CrudFunction.ClientFind['UserName'],
                                CrudFunction.freelancer['UserName'],
                                int.parse(_amountController.text),
                                int.parse(_amountController.text),
                                0,
                                _contractDescriptionController.text,
                                "pending",
                                "not started",
                                null);
                            show(
                                context,
                                "Contract has been sent to the freelancer",
                                "success");
                                Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) =>
                            //             ClientedJobsView())));
                          // } else {
                          //   print("Payment is Failed");
                          // }
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        backgroundColor: const Color.fromRGBO(0, 255, 132, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientedJobsView(),
                              ));
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromRGBO(0, 255, 132, 1)),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
