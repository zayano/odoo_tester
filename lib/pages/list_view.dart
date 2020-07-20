import 'package:flutter/material.dart';

import '../model/inventory.dart';
import '../widget/empty_list.dart';

class ListViewInventory extends StatefulWidget {
  final dataList;

  ListViewInventory({
    Key key,
    this.dataList,
  }) : super(key: key);

  @override
  _ListViewInventoryState createState() => _ListViewInventoryState();
}

class _ListViewInventoryState extends State<ListViewInventory> {
  List<Inventory> dataListView;

  @override
  void initState() {
    dataListView = widget.dataList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView Inventory"),
      ),
      body: dataListView.length > 0
          ? ListView.builder(
              itemCount: dataListView.length,
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
                              dataListView[i].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Container(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            dataListView[i].description,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 15.0),
                          ),
                        ),
                        trailing: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                dataListView[i].capacity.toString() +
                                    "\"" +
                                    " Capacity",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(dataListView[i].unitPrice.toString()),
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
    );
  }
}
