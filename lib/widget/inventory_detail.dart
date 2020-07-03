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
        //input method, id, duration_start, duration_end, capacity
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
                var result = res.getResult();
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
                        locationId: result[i]["location_id"] is! bool
                            ? result[i]["location_id"]
                            : "No Location",
                        buildingId: result[i]["building_id"] is! bool
                            ? result[i]["building_id"]
                            : "No Building",
                        type: result[i]["type"] is! bool
                            ? result[i]["type"]
                            : "No Type",
                        unitPrice: result[i]["unit_price"] is! bool
                            ? result[i]["unit_price"]
                            : 0,
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
              showMessage("Error", res.getErrorMessage());
            }
          },
        );
      }
    });
  }

  void cancelBooking() async {
    isConnected().then(
      (isInternet) {
        if (isInternet) {
          showLoading();
          //input method, company_id, company_id
          odoo.cancelBookingAndInvoice(Strings.res_company, 1, 4).then(
            (OdooResponse res) {
              if (!res.hasError()) {
                setState(() {
                  hideLoading();
                  String session = getSession();
                  session = session.split(",")[0].split(";")[0];
                  var result = res.getResult();
                  if (result) {
                    showMessage("Success!", "Result is ${result.toString()}");
                  } else {
                    showMessage("Failed!", "Result is ${result.toString()}");
                  }
                });
              } else {
                showMessage("Error", res.getErrorMessage());
              }
            },
          );
        }
      },
    );
  }

  void refundInvoice() async {
    isConnected().then(
      (isInternet) {
        if (isInternet) {
          showLoading();
          //input method, company_id, company_id
          odoo.refundInvoice(Strings.res_company, 1, 5).then(
            (OdooResponse res) {
              if (!res.hasError()) {
                setState(() {
                  hideLoading();
                  String session = getSession();
                  session = session.split(",")[0].split(";")[0];
                  var result = res.getResult();
                  if (result) {
                    showMessage("Success!", "Result is ${result.toString()}");
                  } else {
                    showMessage("Failed!", "Result is ${result.toString()}");
                  }
                });
              } else {
                showMessage("Error", res.getErrorMessage());
              }
            },
          );
        }
      },
    );
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
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: _invent.length > 0
              ? ListView.builder(
                  itemCount: _invent.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, i) => Card(
                    elevation: 5.0,
                    margin: EdgeInsets.all(5),
                    child: InkWell(
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              ),
                            ),
                            trailing: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _invent[i].capacity.toString() +
                                        "\"" +
                                        " Capacity",
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(_invent[i].unitPrice.toString()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : EmptyList(Icons.book, "No Inventory"),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            height: double.minPositive,
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                cancelBooking();
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Cancel Booking and Invoice',
                softWrap: true,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            height: double.minPositive,
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                refundInvoice();
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Refund Invoice',
                softWrap: true,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
