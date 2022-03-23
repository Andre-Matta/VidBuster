import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  String id;
  String pharmacyname;
  String email;
  String password;
  String licenseimage;
  String pharmacyimage;
  double lat;
  double lng;
  String type;
  bool isfound = false;
  bool haveDelivery = false;
  var avaliableMedicines = new List(10);

  Users(
      {this.pharmacyname,
      this.email,
      this.password,
      this.licenseimage,
      this.pharmacyimage,
      this.type,
      this.lat,
      this.lng,
      this.avaliableMedicines});

  void setemail(String email) {
    this.email = email;
  }

  void setpassword(String password) {
    this.password = password;
  }
}
