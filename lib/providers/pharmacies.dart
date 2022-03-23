import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import './pharmacy.dart';
import 'dart:math';

class Pharmacies with ChangeNotifier {
  List<Pharmacy> _items = [];

  List<Pharmacy> get items {
    return [..._items];
  }

  Pharmacy findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> fetchAndSetProducts() async {
    final locData = await Location().getLocation();
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      //  print(response.body);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      final List<Pharmacy> loadedProducts = [];

      extractedData.forEach((prodId, prodData) async {
        if (prodData['Status'] == 'Accepted'){
          loadedProducts.add(Pharmacy(
            id: prodId,
            name: prodData['pharmacyname'],
            imageUrl: prodData['pharmacyimage'],
            avaliableMedicines: prodData['avaliableMedicines'],
            lat: prodData['lat'],
            lng: prodData['lng'],
            distance: Geolocator.distanceBetween(prodData['lat'], prodData['lng'],
                locData.latitude, locData.longitude)/1000,
            haveDelivery: prodData['haveDelivery'],
          ));
        }

      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Pharmacy product) async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/product.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.name,
          'description': product.location,
          'imageUrl': product.imageUrl,
        }),
      );
      final newProduct = Pharmacy(
        name: product.name,
        location: product.location,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(String id, Pharmacy newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
