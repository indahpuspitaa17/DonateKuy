import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './theme.dart';
import './main.dart';
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
    final response =
        await http.get("http://192.168.0.6/donatekuy/getcategories.php");
    return json.decode(response.body);
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
                              userData[0]['name'],
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
        body: FutureBuilder<List>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong.'));
            }
            return snapshot.hasData
                ? CategoryGrid(list: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
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

class CategoryGrid extends StatelessWidget {
  final List list;
  CategoryGrid({this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0),
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.0,
              mainAxisSpacing: 14.0
            ),
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDonationPage())
              );
            },
            child: InkWell(
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.asset('images/carousel-2.jpg'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4),),
                    Text(list[i]['name']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
