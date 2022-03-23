import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/pharmacies.dart';
import 'package:vidbusters/widgets/user/Pharmacy_reportgrid.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  var _isLoading = true;
  var _isInit = true;
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
          : ReportsGrid(),
    );
  }
}
