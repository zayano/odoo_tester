import 'package:flutter/material.dart';

import '../model/user_odoo.dart';
import '../widget/partner_list.dart';
import '../service/odoo_response.dart';
import '../utility/strings.dart';
import '../widget/home_drawer.dart';
import '../base.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends Base<Home> {
  List<UserOdoo> _userOdoo = [];
  String name;
  String email;
  String imageURL;
  String sessionId;

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

  @override
  void initState() {
    getOdooInstance().then((odoo) {
      _getUserData();
      sessionId = getSession().split(';').elementAt(0);

      if (getURL() != null) {
        imageURL = getURL() +
            "/web/image?model=res.users&field=image&" +
            sessionId +
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
      body: Center(child: PartnerList()),
      drawer: HomeDrawer(_userOdoo, imageURL),
    );
  }
}
