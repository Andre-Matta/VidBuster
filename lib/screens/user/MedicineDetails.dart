import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class MedicineDetails extends StatefulWidget {
  String name;
  String image;
  String description;
  MedicineDetails(this.name, this.image, this.description);

  State<StatefulWidget> createState() {
    return _MedicineDetails(name, image, description);
  }
}

class _MedicineDetails extends State<MedicineDetails> {
  var _isInit = true;
  var _isLoading = false;
  String name;
  String image;
  String description;
  _MedicineDetails(this.name, this.image, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        children: [
          Image(image: AssetImage(image)),
          ReadMoreText(
            description,
            trimLines: 3,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            textAlign: TextAlign.right,
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
