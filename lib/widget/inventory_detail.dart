import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing_flutter/pages/list_view.dart';

import '../model/inventory.dart';
import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../base.dart';

class InventoryDetail extends StatefulWidget {
  @override
  _InventoryDetailState createState() => _InventoryDetailState();
}

class _InventoryDetailState extends Base<InventoryDetail> {
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  List<Inventory> _invent = [];
  var date;
  var time;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TextEditingController capacityController = TextEditingController();

  void check() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        var posStart = selectedStartDate.toString().lastIndexOf('.');
        var posEnd = selectedEndDate.toString().lastIndexOf('.');
        String resultStart = (posStart != -1)
            ? selectedStartDate.toString().substring(0, posStart)
            : selectedStartDate.toString();
        String resultEnd = (posEnd != -1)
            ? selectedEndDate.toString().substring(0, posEnd)
            : selectedEndDate.toString();
        showLoading();
        //input method, id, duration_start, duration_end, capacity
        odoo
            .checkInvent(Strings.res_company, '1', resultStart, resultEnd,
                capacityController.text)
            .then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                var result = res.getResult();
                if (_invent.isNotEmpty) {
                  _invent.clear();
                }
                for (var i = 0; i < result.length; i++) {
                  if (i.isOdd) {
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
                  }
                }
              });
              push(ListViewInventory(
                dataList: _invent,
              ));
            } else {
              showMessage("Error", res.getErrorMessage());
            }
          },
        );
      }
    });
  }

  Widget formFieldDate(String hint, DateFormat format, DateTime dateTime,
      DateTime date, TimeOfDay time) {
    return DateTimeField(
      decoration: InputDecoration(
        hintText: hint,
      ),
      format: format,
      onShowPicker: (context, currentValue) async {
        date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          setState(() {
            dateTime = DateTimeField.combine(date, time);
          });
          return dateTime;
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget textFormField(String label, TextEditingController controller,
      TextInputType inputType, bool obscure) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      obscureText: obscure,
    );
  }

  Widget raisedButton(Function function, String label) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: function,
        color: Theme.of(context).primaryColor,
        child: Text(
          label,
          softWrap: true,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
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

    getOdooInstance().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          formFieldDate(
            'Pick Start Date',
            format,
            selectedStartDate,
            date,
            time,
          ),
          formFieldDate(
            'Pick End Date',
            format,
            selectedEndDate,
            date,
            time,
          ),
          textFormField(
            'Capacity',
            capacityController,
            TextInputType.number,
            false,
          ),
          SizedBox(
            height: 20,
          ),
          raisedButton(
            check,
            'Check Inventory',
          ),
          SizedBox(
            height: 40,
          ),
          raisedButton(
            cancelBooking,
            'Cancel Booking and Invoice',
          ),
          raisedButton(
            refundInvoice,
            'Refund Invoice',
          ),
        ],
      ),
    );
  }
}
