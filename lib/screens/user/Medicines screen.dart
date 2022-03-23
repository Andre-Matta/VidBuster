import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/screens/user/pharmacies_overview_screen.dart';
import 'package:vidbusters/widgets/user/MedicineItem%20.dart';
import 'package:vidbusters/widgets/appdrawer/appdrawer.dart';
import 'package:vidbusters/providers/Medicine.dart';

class MedicineScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _MedicineScreen();
  }
}

class _MedicineScreen extends State<MedicineScreen> {
  bool isSearching = false;
  String SearchTitle = '';
  final List<Medicine> loadedProducts = [
    Medicine(
      id: 1,
      name: 'C-Retard',
      image: 'assets/images/c-retard.jpg',
        price:12.1,
    ),
    Medicine(
      id: 2,
      name: 'Acetylcysteine',
      image: 'assets/images/acetylcysteine.jpg',
      price:12.1,
    ),
    Medicine(
      id: 3,
      name: 'Favipiravir',
      description: 'favipiravir',
      image: 'assets/images/favipiravir.jpg',
      price:12.1,
    ),
    Medicine(
      id: 4,
      name: 'Hydroxy Chloroquine',
      description: 'hydroxy chloroquine',
      image: 'assets/images/hydroxy chloroquine.jpg',
      price:12.1,
    ),
    Medicine(
      id: 5,
      name: 'Invermectin',
      description: 'invermectin',
      image: 'assets/images/invermectin.jpg',
      price:12.1,
    ),
    Medicine(
      id: 6,
      name: 'Kalertra',
      description: 'kalertra',
      image: 'assets/images/kalertra.jpg',
      price:12.1,
    ),
    Medicine(
      id: 7,
      name: 'Lactoferriene',
      description: 'lactoferriene',
      image: 'assets/images/lactoferriene.jpg',
      price:12.1,
    ),
    Medicine(
      id: 8,
      name: 'Remdesivir',
      description: 'remdesivir',
      image: 'assets/images/rmdsefir.jpg',
      price:12.1,
    ),
    Medicine(
      id: 9,
      name: 'Zinc',
      description: 'zinc',
      image: 'assets/images/zinc.jpg',
      price:12.1,
    ),
  ];
  List<Medicine> loadedMedicinesfultered = [];
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
    if (SearchTitle != '') {
      loadedMedicinesfultered.clear();
      for (int i = 0; i < loadedProducts.length; i++) {
        if (loadedProducts[i].name == SearchTitle) {
          loadedMedicinesfultered.clear();
          loadedMedicinesfultered.add(loadedProducts[i]);
          flag = true;
        }
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: !isSearching && !Selected.isMulti
              ? Text('Medicine'):
              !Selected.isMulti ?
                TextField(
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
                ):Text(''),
          actions: <Widget>[

            !isSearching && !Selected.isMulti
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    })
                : Text(''),
            Selected.isMulti ?
             FlatButton(
                      onPressed:(){
                        setState(() {
                          Selected.isMulti = false ;
                          Selected.select = false;
                        });
                      },
                      textColor: Colors.white,
                      child: const Text(
                          'Cancel',
                      ),
                    ):Text(''),
            Selected.isMulti ?
            FlatButton(
                textColor: Colors.white,
                child: Text("Show Pharmacies"),
                onPressed: () {
                  setState(() {
                    Selected.select = true;
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => PharmaciesOverviewScreen(1),
                        )
                    );

                  });
                  }
                  )
                :Text(''),
            !Selected.isMulti? IconButton(
                icon: Icon(
                    Icons.dynamic_form_outlined
                ),
                alignment: Alignment.centerRight,
                onPressed: (){
                  setState((){
                    Selected.isMulti = true ;
                    print(Selected.isMulti);
                  });
                }):Text(''),
          ],
        ),
        drawer: AppDrawer(),
        body:
              SearchTitle == ''
                  ? WillPopScope(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: loadedProducts.length,
                    itemBuilder: (ctx, i) => MedicineItem(
                      loadedProducts[i].id,
                      loadedProducts[i].name,
                      loadedProducts[i].image,
                      loadedProducts[i].description,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                  onWillPop: onWillPop)
                  : WillPopScope(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: loadedMedicinesfultered.length,
                    itemBuilder: (ctx, i) => MedicineItem(
                      loadedMedicinesfultered[i].id,
                      loadedMedicinesfultered[i].name,
                      loadedMedicinesfultered[i].image,
                      loadedMedicinesfultered[i].description,
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
