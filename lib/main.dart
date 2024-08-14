import 'package:flutter/material.dart';
import 'package:project_skillcrow/Singleton/MongoDb.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:project_skillcrow/abc.dart';
import 'package:project_skillcrow/screens/ClientScreens/client_home.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/signin_screen.dart';
import 'package:project_skillcrow/screens/welcome_screen.dart';
import 'package:project_skillcrow/server.dart';

import 'screens/adminScreens/AdminLogin.dart';

//flutter build apk
void main() async {
  // Stripe.publishableKey =
  //     "pk_test_51PDuogLKbVM0YFGlZYScuHcLkOnY6Z1x6zzdhUNkIFd4imXpq9PyH5OIMNWfddfo3XspcTgyhvDxH3fRm3zt86UC00Po6Yd9C1";
  WidgetsFlutterBinding.ensureInitialized();
  await Server.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
