import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/widgets/user/reports_item.dart';
import '../../providers/pharmacies.dart';

class ReportsGrid extends StatefulWidget {
  @override
  _ReportsGridState createState() => _ReportsGridState();
}

class _ReportsGridState extends State<ReportsGrid> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Pharmacies>(context);
    final pharmacies = productsData.items;

    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: pharmacies.length,
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            value: pharmacies[i],
            child: ReportsItem(),
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
