import 'package:flutter/material.dart';
import 'package:testing_flutter/model/user_odoo.dart';

import '../model/partners.dart';
import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../widget/home_drawer.dart';
import '../base.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends Base<Home> {
  List<Partner> _partners = [];
  List<UserOdoo> _userOdoo = [];
  String name;
  String email;
  String imageURL;
  String session_id;

  _getUserData() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead(Strings.res_users, [
          ["id", "=", getUID()]
        ], []).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {
                  _userOdoo.add(UserOdoo(
                    name: i["name"] is! bool ? i["name"] : "No Name",
                    email: i["email"] is! bool ? i["email"] : "No Email",
                  ));
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

  _getPartners() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead(
            Strings.res_partner, [], ['email', 'name', 'phone']).then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {
                  _partners.add(
                    new Partner(
                      id: i["id"],
                      email: i["email"] is! bool ? i["email"] : "N/A",
                      name: i["name"],
                      phone: i["phone"] is! bool ? i["phone"] : "N/A",
                      imageUrl: getURL() +
                          "/web/image?model=res.partner&field=image&" +
                          session +
                          "&id=" +
                          i["id"].toString(),
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
      _getUserData();
      _getPartners();
      session_id = getSession().split(';').elementAt(0);

      if (getURL() != null) {
        imageURL = getURL() +
            "/web/image?model=res.users&field=image&" +
            session_id +
            "&id=" +
            getUID().toString();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: RaisedButton(
        child: Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          logout();
        },
      )),
      drawer: HomeDrawer(_userOdoo, imageURL),
    );
  }
}
