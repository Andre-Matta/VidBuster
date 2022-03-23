import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product.dart';
import 'package:image_fade/image_fade.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItem createState() => _ProductItem();
}

class _ProductItem extends State<ProductItem> {
  var _isInit = true;
  var _isLoading = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    ImageProvider imagePro1;
    ImageProvider imagePro2;
    imagePro1 = AssetImage(product.image);
    imagePro2 = AssetImage('assets/images/loading.gif');

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {},
            child: ImageFade(
              image: imagePro1,
              placeholder: Container(
                child: Image(
                  image: imagePro2,
                ),
              ),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.check_circle:Icons.check_circle_outline  ,
                color: Colors.green,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
