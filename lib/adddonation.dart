import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'theme.dart';

class AddDonationPage extends StatefulWidget {
  final BaseAuth auth;
  AddDonationPage({Key key, this.auth}) : super(key: key);

  AddDonationPageState createState() => AddDonationPageState();
}

class AddDonationPageState extends State<AddDonationPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _category;
  final List<String> _conditions = <String>['', 'Baru', 'Bekas'];
  String _condition = '';
  final List<String> _methods = <String>['', 'COD', 'Kurir'];
  String _method = '';
  String _name, _quantity, _description;
  File image;
  String fileName;
  String imageUrl;

  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<Null> _getUserDetails() async {
    FirebaseUser currUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = currUser;
    });
  }

  Future getImageFromGallery(BuildContext context) async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectedImage;
    });
    Navigator.pop(context);
  }

  Future getImageFromCamera(BuildContext context) async {
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image = selectedImage;
      fileName = basename(image.path);
    });
    Navigator.pop(context);
  }

  Future uploadImage() async {
    fileName = basename(image.path);
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    final StorageUploadTask task = firebaseStorageRef.putFile(image);

    await (await task.onComplete).ref.getDownloadURL().then((url){
      imageUrl = url;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Donation',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add Donation'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context, 'Donation Canceled'),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    dividerWithText('D E T A I L'),
                    SizedBox(height: 22),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your item name';
                      },
                      onSaved: (value) => _name = value,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('categories')
                          .orderBy('name')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('Loading...');
                        List<DropdownMenuItem> categories = [];
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          categories.add(DropdownMenuItem(
                            child: Text(snap['name']),
                            value: snap['name'],
                          ));
                        }
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 3, 16, 3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Category',
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: categories,
                              onChanged: (value) {
                                setState(() {
                                  _category = value;
                                });
                              },
                              value: _category,
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 3.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Condition',
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              onChanged: (String value) {
                                _condition = value;
                                state.didChange(value);
                              },
                              items: _conditions.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: _condition,
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter your item quantity';
                      },
                      onSaved: (value) => _quantity = value,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      maxLength: 200,
                      maxLines: 3,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter your item description';
                      },
                      onSaved: (value) => _description = value,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 3.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Delivery Method',
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              onChanged: (String value) {
                                _method = value;
                                state.didChange(value);
                              },
                              items: _methods.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: _method,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    dividerWithText('I M A G E'),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Builder(builder: (context) {
                          if (image == null) {
                            return Center(
                                child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              color: Colors.grey,
                              onPressed: () {
                                _imagePickerDialog(context);
                              },
                            ));
                          } else {
                            return Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                Image.file(image, fit: BoxFit.cover),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.file_upload),
          label: Text('Add Donation'),
          onPressed: image == null ? null : () async{
            await uploadImage().then((_){
              addItem().then((_){
                Navigator.pop(context, '$_name added successfully.');
              });
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  _imagePickerDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pick a source'),
            content: Container(
              width: 200,
              height: 100,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                    onTap: () {
                      getImageFromGallery(context);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () {
                      getImageFromCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> addItem() async {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      Firestore.instance.collection('items').add({
        "userId": user.uid,
        "name": _name,
        "addedAt": DateTime.now(),
        "category": _category,
        "itemCondition": _condition,
        "quantity": _quantity,
        "description": _description,
        "delivMethod": _method,
        "imageUrl": imageUrl,
        "isAvailable": true,
      });
    }
  }

  Widget dividerWithText(String value) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Divider(
          color: Colors.grey[600],
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text('$value', style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(
            child: Divider(
          color: Colors.grey[600],
        )),
      ],
    );
  }
}
