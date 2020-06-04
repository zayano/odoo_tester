import 'package:flutter/material.dart';

import '../base.dart';

class EmptyList extends StatefulWidget {
  final IconData iconData;
  final String label;

  const EmptyList(this.iconData, this.label);

  @override
  _EmptyListState createState() => _EmptyListState();
}

class _EmptyListState extends Base<EmptyList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          widget.iconData,
          color: Colors.grey.shade300,
          size: 100,
        ),
        Padding(
          padding: EdgeInsets.all(1.0),
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
