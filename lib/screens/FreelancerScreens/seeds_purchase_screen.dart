import 'package:flutter/material.dart';
import 'package:project_skillcrow/payment.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_home_screen.dart';
import 'package:project_skillcrow/server.dart';

class ConnectsPurchase extends StatefulWidget {
  const ConnectsPurchase({super.key});

  @override
  State<ConnectsPurchase> createState() => _ConnectsPurchaseState();
}

class _ConnectsPurchaseState extends State<ConnectsPurchase> {
  TextEditingController _seedController = TextEditingController(text: '1');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Add listener to update UI whenever text field content changes
    _seedController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    _seedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 132, 1),
        title: Text("Seeds Purchase"),
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your available seeds: ${CrudFunction.UserFind['Seeds']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Divider(),
              Text(
                'Enter the amount of seeds you want to buy:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _seedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value == '0') {
                    return 'Please enter some amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              Text(
                _seedController.text == '' || _seedController.text == '0'
                    ? 'Your account will be charged \$0'
                    : 'Your account will be charged \$${(double.parse(_seedController.text) * 0.5).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Text(
                _seedController.text == ''
                    ? 'Your new seeds balance will be: ${CrudFunction.UserFind['Seeds']}'
                    : 'Your new seeds balance will be: ${int.parse(_seedController.text) + CrudFunction.UserFind['Seeds']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Btn(context, "Buy Seeds", () async {
                    // if (_formKey.currentState!.validate()) {
                    //   String payAmount =
                    //       (double.parse(_seedController.text) * 0.5)
                    //           .toStringAsFixed(2);
                    //
                    //   String convertedPayAmount =
                    //       (double.parse(payAmount) * 100).toStringAsFixed(0);
                    //
                    //   print(convertedPayAmount);
                    //
                    //   if (await Payment.makePayment(convertedPayAmount)) {
                    //     show(context, "Seeds Purchased", 'success');
                    //     SeedsPurchase(int.parse(_seedController.text));
                    //   } else {
                    //     show(context, "Transaction not performed", 'error');
                    //   }
                    // }
                  }),
                  SizedBox(width: 10.0),
                  Btn(context, "Cancel", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => FreelancerHomeScreen())));
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SeedsPurchase(int amountEntered) {
    print("Seeds Purchasing");
    CrudFunction.UserFind['Seeds'] += amountEntered;
    CrudFunction.updateSeeds(
        CrudFunction.UserFind['UserName'], CrudFunction.UserFind['Seeds']);
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => FreelancerHomeScreen())));
    print('Seeds Purchased');
  }
}
