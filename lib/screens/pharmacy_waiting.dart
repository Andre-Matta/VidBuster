import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vidbusters/screens/forms/pharmacy_registration.dart';

class PharmacyWaiting extends StatefulWidget {
  @override
  _PharmacyWaitingState createState() => _PharmacyWaitingState();
}

class _PharmacyWaitingState extends State<PharmacyWaiting>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _paddRight;
  Animation<double> _paddLeft;
  bool accepted = false, rejected = false;

  Future<void> fetchusersdata() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      extractedData.forEach((userid, userdata) async {
        if (PharmacyRigestraion.curruser.email == userdata['email']) {
          if (userdata['Status'] == "Accepted") {
            accepted = true;
            rejected = false;
          } else if (userdata['Status'] == "Rejected") {
            accepted = false;
            rejected = true;
          } else {
            accepted = false;
            rejected = false;
          }
        }
      });
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _controller.forward();

    _paddRight = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 200), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 200, end: 0), weight: 1)
    ]).animate(_controller);

    _paddLeft = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 200, end: 0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 200), weight: 1)
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          fetchusersdata();
          return Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    _paddRight.value, 0, _paddLeft.value, 0),
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              accepted
                  ? Text(
                      "You have been accepted\n Thanks for joining our app",
                      style: TextStyle(fontSize: 30, color: Color(0xffc7171e)),
                      textAlign: TextAlign.center,
                    )
                  : rejected
                      ? Text(
                          "Sorry, you have been rejected\n Check your email",
                          style:
                              TextStyle(fontSize: 30, color: Color(0xffc7171e)),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "Waiting for admin's response....",
                          style:
                              TextStyle(fontSize: 30, color: Color(0xffc7171e)),
                          textAlign: TextAlign.center,
                        ),
              accepted
                  ? Icon(
                      Icons.check,
                      color: Color(0xffc7171e),
                      size: 80,
                    )
                  : rejected
                      ? Icon(
                          Icons.error,
                          color: Color(0xffc7171e),
                          size: 80,
                        )
                      : SpinKitRing(
                          color: Colors.red,
                        ),
              SizedBox(
                height: 50,
              ),
              accepted
                  ? FloatingActionButton.extended(
                      icon: Icon(Icons.check),
                      label: Text("Login"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    )
                  : rejected
                      ? FloatingActionButton.extended(
                          icon: Icon(Icons.error),
                          label: Text("Leave"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        )
                      : FloatingActionButton.extended(
                          label: Text(
                            "Leave",
                            style: TextStyle(fontSize: 20),
                          ),
                          icon: Icon(Icons.exit_to_app_rounded),
                          elevation: 10,
                          hoverElevation: 50,
                          onPressed: () {
                            Widget okButton = FlatButton(
                                child: Text("Leave"),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                });
                            Widget stayButton = FlatButton(
                                child: Text("Stay"),
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
                                    title: Text("Leaving!"),
                                    content: Text(
                                        "You will recieve an email with the admin's response you can leave if you want"),
                                    actions: [stayButton, okButton],
                                  );
                                });
                          },
                        )
            ],
          );
        },
      ),
    );
  }
}
