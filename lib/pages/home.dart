import 'package:flutter/material.dart';

import '../widget/partner_widget/partner_list.dart';
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
  int _selectedIndex = 0;
  List<UserOdoo> _userOdoo = [];
  String name;
  String email;
  String imageURL;
  String sessionId;
  String nameUser;
  DateTime startDay;

  //   list of widget
  final drawerItems = [
    new PartnerList(),
    new MeetingPlans(),
  ];

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

  void check() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo
            .checkInvent(Strings.res_company, '1', '2020-06-12 16:37:55',
                '2020-06-12 21:37:55', '10')
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
      if (_userOdoo.isEmpty) {
        _getUserData();
        print("jalan");
      }
      // check();
      sessionId = getSession().split(';').elementAt(0);

      if (getURL() != null) {
        imageURL = getURL() +
            "/web/image?model=res.users&field=image&" +
            sessionId +
            "&id=" +
            getUID().toString();
      }

      if (getUser() != null) {
        nameUser = getUser().result.name;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Home' : 'Meeting Plans'),
      ),
      body: Center(child: drawerItems[this._selectedIndex]),
      drawer: HomeDrawer(
        userDataOdoo: _userOdoo,
        imageURL: imageURL,
        onTap: (int val) {
          setState(() {
            this._selectedIndex = val;
          });
        },
      ),
    );
  }
}
