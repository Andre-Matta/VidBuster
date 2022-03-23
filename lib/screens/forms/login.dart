import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/shared/decorations.dart';
import 'package:vidbusters/providers/users.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget with ChangeNotifier {
  static Users currentuser = new Users();
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with ChangeNotifier {
  bool isLoading = false;
  String confirmemail;
  String confirmpassword;
  String status;
  String user = "user";
  String pharmacy = "pharmacy";

  Future<void> fetchusersdata() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      extractedData.forEach((userid, userdata) async {
        if (confirmemail == userdata['email'] &&
            confirmpassword == userdata['password'] &&
            pharmacy == userdata['type']) {
          Login.currentuser.email = userdata['email'];
          Login.currentuser.password = userdata['password'];
          Login.currentuser.pharmacyname = userdata['pharmacyname'];
          Login.currentuser.type = userdata['type'];
          Login.currentuser.isfound = true;
          Login.currentuser.avaliableMedicines = userdata['avaliableMedicines'];
          status = userdata['Status'];
          Login.currentuser.id = userid;
          Selected.userEmail = userid;
        } else if (confirmemail == userdata['email'] &&
            confirmpassword == userdata['password'] &&
            user == userdata['type']) {
          Login.currentuser.email = userdata['email'];
          Login.currentuser.password = userdata['password'];
          Login.currentuser.type = userdata['type'];
          Login.currentuser.isfound = true;
          Login.currentuser.id = userid;
          Selected.userEmail = userdata['email'];
        }
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> onWillPop() {
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          exit(0);
        });
    Widget cancelButton = FlatButton(
        child: Text("cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            title: Text("Exit"),
            content: Text("Are you sure you want to exit?"),
            actions: [okButton, cancelButton],
          );
        });
  }

  Widget build(BuildContext context) {
    Login.currentuser = new Users();
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 270,
                    width: 270,
                  ),
                  Form(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration:
                            textinputdecoration.copyWith(hintText: "Email"),
                        onChanged: (value) {
                          setState(() {
                            setState(() {
                              if (value.contains('.') &&
                                  value.contains('@') &&
                                  !value.contains(' ')) {
                                confirmemail = value;
                              }
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        obscureText: true,
                        decoration:
                            textinputdecoration.copyWith(hintText: "password"),
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 6) {
                              confirmpassword = value;
                            }
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.extended(
                          elevation: 10,
                          heroTag: "1",
                          label:
                              Text("sign in", style: TextStyle(fontSize: 20)),
                          backgroundColor: Colors.red,
                          onPressed: () {
                            setState(() {
                              fetchusersdata().then((_) {
                                if (Login.currentuser.isfound) {
                                  if (Login.currentuser.type == "pharmacy" &&
                                      status == "Accepted") {
                                    Navigator.pushNamed(context, '/pharmacy');
                                  } else if (Login.currentuser.type ==
                                          "pharmacy" &&
                                      status == "Waiting") {
                                    Widget okButton = FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15)),
                                            title: Text("Error"),
                                            content: Text(
                                                "Your registration request is being reviewed by the admin.\nAn email will be sent to you shortly."),
                                            actions: [okButton],
                                          );
                                        });
                                  } else if (Login.currentuser.type == "user") {
                                    Navigator.pushNamed(context, '/user');
                                  }
                                } else {
                                  Widget okButton = FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      });
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      15)),
                                          title: Text("Error"),
                                          content:
                                              Text("Wrong email or password"),
                                          actions: [okButton],
                                        );
                                      });
                                }
                              });
                            });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.extended(
                          elevation: 10,
                          heroTag: "2",
                          label: Text("sign up as user",
                              style: TextStyle(fontSize: 20)),
                          backgroundColor: Colors.red,
                          onPressed: () {
                            Navigator.pushNamed(context, '/userregisterarion');
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.extended(
                          elevation: 10,
                          heroTag: "3",
                          label: Text("sign up as pharmacy",
                              style: TextStyle(fontSize: 20)),
                          backgroundColor: Colors.red,
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/pharmacyregisteration');
                          }),
                    ],
                  ))
                ],
              ),
            ),
          ),
          onWillPop: onWillPop),
    );
  }
}
