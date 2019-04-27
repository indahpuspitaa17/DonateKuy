import 'package:flutter/material.dart';
import './home.dart';
import './main.dart';

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