import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './home.dart';
import './register.dart';
import './theme.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
    },
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: myTheme(),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 150.0,
                bottom: 50,
              ),
              child: SizedBox(
                height: 60.0,
                child: Image.asset(
                  'images/logo-text.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String loginMsg = '';

  void _performLogin() async {
    final response =
        await http.post("http://192.168.0.6/donatekuy/login.php", body: {
      "email": _emailController.text,
      "password": _passwordController.text,
    });
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      setState(() {
        loginMsg = 'Email and password do not match';
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(userData: datauser)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return 'Please enter an email';
            },
            decoration: InputDecoration(
              labelText: 'Email',
              contentPadding: EdgeInsets.all(16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) return 'Please enter a password';
            },
            decoration: InputDecoration(
              labelText: 'Password',
              contentPadding: EdgeInsets.all(16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
            child: Center(
              child: Text(
                '$loginMsg',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red[400],
                ),
              ),
            )),
          InkWell(
            child: ButtonTheme(
              minWidth: 300,
              height: 48.0,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _performLogin();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text(
              'Sign up for a new account',
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }
}
