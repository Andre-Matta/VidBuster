import 'package:flutter/material.dart';
import 'package:vidbusters/shared/decorations.dart';
import 'package:vidbusters/providers/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRegistration extends StatefulWidget {
  static Users curruser = new Users();
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  List<bool> _loading1 = [false, false, true];

  bool isfound = false;

  Future<void> fetchusersdata() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      extractedData.forEach((userid, userdata) async {
        if (UserRegistration.curruser.email == userdata['email']) {
          isfound = true;
        }
      });
    } catch (error) {
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/logo.png'),
                height: 200,
                width: 200,
              ),
              Form(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: textinputdecoration.copyWith(
                      hintText: "Email",
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.contains('.') &&
                            value.contains('@') &&
                            !value.contains(' ')) {
                          _loading1[0] = true;
                          UserRegistration.curruser.email = value;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration:
                        textinputdecoration.copyWith(hintText: "Password"),
                    onChanged: (value) {
                      setState(() {
                        if (value.length > 6) {
                          UserRegistration.curruser.password = value;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: textinputdecoration.copyWith(
                        hintText: "Confirm Password"),
                    onChanged: (value) {
                      setState(() {
                        if (value == UserRegistration.curruser.password) {
                          _loading1[1] = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                      elevation: 10,
                      heroTag: "2",
                      label: Text("sign up", style: TextStyle(fontSize: 20)),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (_loading1[0] && _loading1[1]) {
                            fetchusersdata().then((value) {
                              if (!isfound) {
                                Navigator.pushNamed(context, '/userwaiting');
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
                                                new BorderRadius.circular(15)),
                                        title: Text("Error"),
                                        content:
                                            Text("This email is already taken"),
                                        actions: [okButton],
                                      );
                                    });
                                isfound = false;
                              }
                            });
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
                                            new BorderRadius.circular(15)),
                                    title: Text("Error"),
                                    content:
                                        Text("Please enter all information"),
                                    actions: [okButton],
                                  );
                                });
                          }
                        });
                      }),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
