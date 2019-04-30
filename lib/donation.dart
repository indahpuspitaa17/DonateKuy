import 'package:flutter/material.dart';
import './theme.dart';

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