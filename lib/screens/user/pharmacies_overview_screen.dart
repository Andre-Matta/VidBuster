import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/widgets/user/pharmacy_grid.dart';
import 'package:vidbusters/providers/pharmacies.dart';

class PharmaciesOverviewScreen extends StatefulWidget {
  int MedicineId;
  PharmaciesOverviewScreen(this.MedicineId);
  @override
  _PharmaciesOverviewScreenState createState() =>
      _PharmaciesOverviewScreenState(MedicineId);
}

class _PharmaciesOverviewScreenState extends State<PharmaciesOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  int MedicineId;
  _PharmaciesOverviewScreenState(this.MedicineId);
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Pharmacies>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacies'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PharmacyGrid(MedicineId),
    );
  }
}
