import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/pharmacy.dart';
import 'package:vidbusters/screens/user/pharmacy_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportsItem extends StatefulWidget {
  @override
  _ReportsItemState createState() => _ReportsItemState();
}

class _ReportsItemState extends State<ReportsItem> {
  String report;

  Future<void> filereport(String id, String name, String img) async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/reports.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'pharmacyid': id,
          'pharmacyname': name,
          'report': report,
          'img': img,
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          trailing: FloatingActionButton.extended(
            label: Text("Report"),
            onPressed: () {
              Widget reportButton = FlatButton(
                  child: Text("report"),
                  onPressed: () {
                    Widget okButton = FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        });
                    filereport(pharmacy.id, pharmacy.name, pharmacy.imageUrl)
                        .then((_) => {
                              Navigator.of(context).pop(),
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(15)),
                                        title: Text("Report"),
                                        content: Text(
                                            "We have recieved your report and we will look into the problem"),
                                        actions: [okButton]);
                                  }),
                            });
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
                        title: Text("Report"),
                        content: TextFormField(
                          maxLines: 6,
                          minLines: 1,
                          onChanged: (value) {
                            setState(() {
                              report = value;
                            });
                          },
                        ),
                        actions: [cancelButton, reportButton]);
                  });
            },
          ),
        ),
      ),
    );
  }
}
