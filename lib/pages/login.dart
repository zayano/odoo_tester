import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';
import '../base.dart';
import '../service/odoo_api.dart';
import './home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends Base<Login> {
  String odooURL;
  String _selectedProtocol = "http";
  String _selectedDb;
  String _email;
  String _pass;
  List<String> _dbList = [];
  List dynamicList = [];
  bool isCorrectURL = false;
  bool isDBFilter = false;
  TextEditingController urlController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _checkFirstTime() {
    if (getURL() != null) {
      odooURL = getURL();
      _checkURL();
    }
  }

  void _checkURL() {
    isConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        // Init Odoo URL when URL is not saved
        odoo = new Odoo(url: odooURL);
        odoo.getDatabases().then((http.Response res) {
          setState(
            () {
              hideLoadingSuccess("Odoo Server Connected");
              isCorrectURL = true;
              dynamicList = json.decode(res.body)['result'] as List;
              saveOdooUrl(odooURL);
              dynamicList.forEach((db) => _dbList.add(db));
              _selectedDb = _dbList[0];
              if (_dbList.length == 1) {
                isDBFilter = true;
              } else {
                isDBFilter = false;
              }
            },
          );
        }).catchError(
          (e) {
            showMessage("Warning", "Invalid URL");
          },
        );
      }
    });
  }

  void loginActivating() {
    if (isValid()) {
      isConnected().then((isInternet) {
        if (isInternet) {
          showLoading();
          odoo.authenticate(_email, _pass, _selectedDb).then(
            (http.Response auth) {
              if (auth.body != null) {
                User user = User.fromJson(jsonDecode(auth.body));
                if (user != null && user.result != null) {
                  print(auth.body.toString());
                  hideLoadingSuccess("Logged in successfully");
                  saveUser(json.encode(user));
                  saveOdooUrl(odooURL);
                  pushReplacement(Home());
                } else {
                  showMessage("Authentication Failed",
                      "Please Enter Valid Email or Password");
                }
              } else {
                showMessage("Authentication Failed",
                    "Please Enter Valid Email or Password");
              }
            },
          );
        }
      });
    }
  }

  @override
  void initState() {
    getOdooInstance().then((odoo) {
      _checkFirstTime();
    });

    super.initState();
  }

  bool isValid() {
    _email = emailController.text;
    _pass = passwordController.text;
    if (_email.length > 0 && _pass.length > 0) {
      return true;
    } else {
      showSnackBar("Please enter valid email and password");
      return false;
    }
  }

  Widget textFormField(String label, TextEditingController controller,
      TextInputType inputType, bool obscure) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      obscureText: obscure,
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkButton = Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: !isCorrectURL
            ? () {
                if (urlController.text.length == 0) {
                  showSnackBar("Please enter valid URL");
                  return;
                }
                odooURL = _selectedProtocol + "://" + urlController.text;
                _checkURL();
              }
            : null,
        padding: EdgeInsets.all(12),
        color: Theme.of(context).accentColor,
        child: Text(
          'Connect Odoo Server',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    final protocol = Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border:
            Border.all(color: Color.fromRGBO(112, 112, 112, 3.0), width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedProtocol,
          onChanged: (String newValue) {
            setState(
              () {
                _selectedProtocol = newValue;
              },
            );
          },
          underline: SizedBox(height: 0.0),
          items: <String>['http', 'https'].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                  ),
                ),
              );
            },
          ).toList(),
        ), //DropDownButton
      ),
    );

    final dbs = isDBFilter
        ? SizedBox(height: 0.0)
        : Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, 3.0), width: 1.0)),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: DropdownButton<String>(
                value: _selectedDb,
                onChanged: (String newValue) {
                  setState(() {
                    _selectedDb = newValue;
                  });
                },
                isExpanded: true,
                underline: SizedBox(height: 0.0),
                hint: Text(
                  "Select Database",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                  ),
                ),
                items: _dbList.map(
                  (db) {
                    return DropdownMenuItem(
                      child: Text(
                        db,
                        style:
                            TextStyle(fontFamily: "Montserrat", fontSize: 18),
                      ),
                      value: db,
                    );
                  },
                ).toList(),
              ),
            ),
          );

    final checkURLWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 48.0),
        protocol,
        SizedBox(height: 8.0),
        textFormField('URL', urlController, TextInputType.url, false),
        SizedBox(height: 8.0),
        checkButton,
        SizedBox(height: 8.0),
      ],
    );

    final loginWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        dbs,
        SizedBox(height: 8.0),
        textFormField(
            'Email', emailController, TextInputType.emailAddress, false),
        SizedBox(height: 8.0),
        textFormField('Password', passwordController, TextInputType.text, true),
        SizedBox(height: 24.0),
        Container(
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              loginActivating();
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              changeURL();
            },
            child: Text(
              'Change URL Server',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            child: getURL() == null ? checkURLWidget : loginWidget),
      ),
    );
  }
}
