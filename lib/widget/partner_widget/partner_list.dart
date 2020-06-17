import 'package:flutter/material.dart';

import '../../widget/partner_widget/partner_detail.dart';
import '../../pages/details.dart';
import '../../widget/empty_list.dart';
import '../../utility/strings.dart';
import '../../service/odoo_response.dart';
import '../../model/partners.dart';
import '../../base.dart';

class PartnerList extends StatefulWidget {
  @override
  _PartnerListState createState() => _PartnerListState();
}

class _PartnerListState extends Base<PartnerList> {
  List<Partner> _partners = [];

  void _getPartners() async {
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
    super.initState();

    getOdooInstance().then((value) {
      _getPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _partners.length > 0
        ? ListView.builder(
            itemCount: _partners.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) => InkWell(
              onTap: () {
                push(Details(
                  titleData: "Detail Partner",
                  widgetClass: PartnerDetail(
                    dataPartner: _partners[i],
                  ),
                ));
              },
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 10.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(_partners[i].imageUrl),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _partners[i].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        _partners[i].email,
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : EmptyList(Icons.people_outline, Strings.no_partners);
  }
}
