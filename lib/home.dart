import 'package:flutter/material.dart';
import './main.dart';
import './donation.dart';
import './profile.dart';
import './adddonation.dart';

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
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDonationPage()),
        );
      },
    );
    

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
        drawer: mainDrawer,
        body: Center(child: Text('Hello World')),
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