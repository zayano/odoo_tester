import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './pages/home.dart';
import './base.dart';
import './pages/login.dart';
import './service/odoo_api.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends Base<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<Odoo>(
            future: getOdooInstance(),
            builder: (BuildContext context, AsyncSnapshot<Odoo> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return isLoggedIn() ? Home() : Login();
                default:
                  return new Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: new Center(child: CircularProgressIndicator()),
                  );
              }
            }),
      ),
    );
  }
}
