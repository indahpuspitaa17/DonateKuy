import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './theme.dart';
import './editprofile.dart';

class ProfilePage extends StatelessWidget {
  final List userData;
  ProfilePage({this.userData});
  final String url1 = '192.168.0.8';

  Future<List<ItemsByUser>> getItemByUser() async {
    //get items donated by a user (userData)
    final response = await http.post("http://$url1/donatekuy/getitembyuser.php",
        body: {"userId": userData[0]['user_id']});

    if (response.statusCode == 200) {
      List items = json.decode(response.body);
      return items.map((item) => ItemsByUser.fromJson(item)).toList();
    } else {
      throw Exception("Can't connect to the internet");
    }
  }

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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 26),
            Column(
              children: <Widget>[
                Container(
                  width: 130.0,
                  height: 130.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65.0),
                    child: Image.network('http://$url1/donatekuy/profile_pictures/${userData[0]['avatar_image']}'),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 4),
                        blurRadius: 4.0,
                      )
                    ],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 26),
                Text(
                  '${userData[0]['name']} ${userData[0]['last_name']}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${userData[0]['email']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 2),
                FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      launch("tel://${userData[0]['phone']}");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.phone, color: Colors.grey[700], size: 18,),
                        SizedBox(width: 4),
                        Text(
                          '${userData[0]['phone']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                Text(
                  'Recent Donations',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder<List<ItemsByUser>>(
                  future: getItemByUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    List<ItemsByUser> items = snapshot.data;
                    return RecentItemView(items: items);
                  },
                ),
                FlatButton(
                  child: Text('SEE ALL'),
                  onPressed: () {
                    //Navigator.push(
                    //  context,
                    //  MaterialPageRoute(builder: (context) => UserItemPage(userData: userData))
                    //);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsByUser {
  final String name, category, addedAt, itemCond, quantity, desc, delivMethod;
  ItemsByUser({
    this.name,
    this.category,
    this.addedAt,
    this.itemCond,
    this.quantity,
    this.desc,
    this.delivMethod,
  });
  factory ItemsByUser.fromJson(Map<String, dynamic> jsonData) {
    return ItemsByUser(
      name: jsonData['name'],
      category: jsonData['category'],
      addedAt: jsonData['added_at'],
      itemCond: jsonData['item_condition'],
      quantity: jsonData['quantity'],
      desc: jsonData['description'],
      delivMethod: jsonData['deliv_method'],
    );
  }
}

class RecentItemView extends StatelessWidget {
  final List<ItemsByUser> items;
  RecentItemView({this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: ((items == null) ? 0 : (items.length < 3)) ? items.length : 3,
      itemBuilder: (context, i) {
        return activityCard(items[i], i);
      },
    );
  }

  Widget activityCard(ItemsByUser item, int i) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      child: Card(
        elevation: 2.4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
          leading: Image.asset(
            'images/logo-icon.png',
            width: 40,
            fit: BoxFit.contain,
          ),
          title: Text(item.name),
          subtitle: Text(item.addedAt),
          trailing: Icon(Icons.arrow_forward_ios, size: 20),
          onTap: () {},
        ),
      ),
    );
  }
}
