import 'package:flutter/material.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/screens/user/pharmacies_overview_screen.dart';
import 'package:image_fade/image_fade.dart';

class MedicineItem  extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final String decription;
  MedicineItem(this.id, this.name, this.image, this.decription);
  @override
  _MedicineItem createState() =>
      _MedicineItem(this.id,this.name,this.image,this.decription);
}
class _MedicineItem  extends State<MedicineItem> {
  final int id;
  final String name;
  final String image;
  final String decription;
  _MedicineItem(this.id, this.name, this.image, this.decription);

  @override
  Widget build(BuildContext context) {
    ImageProvider imagePro1;
    ImageProvider imagePro2;
    imagePro1 = AssetImage(image);
    imagePro2 = AssetImage('assets/images/loading.gif');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PharmaciesOverviewScreen(id),
                  ),
                );
              },
              child: Stack(children: <Widget>[
                Positioned.fill(
                    child: ImageFade(
                      image: imagePro1,
                      placeholder: Container(
                        child: Image(
                          image: imagePro2,
                        ),
                      ),
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ))
              ]),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading:
                  Selected.isMulti  ?
             IconButton(
                  icon: Icon(
                    Selected.arr[id] ?  Icons.check_box : Icons.check_box_outline_blank ,
                  ),
                  onPressed: () {
                    setState(() {
                      if (Selected.arr[id]){
                        Selected.arr[id]=false;
                      }
                      else{
                        Selected.arr[id]=true;
                      }
                   });
                  },
                ):Text(''),
              title: Text(name,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                  )),
            ),
          )

    );
  }
}
