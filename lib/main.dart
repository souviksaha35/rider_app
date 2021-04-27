import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/LoginScreen.dart';
import 'package:rider_app/AllScreens/SearchScreen.dart';
import 'package:rider_app/AllScreens/SignupScreen.dart';
import 'package:rider_app/AllScreens/mainScreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/DataHandler/appData.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Taxi Rider App',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/signup': (context) => SignupScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => MainScreen(),
          '/loader': (context) => ProgressDialog(),
          '/search': (context) => SearchScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}