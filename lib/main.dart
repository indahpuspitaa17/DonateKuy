import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
    },
  ));
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

class HomePage extends StatelessWidget {
  static const routeName = '/homepage';
  final String username;
  final String password;

  const HomePage({
    Key key,
    @required this.username,
    @required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget mainDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 180,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(-2, 4),
                    blurRadius: 6.0,
                  )
                ],
              ),
              padding: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.asset(
                                  'images/profile.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              '$username',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildDrawerTile('Donasi', context, DonationPage()),
          _buildDrawerTile('Q&A', context, DonationPage()),
          _buildDrawerTile('Settings', context, DonationPage()),
          _buildDrawerTile('About', context, DonationPage()),
        ],
      ),
    );
    Widget addDonationFAB = FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDonationPage()),
        );
      },
    );
    Widget homePageBody;

    return MaterialApp(
      title: 'DonateKuy',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DonateKuy'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            CarouselSlider(
              height: 400.0,
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Text(
                        'Slide $i',
                        style: TextStyle(fontSize: 16.0),
                      )
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
        drawer: mainDrawer,
        floatingActionButton: addDonationFAB,
      ),
    );
  }

  ListTile _buildDrawerTile(String label, BuildContext context, Widget page) {
    return ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        });
  }
}

class DonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Donation'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}

class AddDonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Donation',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Donation'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text('Add Donation'),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Profile',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text('Your profile goes here'),
        ),
      ),
    );
  }
}
