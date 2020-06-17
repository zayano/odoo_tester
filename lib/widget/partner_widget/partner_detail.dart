import 'package:flutter/material.dart';
import 'package:testing_flutter/model/partners.dart';

import '../../base.dart';

class PartnerDetail extends StatefulWidget {
  final dataPartner;

  PartnerDetail({Key key, this.dataPartner}) : super(key: key);

  @override
  _PartnerDetailState createState() => _PartnerDetailState();
}

class _PartnerDetailState extends Base<PartnerDetail> {
  Partner _partner;

  @override
  void initState() {
    _partner = widget.dataPartner;

    getOdooInstance().then((value) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final upperHeader = Container(
      color: Colors.purple,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: 150.0,
                height: 150.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(25.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25.0,
                      color: Colors.orange,
                    )
                  ],
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                      _partner.imageUrl != null
                          ? _partner.imageUrl
                          : "https://i1.wp.com/www.molddrsusa.com/wp-content/uploads/2015/11/profile-empty.png.250x250_q85_crop.jpg?ssl=1",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  _partner.name,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  _partner.email,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(
      children: <Widget>[upperHeader],
    );
  }
}
