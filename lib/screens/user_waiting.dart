import 'package:flutter/material.dart';
import 'package:vidbusters/shared/decorations.dart';
import 'package:vidbusters/screens/forms/user_register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  int confirmation_code, randomNumber;
  Random random = new Random();

  Future<void> adduser() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': UserRegistration.curruser.email,
          'password': UserRegistration.curruser.password,
          'type': "user",
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> sendemail() async {
    String username = "vidbusters21@gmail.com";
    String password = "vidbuster50k";
    randomNumber = random.nextInt(1000000);
    print(randomNumber);
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address('vidbusters21@gmail.com', 'Vidbusters')
      ..recipients.add(UserRegistration.curruser.email)
      ..subject = 'Confirmation code :: 😀'
      ..text =
          'Dear user, \n Thanks for registering in vidbuster,\n Here is your confirmation code: \n $randomNumber';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sendemail();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                height: 250,
                width: 250,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
              child: TextFormField(
                  decoration: textinputdecoration.copyWith(
                      hintText: "Confirmation code"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    confirmation_code = int.parse(value);
                  }),
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 110,
                ),
                FloatingActionButton.extended(
                  elevation: 10,
                  heroTag: "1",
                  icon: Icon(Icons.cancel_rounded),
                  label: Text("Cancel"),
                  onPressed: () {
                    Widget okButton = FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        });
                    Widget cancelButton = FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15)),
                            title: Text("Leaving!"),
                            content: Text(
                                "Are you sure you want to cancel your registeration?"),
                            actions: [cancelButton, okButton],
                          );
                        });
                  },
                ),
                SizedBox(
                  width: 85,
                ),
                FloatingActionButton.extended(
                  elevation: 10,
                  heroTag: "2",
                  icon: Icon(Icons.check_circle_rounded),
                  label: Text("Ok"),
                  onPressed: () {
                    if (confirmation_code == randomNumber) {
                      Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          });
                      adduser().then((_) => {
                            Navigator.pushNamed(context, '/login'),
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(15)),
                                      title: Text("Thanks"),
                                      content:
                                          Text("You registered successfully"),
                                      actions: [okButton]);
                                })
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
                                  borderRadius: new BorderRadius.circular(15)),
                              title: Text("Wrong confirmation code"),
                              content: Text(
                                  "Enter the confirmatio code sent via email"),
                              actions: [okButton],
                            );
                          });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Confirmation code was sent via email",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xffc7171e),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}
