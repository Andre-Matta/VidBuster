import 'package:flutter/foundation.dart';
import '../widgets/user/MedicineItem .dart';

class Medicine {
  static final List<Medicine> loadedProducts = [
    Medicine(
      id: 1,
      name: 'C-Retard',
      image: 'assets/images/c-retard.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 2,
      name: 'Acetylcysteine',
      image: 'assets/images/acetylcysteine.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 3,
      name: 'Favipiravir',
      description: 'favipiravir',
      image: 'assets/images/favipiravir.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 4,
      name: 'Hydroxy Chloroquine',
      description: 'hydroxy chloroquine',
      image: 'assets/images/hydroxy chloroquine.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 5,
      name: 'Invermectin',
      description: 'invermectin',
      image: 'assets/images/invermectin.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 6,
      name: 'Kalertra',
      description: 'kalertra',
      image: 'assets/images/kalertra.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 7,
      name: 'Lactoferriene',
      description: 'lactoferriene',
      image: 'assets/images/lactoferriene.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 8,
      name: 'Remdesivir',
      description: 'remdesivir',
      image: 'assets/images/rmdsefir.jpg',
      price: 12.1,
    ),
    Medicine(
      id: 9,
      name: 'Zinc',
      description: 'zinc',
      image: 'assets/images/zinc.jpg',
      price: 12.1,
    ),
  ];
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  Medicine({this.id, this.name, this.description, this.image, this.price});
  static Medicine findByName(String name) {
    return loadedProducts.firstWhere((prod) => prod.name == name);
  }

  fun(String name) {
    Medicine lp = Medicine.findByName(name);
    MedicineItem(
      lp.id,
      lp.name,
      lp.image,
      lp.description,
    );
  }

  static bool isfound(String name) {
    if (loadedProducts.firstWhere((prod) => prod.name == name) != null) {
      print(name);
      return true;
    } else {
      print(name);
      return false;
    }
  }
}
