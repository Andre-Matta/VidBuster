import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vidbusters/screens/forms/login.dart';

class Product with ChangeNotifier {
  final String userid = Login.currentuser.id;
  final String id;
  final String name;
  final String image;
  bool isFavorite = false;
  String s;

  Product({
    this.id,
    this.name,
    this.image,
    this.isFavorite,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users/$userid/avaliableMedicines.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          '$id': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
