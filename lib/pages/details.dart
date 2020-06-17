import 'package:flutter/material.dart';

import '../base.dart';

class Details extends StatefulWidget {
  final String titleData;
  final widgetClass;

  Details({Key key, this.titleData, this.widgetClass}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends Base<Details> {
  String title;
  Widget body;

  @override
  void initState() {
    title = widget.titleData;
    body = widget.widgetClass;

    getOdooInstance().then((value) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title != null ? title : "no title"),
      ),
      body: body,
    );
  }
}
