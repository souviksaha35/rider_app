import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';


class LoginScreen extends StatelessWidget {
  static const String idScreen = "LoginScreen";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthUser(BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.yellow,
            child: Container(
                margin: EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      SizedBox(width: 5.0),
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                      SizedBox(width: 26.0),
                      Text(
                          "Authenticating, please wait...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          )
                      )
                    ],
                  ),
                )
            )
        );
      }
    );
    final User firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error in signing in" + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) {
      // save user info to database
      

      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          displayToastMessage("you are logged in", context);
        } else {
          Navigator.pop(context);
          firebaseAuth.signOut();
          displayToastMessage("No users are exist with this credentials", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("An Unknown error occured", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 5.0,),
              Image(image: AssetImage("images/logo.png"),
              width: 150.0,
              height: 200.0,
              alignment: Alignment.center,),


              Text("Login as a Rider",
              style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 14.0,),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14.0,),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                      ),
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Brand-Bold',
                              color: Colors.white,
                            ),
                          )
                        )
                      ),
                      onPressed: () {

                        if (emailTextEditingController.text.isEmpty) {
                          displayToastMessage("Email is empty", context);
                        } else if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage("Email address is invalid", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage("Password is not empty", context);
                        } else {
                          loginAndAuthUser(context);
                        }
                      },
                    )
                  ],
                )
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "Do not have a Account? Register Here",
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}