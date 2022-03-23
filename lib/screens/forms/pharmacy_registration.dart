import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vidbusters/shared/decorations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:vidbusters/providers/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class PharmacyRigestraion extends StatefulWidget {
  static Users curruser = new Users();
  @override
  _PharmacyRigestraionState createState() => _PharmacyRigestraionState();
}

class _PharmacyRigestraionState extends State<PharmacyRigestraion> {
  Color _button = Color(0xFFF44336);
  Color _button1 = Color(0xFFF44336);
  Color _button2 = Color(0xFFF44336);
  Color _button3 = Color(0xFFF44336);
  Color _button4 = Color(0xFFF44336);
  Color _button5 = Color(0xFFF44336);

  File _license_image;
  File _pharmacy_image;
  final picker = ImagePicker();

  List<bool> _loading1 = [
    false,
    false,
    false,
    false,
    false,
    false,
    true,
    false
  ];
  List<bool> medicines = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool isfound = false, isSigning = true;

  Future<void> adduser() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'pharmacyname': PharmacyRigestraion.curruser.pharmacyname,
          'email': PharmacyRigestraion.curruser.email,
          'password': PharmacyRigestraion.curruser.password,
          'licenseimage': PharmacyRigestraion.curruser.licenseimage,
          'pharmacyimage': PharmacyRigestraion.curruser.pharmacyimage,
          'lat': PharmacyRigestraion.curruser.lat,
          'lng': PharmacyRigestraion.curruser.lng,
          'type': "pharmacy",
          'haveDelivery': PharmacyRigestraion.curruser.haveDelivery,
          'Status': "Waiting",
          'avaliableMedicines': medicines,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchusersdata() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      extractedData.forEach((userid, userdata) async {
        if (PharmacyRigestraion.curruser.email == userdata['email']) {
          isfound = true;
        }
      });
    } catch (error) {
      throw (error);
    }
  }

  Future getImage(int b) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null && b == 1) {
        _license_image = File(pickedFile.path);
        _button = Colors.green;
      } else if (pickedFile != null && b == 2) {
        _pharmacy_image = File(pickedFile.path);
        _button1 = Colors.green;
      }
    });
  }

  Future uploadlicense() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('licenses/${Path.basename(_license_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_license_image);
    await uploadTask.onComplete;
    setState(() {
      storageReference.getDownloadURL().then((fileURL) {
        PharmacyRigestraion.curruser.licenseimage = fileURL;
        print(PharmacyRigestraion.curruser.licenseimage);
        _loading1[3] = true;
        _loading1[6] = true;
        for (var i = 0; i < 6; i++) {
          if (_loading1[i] == false) _loading1[6] = false;
        }
        if (_loading1[6] == true) {
          adduser().then((value) => {
                Navigator.pushNamed(context, '/pharmacywaiting'),
              });
        }
      });
    });
  }

  Future uploadpharmacy() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Pharmacies/${Path.basename(_pharmacy_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_pharmacy_image);
    await uploadTask.onComplete;
    setState(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        PharmacyRigestraion.curruser.pharmacyimage = fileURL;
        print(PharmacyRigestraion.curruser.pharmacyimage);
        _loading1[4] = true;
        _loading1[6] = true;
        for (var i = 0; i < 6; i++) {
          if (_loading1[i] == false) _loading1[6] = false;
        }
        if (_loading1[6] == true) {
          adduser().then((value) => {
                Navigator.pushNamed(context, '/pharmacywaiting'),
              });
        }
      });
    });
  }

  Future getlocation() async {
    final locData = await Location().getLocation();
    PharmacyRigestraion.curruser.lat = locData.latitude;
    PharmacyRigestraion.curruser.lng = locData.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
        padding: EdgeInsets.all(5),
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
                    height: 5,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: textinputdecoration.copyWith(
                      hintText: "Pharmacy Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          _loading1[0] = true;
                          PharmacyRigestraion.curruser.pharmacyname = value;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 17,
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
                          _loading1[1] = true;
                          PharmacyRigestraion.curruser.email = value;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration:
                        textinputdecoration.copyWith(hintText: "Password"),
                    onChanged: (value) {
                      setState(() {
                        if (value.length > 6) {
                          PharmacyRigestraion.curruser.password = value;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: textinputdecoration.copyWith(
                        hintText: "Confirm Password"),
                    onChanged: (value) {
                      setState(() {
                        if (value == PharmacyRigestraion.curruser.password) {
                          _loading1[2] = true;
                        }
                        print(_loading1);
                      });
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Row(children: [
                    Text('Do you have delivery:',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    FloatingActionButton.extended(
                      heroTag: 4,
                      elevation: 10,
                      backgroundColor: _button4,
                      label: Text("Yes"),
                      onPressed: () {
                        setState(() {
                          PharmacyRigestraion.curruser.haveDelivery = true;
                          _button4 = Colors.green;
                          _button5 = Color(0xFFF44336);
                          _loading1[7] = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton.extended(
                      heroTag: 5,
                      elevation: 10,
                      backgroundColor: _button5,
                      label: Text("No"),
                      onPressed: () {
                        setState(() {
                          PharmacyRigestraion.curruser.haveDelivery = false;
                          _button5 = Colors.green;
                          _button4 = Color(0xFFF44336);
                          _loading1[7] = true;
                        });
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 17,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 0,
                    elevation: 10,
                    backgroundColor: _button,
                    label: Text("Add License Image"),
                    icon: Icon(
                      Icons.add_a_photo,
                    ),
                    onPressed: () {
                      setState(() {
                        getImage(1);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 1,
                    elevation: 10,
                    backgroundColor: _button1,
                    label: Text("Add Pharmacy Image"),
                    icon: Icon(
                      Icons.add_a_photo,
                    ),
                    onPressed: () {
                      setState(() {
                        getImage(2);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 2,
                    elevation: 10,
                    backgroundColor: _button2,
                    label: Text("Add Location"),
                    icon: Icon(
                      Icons.add_location_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        getlocation().then((value) => {
                              setState(() {
                                _button2 = Colors.green;
                                _loading1[5] = true;
                              })
                            });
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isSigning
                      ? FloatingActionButton.extended(
                          elevation: 10,
                          heroTag: 3,
                          label:
                              Text("sign up", style: TextStyle(fontSize: 20)),
                          backgroundColor: _button3,
                          onPressed: () {
                            isSigning = false;
                            setState(() {
                              if (_loading1[0] &&
                                  _loading1[1] &&
                                  _loading1[2] &&
                                  _loading1[5] &&
                                  _loading1[7]) {
                                Widget okButton = FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    });
                                _button3 = Colors.green;
                                fetchusersdata().then((value) => {
                                      if (!isfound)
                                        {
                                          uploadpharmacy(),
                                          uploadlicense(),
                                          isfound = false,
                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(15)),
                                                  title: Text("Error"),
                                                  content: Text(
                                                      "This email is already taken "),
                                                  actions: [okButton],
                                                );
                                              }),
                                          isfound = false,
                                          isSigning = true,
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
                                        content: Text(
                                            "Please enter all information"),
                                        actions: [okButton],
                                      );
                                    });
                                isSigning = true;
                              }
                            });
                          })
                      : SpinKitRing(
                          color: Colors.green,
                        ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
