import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/Selected.dart';
import '../../providers/pharmacies.dart';
import 'pharmacy_item.dart';

class PharmacyGrid extends StatefulWidget {
  int MedicineId;
  PharmacyGrid(this.MedicineId);
  @override
  _PharmacyGrid createState() =>
      _PharmacyGrid(MedicineId);
}
class _PharmacyGrid extends State<PharmacyGrid>{
  int MedicineId;

  _PharmacyGrid(this.MedicineId);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Pharmacies>(context);
    final pharmacies =  productsData.items;
    int count = 0 ;
if (Selected.select == true){
  for(int i = 0;i<Selected.arr.length;i++){
    print (Selected.arr[i]);
    if(Selected.arr[i] == true){
      count++;
      for (int j=0;j<pharmacies.length ; j++){
        if (pharmacies[j].avaliableMedicines[i] == false){
          pharmacies.removeAt(j);
        }
      }
    }
  }

}
else{
  count++;
  for(int i = 0;i<pharmacies.length;i++){
        if (pharmacies[i].avaliableMedicines[MedicineId] == false){
          pharmacies.removeAt(i);
        }
  }
}
    pharmacies.sort((a, b) => a.distance.compareTo(b.distance));

    return count ==0 ?
    Center(
        child:Text("Not availbale" ,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
               )
    ):
    Container(
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount:pharmacies.length,
          itemBuilder: (ctx, i) {

              return ChangeNotifierProvider.value(
                value: pharmacies[i],
                child: PharmacyItem(MedicineId),
              );

          },

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
    );

  }

}
