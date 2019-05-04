import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import './theme.dart';
import './donation.dart';
import './profile.dart';
import './adddonation.dart';

class HomePage extends StatefulWidget {
  final List userData;
  HomePage({this.userData});
  _HomePageState createState() => _HomePageState(userData: userData);
}

class _HomePageState extends State<HomePage> {
  final List userData;
  _HomePageState({this.userData});

  Future<List> getCategories() async {
    final String url1 = '192.168.0.8';
    final response = await http.get("http://$url1/donatekuy/getcategories.php");
    List list = json.decode(response.body);
    return list;
  }

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
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(userData: userData)),
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
                                child: Image.network('http://192.168.0.8/donatekuy/profile_pictures/${userData[0]['avatar_image']}')
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              userData[0]['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildDrawerTile('Your Donation', context, DonationPage()),
          _buildDrawerTile('Q&A', context, DonationPage()),
          _buildDrawerTile('Settings', context, DonationPage()),
          _buildDrawerTile('About', context, DonationPage()),
        ],
      ),
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
            Builder(builder: (context) {
              return IconButton(
                tooltip: 'Add Donation',
                icon: Icon(Icons.add_box),
                onPressed: () {
                  _navToAddDonation(context);
                },
              );
            }),
          ],
        ),
        drawer: mainDrawer,
        body: ListView(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Carousel(
                autoplay: false,
                images: [
                  ExactAssetImage('images/carousel-0.jpg'),
                  ExactAssetImage('images/carousel-1.jpg'),
                  ExactAssetImage('images/carousel-2.jpg'),
                ],
                dotSize: 4,
                dotSpacing: 12,
                indicatorBgPadding: 6,
              ),
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.grid_on),
                    title: Text('Item $i'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            )
          ],
        ),
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

  _navToAddDonation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddDonationPage(userData: userData)),
    );
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }
}
