import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';


class SignupScreen extends StatelessWidget {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        // ignore: missing_return
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
                            "Signing up, Please wait...",
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
    final User firebaseUser = (await firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error in signing up" + errMsg.toString(), context);
    })).user;

    print(firebaseUser);

    if (firebaseUser != null) {
      // save user info to database
      userRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations, you account has been created", context);

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("New user account has not been created", context);
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


              Text("Register as a Rider",
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
                        keyboardType: TextInputType.name,
                        controller: nameTextEditingController,
                        decoration: InputDecoration(
                            labelText: 'Name',
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
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextEditingController,
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
                        keyboardType: TextInputType.phone,
                        controller: phoneTextEditingController,
                        decoration: InputDecoration(
                            labelText: 'Phone',
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
                        obscureText: true,
                        controller: passwordTextEditingController,
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
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Brand-Bold',
                                    color: Colors.white,
                                  ),
                                )
                            )
                        ),
                        onPressed: () {
                          if (nameTextEditingController.text.length < 4) {
                            displayToastMessage("Name must be 4 characters long", context);
                          } else if (emailTextEditingController.text.isEmpty) {
                            displayToastMessage("Email is mandatory", context);
                          } else if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage("Email address is invalid", context);
                          } else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMessage("Phone number is mandatory", context);
                          }else if (passwordTextEditingController.text.isEmpty) {
                            displayToastMessage("Password is mandatory", context);
                          } else if (passwordTextEditingController.text.length < 8) {
                            displayToastMessage("Password must be atleast 8 characters long", context);
                          } else {
                            registerNewUser(context);
                          }
                        },
                      )
                    ],
                  )
              ),

              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Already have a Account? Login Here",
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}