import 'package:flutter/material.dart';

import '../model/inventory.dart';
import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../base.dart';
import './empty_list.dart';

class InventoryDetail extends StatefulWidget {
  @override
  _InventoryDetailState createState() => _InventoryDetailState();
}

class _InventoryDetailState extends Base<InventoryDetail> {
  List<Inventory> _invent = [];

  void check() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo
            .checkInvent(Strings.res_company, '1', '2020-06-30 10:00:00',
                '2020-06-30 12:00:00', '50')
            .then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                List result = res.getResult();
                for (var i = 0; i < result.length; i++) {
                  if (i.isOdd) {
                    var resultOdd = result[i];
                    _invent.add(
                      new Inventory(
                        name: result[i]["name"] is! bool
                            ? result[i]["name"]
                            : "No Name",
                        description: result[i]["description"] is! bool
                            ? result[i]["description"]
                            : "No Description",
                        capacity: result[i]["capacity"] is! bool
                            ? result[i]["capacity"]
                            : 0,
                      ),
                    );
                    print(resultOdd);
                  }
                }
              });
            } else {
              showMessage("Warning", res.getErrorMessage());
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getOdooInstance().then((value) {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _invent.length > 0
        ? ListView.builder(
            itemCount: _invent.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) => InkWell(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _invent[i].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        _invent[i].description,
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                    ),
                    trailing: Container(
                      child: Text(
                        _invent[i].capacity.toString() + "\"" + " Capacity",
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : EmptyList(Icons.book, "No Inventory");
  }
}
