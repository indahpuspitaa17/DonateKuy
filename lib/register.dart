import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './theme.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fNameCtrl = TextEditingController();
  TextEditingController _lNameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  String _locProv;
  String _locReg;

  void isEmailUsed() async {
    final response = await http.post("http://192.168.0.6/donatekuy/email.php",
        body: {"email": _emailCtrl.text});
    var datauser = json.decode(response.body);
    if (datauser.length > 0) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Uh oh!'),
              content: Text('${_emailCtrl.text} is already taken.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    } else {
      _performRegister();
      Navigator.pop(context);
    }
  }

  void _performRegister() {
    http.post("http://192.168.0.6/donatekuy/register.php", body: {
      "first_name": _fNameCtrl.text,
      "last_name": _lNameCtrl.text,
      "email": _emailCtrl.text,
      "password": _passCtrl.text,
      "phone": _phoneCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _fNameCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your name';
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      controller: _lNameCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your name';
                      },
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your email';
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your password';
                        if (value.length < 5)
                          return 'Password must be more than 5 characters.';
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneCtrl,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter your phone number';
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              isEmailUsed();
            }
          },
          icon: Icon(Icons.check),
          label: Text('Sign Up'),
        ),
      ),
    );
  }
}
