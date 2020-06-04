import 'package:flutter/material.dart';

import '../model/user_odoo.dart';
import '../base.dart';

class HomeDrawer extends StatefulWidget {
  final userDataOdoo;
  final imageURL;

  HomeDrawer(this.userDataOdoo, this.imageURL);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends Base<HomeDrawer> {
  List<UserOdoo> _userOdoo = [];

  String imageURL;

  @override
  void initState() {
    _userOdoo = widget.userDataOdoo;
    imageURL = widget.imageURL;

    getOdooInstance().then((value) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: scaffoldKey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text(
                _userOdoo[0].name != null ? _userOdoo[0].name : 'No Name'),
            accountEmail: new Text(
                _userOdoo[0].email != null ? _userOdoo[0].email : 'No Email'),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.amber
                  : Colors.white,
              backgroundImage: NetworkImage(imageURL != null
                  ? imageURL
                  : "https://i1.wp.com/www.molddrsusa.com/wp-content/uploads/2015/11/profile-empty.png.250x250_q85_crop.jpg?ssl=1"),
            ),
          ),
          new ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
            ),
            onTap: () {
              Navigator.pop(context);
              logout();
            },
          ),
        ],
      ),
    );
  }
}
