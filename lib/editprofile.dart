import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final List userData;
  EditProfilePage({this.userData});

  _EditProfilePageState createState() => _EditProfilePageState(userData: userData);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List userData;
  _EditProfilePageState({this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit your profile here.'),
      ),
    );
  }
}