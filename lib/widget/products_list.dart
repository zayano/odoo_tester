import 'package:flutter/material.dart';
import 'package:testing_flutter/base.dart';
import 'package:testing_flutter/model/product.dart';
import 'package:testing_flutter/service/odoo_response.dart';
import 'package:testing_flutter/widget/empty_list.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends Base<ProductsList> {
  List<Product> _products = [];

  void _getProducts() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.product', [], [
          'id',
          'name',
          'product_category_id',
          'location_id',
          'building_id',
          'capacity',
        ]).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {
                  print(i);
                  _products.add(
                    new Product(
                      id: i["id"] is! bool ? i["id"] : "N/A",
                      name: i["name"] is! bool ? i["name"] : "No Name",
                      productCategoryId: i["product_category_id"][1] is! bool
                          ? i["product_category_id"][1]
                          : "No Product",
                      locationId: i["location_id"][1] is! bool
                          ? i["location_id"][1]
                          : "No Location",
                      buildingId: i["building_id"][1] is! bool
                          ? i["building_id"][1]
                          : "No Building",
                      capacity: i["capacity"] is! bool
                          ? i["capacity"]
                          : "No Capacity",
                    ),
                  );
                }
              });
            } else {
              print(res.getError());
              showMessage("Warning", res.getErrorMessage());
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    getOdooInstance().then((odoo) {
      if (_products.isEmpty) {
        _getProducts();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _products.length > 0
        ? ListView.builder(
            itemCount: _products.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) => Card(
              elevation: 5.0,
              margin: EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  // push(Details(
                  //   titleData: "Detail Partner",
                  //   widgetClass: PartnerDetail(
                  //     dataPartner: _partners[i],
                  //   ),
                  // ));
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _products[i].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          _products[i].locationId,
                          style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          _products[i].capacity.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : EmptyList(Icons.people_outline, 'No Product');
  }
}
