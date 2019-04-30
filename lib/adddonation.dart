import 'package:flutter/material.dart';
import './theme.dart';

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