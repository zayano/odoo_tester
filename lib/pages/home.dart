import 'package:flutter/material.dart';
import 'package:testing_flutter/model/booking.dart';
import 'package:testing_flutter/widget/inventory_detail.dart';

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
  List<Booking> _bookingMeeting = [];
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
    new InventoryDetail(),
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

  void getDataBooking() async {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.searchRead('mncl.booking', [], [
          'id',
          'start_date',
          'duration_start',
          'duration_end',
        ]).then((OdooResponse response) {
          if (!response.hasError()) {
            setState(() {
              hideLoading();
              String session = getSession();
              session = session.split(",")[0].split(";")[0];
              for (var i in response.getRecords()) {
                _bookingMeeting.add(Booking(
                  startDate: i["start_date"] is! bool ? i["start_date"] : "No Start Date",
                  durationStart: i["duration_start"] is! bool ? i["duration_start"] : "No Duration Start",
                  durationEnd: i["duration_end"] is! bool ? i["duration_end"] : "No Duration End",
                  productId: i["product_id"][1] is! bool ? i["product_id"][1] : "No Product",
                  description: i["description"] is! bool ? i["description"] : "No Description",
                  partnerId: i["partner_id"][1] is! bool ? i["partner_id"][1] : "No Partner",
                  meetingSubject: i["meeting_subject"] is! bool ? i["meeting_subject"] : "No Meeting Subject",
                ));
              }
            });
          } else {
            showMessage("Warning", response.getErrorMessage());
          }
        });
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

      // if (_bookingMeeting.isEmpty){
      //   getDataBooking();
      // }

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
        title: Text(_selectedIndex == 0
            ? 'Home'
            : _selectedIndex == 1 ? 'Meeting Plans' : 'Inventory'),
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
