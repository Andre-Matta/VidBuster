import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/Medicine.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/providers/cart.dart';
import 'package:vidbusters/screens/user/pharmacy_detail_screen.dart';
import '../../providers/pharmacy.dart';

class PharmacyItem extends StatefulWidget {
  int MedicineId ;
  PharmacyItem(this.MedicineId);
  _PharmacyItem  createState() => _PharmacyItem(MedicineId);
}

class _PharmacyItem extends State<PharmacyItem>{
  int MedicineId ;
  _PharmacyItem(this.MedicineId);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final pharmacy = Provider.of<Pharmacy>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              PharmacyDetailScreen.routeName,
              arguments: pharmacy.id,
            );
          },
          child: Image.network(
            pharmacy.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            pharmacy.name,
          ),

          subtitle:  Text(
               pharmacy.distance.toStringAsFixed(2) + ' Km'
              ),
          trailing: pharmacy.haveDelivery?
        IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              if (Selected.select == true){
                for(int i = 0;i<Selected.arr.length;i++){
                  if(Selected.arr[i] == true){
                    cart.addItem(Medicine.loadedProducts[i-1].id.toString(),
                        Medicine.loadedProducts[i-1].price,
                        Medicine.loadedProducts[i-1].name,
                        pharmacy.id);
                  }
                }

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        for(int i = 0;i<Selected.arr.length;i++){
                          if(Selected.arr[i] == true){
                            cart.removeSingleItem(Medicine.loadedProducts[i-1].id.toString());
                          }
                        }
                      },
                    ),
                  ),
                );
              }
              else{
                cart.addItem(Medicine.loadedProducts[MedicineId-1].id.toString(),
                    Medicine.loadedProducts[MedicineId-1].price,
                    Medicine.loadedProducts[MedicineId-1].name,
                    pharmacy.id);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(Medicine.loadedProducts[MedicineId-1].id.toString());
                      },
                    ),
                  ),
                );
              }
            },
            color: Theme.of(context).accentColor,
          ):Text(''),
        ),
      ),
    );
  }
}
