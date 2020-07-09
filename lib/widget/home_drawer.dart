import 'package:flutter/material.dart';

import '../model/user_odoo.dart';
import '../base.dart';

class HomeDrawer extends StatefulWidget {
  final userDataOdoo;
  final imageURL;
  final Function onTap;
  final url;

  HomeDrawer({this.userDataOdoo, this.imageURL, this.onTap, this.url});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends Base<HomeDrawer> {
  List<UserOdoo> _userOdoo = [];
  Function onTap;
  String imageURL;
  String url;

  @override
  void initState() {
    if (widget.userDataOdoo != null) {
      _userOdoo = widget.userDataOdoo;
      print(_userOdoo);
    }

    if (widget.imageURL != null) {
      imageURL = widget.imageURL;
      print(imageURL);
    }

    if (widget.onTap != null) {
      onTap = widget.onTap;
    }

    if (widget.url != null) {
      url = widget.url;
      print(url);
    }

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
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Home',
            ),
            onTap: () {
              onTap(0);
              Navigator.pop(context);
            },
          ),
          Visibility(
            visible: url == 'http://10.1.218.108:8069' ? true : false,
            child: new ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Meeting Plans',
              ),
              onTap: () {
                onTap(1);
                Navigator.pop(context);
              },
            ),
          ),
          Visibility(
            visible: url == 'http://10.1.218.108:8069' ? true : false,
            child: new ListTile(
              leading: Icon(
                Icons.book,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Inventory',
              ),
              onTap: () {
                onTap(2);
                Navigator.pop(context);
              },
            ),
          ),
          Visibility(
            visible: url == 'http://10.1.218.108:8069' ? true : false,
            child: new ListTile(
              leading: Icon(
                Icons.folder,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Products',
              ),
              onTap: () {
                // onTap(2);
                Navigator.pop(context);
              },
            ),
          ),
          new Divider(),
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
