import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './theme.dart';
import './additemimage.dart';

class AddDonationPage extends StatefulWidget {
  final List userData;
  AddDonationPage({this.userData});

  @override
  _AddDonationPageState createState() =>
      _AddDonationPageState(userData: userData);
}

class _AddDonationPageState extends State<AddDonationPage> {
  final String url1 = '192.168.0.20';
  final List userData;
  _AddDonationPageState({this.userData});
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _quanCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();
  Category _currentCategory;
  final List<String> _conditions = <String>['', 'Baru', 'Bekas'];
  String _condition = '';
  final List<String> _methods = <String>['', 'COD', 'Kurir'];
  String _method = '';

  Future<List<Category>> _getCategory() async {
    var response = await http.get("http://$url1/donatekuy/getcategories.php");
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Category> listOfCategory = items.map<Category>((json) {
        return Category.fromJson(json);
      }).toList();

      return listOfCategory;
    } else {
      throw Exception("Can't connect to the internet");
    }
  }

  void _performAddItem() {
    http.post("http://$url1/donatekuy/adddonation.php", body: {
      "userId": '${userData[0]['user_id']}',
      "name": _nameCtrl.text,
      "category": _currentCategory.categoryId,
      "itemCondition": _condition,
      "quantity": _quanCtrl.text,
      "desc": _descCtrl.text,
      "delivMethod": _method,
    });
  }

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
                      controller: _nameCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter your item name';
                      },
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    FutureBuilder<List<Category>>(
                      future: _getCategory(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 3.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Category',
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Category>(
                                  items: snapshot.data
                                      .map((category) =>
                                          DropdownMenuItem<Category>(
                                            child: Text(category.name),
                                            value: category,
                                          ))
                                      .toList(),
                                  onChanged: (Category value) {
                                    setState(() {
                                      _currentCategory = value;
                                      state.didChange(value);
                                    });
                                  },
                                  hint: _currentCategory == null
                                      ? Text('Category')
                                      : Text('${_currentCategory.name}'),
                                ),
                              ),
                            );
                          },
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
                      controller: _quanCtrl,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter your item quantity';
                      },
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
                      controller: _descCtrl,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter your item description';
                      },
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
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _performAddItem();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddItemImage(userData: userData, itemName: _nameCtrl.text,)),
              );
              if(result){
                Navigator.pop(context, '${_nameCtrl.text} added successfully');
              } else {
                print('image upload failed');
              }
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
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

class Category {
  String categoryId;
  String name;

  Category({
    this.categoryId,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      name: json['name'],
    );
  }
}
