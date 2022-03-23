import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vidbusters/providers/product.dart';
import 'package:vidbusters/widgets/pharmacy/pharmacyAppdrawer/PharmacyAppdrawer.dart';
import 'package:vidbusters/widgets/pharmacy/product_item.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/screens/forms/login.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isSearching = false;
  String SearchTitle = '';
  var showFavs = false;
  DateTime currentBackPressTime;
  static List<Product> products = [
    Product(
      id: '1',
      name: 'C-Retard',
      image: 'assets/images/c-retard.jpg',
    ),
    Product(
      id: '2',
      name: 'Acetylcysteine',
      image: 'assets/images/acetylcysteine.jpg',
    ),
    Product(
      id: '3',
      name: 'Favipiravir',
      image: 'assets/images/favipiravir.jpg',
    ),
    Product(
      id: '4',
      name: 'Hydroxy Chloroquine',
      image: 'assets/images/hydroxy chloroquine.jpg',
    ),
    Product(
      id: '5',
      name: 'Invermectin',
      image: 'assets/images/invermectin.jpg',
    ),
    Product(
      id: '6',
      name: 'Kalertra',
      image: 'assets/images/kalertra.jpg',
    ),
    Product(
      id: '7',
      name: 'Lactoferriene',
      image: 'assets/images/lactoferriene.jpg',
    ),
    Product(
      id: '8',
      name: 'Remdesivir',
      image: 'assets/images/rmdsefir.jpg',
    ),
    Product(
      id: '9',
      name: 'Zinc',
      image: 'assets/images/zinc.jpg',
    ),
  ];

  List<Product> fulteredProducts = [];
  bool flag = false;

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

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 9; i++) {
      products[i].isFavorite = Login.currentuser.avaliableMedicines[i + 1];
    }

    if (SearchTitle != '') {
      fulteredProducts.clear();
      for (int i = 0; i < products.length; i++) {
        if (products[i].name == SearchTitle) {
          fulteredProducts.clear();
          fulteredProducts.add(products[i]);
          flag = true;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: !isSearching
            ? Text('Medicine')
            : TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          this.isSearching = false;
                          this.SearchTitle = '';
                        });
                      }),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (String value) {
                  setState(() {
                    SearchTitle = value;
                  });
                },
              ),
        actions: <Widget>[
          !isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  })
              : Text(''),
        ],
      ),
      drawer: pahrmacyAppDrawer(),
      body: WillPopScope(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
          onWillPop: onWillPop),
    );
  }
}
