// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
//
// class Payment {
//   static Map<String, dynamic>? paymentIntent;
//   static Future<bool> makePayment(String payAmount) async {
//     //Step 1 (Payment Intent)
//     try {
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization':
//               'Bearer sk_test_51PDuogLKbVM0YFGldXTnSDv7xEoEJbdwAiHSuM5YSFQEsdvz3jGEJrTQpKNiw1LJ5g9A8wfz7Pa7YC9pWASPcb8o00OcLWh9Ww',
//           'Content-type': 'application/x-www-form-urlencoded',
//         },
//         //100
//         body: {
//           'amount': payAmount,
//           'currency': 'USD',
//         },
//       );
//       paymentIntent = json.decode(response.body);
//     } catch (error) {
//       print('Error occurred: $error');
//       return false;
//     }
//
//     //Step 2 (Specify Payment Sheet)
//     await Stripe.instance
//         .initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: paymentIntent!['client_secret'],
//             style: ThemeMode.light,
//             merchantDisplayName: 'Farhan',
//           ),
//         )
//         .then((value) => {});
//
//     //Step 3 (Display Payment Sheet)
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) => {
//             //Success State
//             print('Payment Success'),
//           });
//       return true;
//     } catch (error) {
//       print('Error occurred: $error');
//       return false;
//     }
//   }
// }
