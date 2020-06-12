import 'package:flutter/material.dart';

import '../widget/meeting_plans.dart';
import '../model/user_odoo.dart';
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
  String url;
  DateTime startDay;

  void _getUserData() async {
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

  void _check() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo
            .checkInvent(Strings.res_company, '1', '2020-06-05 15:00:00',
                '2020-06-05 18:59:59', '10')
            .then(
          (OdooResponse res) {
            if (!res.hasError()) {
              setState(() {
                hideLoading();
                String session = getSession();
                session = session.split(",")[0].split(";")[0];
                for (var i in res.getRecords()) {}
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
      // _check();
      sessionId = getSession().split(';').elementAt(0);
      url = getURL();

      if (getURL() != null) {
        imageURL = getURL() +
            "/web/image?model=res.users&field=image&" +
            sessionId +
            "&id=" +
            getUID().toString();

        print(url);
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
      body: Center(child: MeetingPlans()),
      drawer: HomeDrawer(_userOdoo, imageURL),
    );
  }
}
