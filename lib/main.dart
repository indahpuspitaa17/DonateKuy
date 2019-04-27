import 'package:flutter/material.dart';
import './home.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
    },
  ));
  createDatabase() async {
    String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my.db');

  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  return database;
  }
}

ThemeData myTheme() {
  return ThemeData(
    primaryColor: Colors.green,
    primaryColorLight: Colors.green[300],
    primaryColorDark: Colors.green[600],
    accentColor: Colors.amberAccent,
    fontFamily: 'ProductSans',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      body1: TextStyle(fontSize: 14.0),
    ),
  );
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == HomePage.routeName) {
          final LoginArguments args = settings.arguments;

          return MaterialPageRoute(
            builder: (context) {
              return HomePage(
                username: args.username,
                password: args.password,
              );
            },
          );
        }
      },
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

class LoginArguments {
  final String username;
  final String password;
  LoginArguments(this.username, this.password);
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            validator: (value) {
              if (value.isEmpty) return 'Please enter a username';
              if (value.length < 5)
                return 'Username must be at least 5 characters long';
            },
            decoration: InputDecoration(
              labelText: 'Username',
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
              if (value.length < 5)
                return 'Password must be at least 5 characters long';
            },
            decoration: InputDecoration(
              labelText: 'Password',
              contentPadding: EdgeInsets.all(16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
              child: ButtonTheme(
                minWidth: 600,
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
          ),
        ],
      ),
    );
  }

  void _performLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    Navigator.pushNamed(
      context,
      HomePage.routeName,
      arguments: LoginArguments(username, password),
    );
  }
}