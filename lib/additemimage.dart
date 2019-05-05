import 'dart:io';

import 'package:async/async.dart';
import 'package:donate_kuy/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

class AddItemImage extends StatefulWidget {
  final List userData;
  final String itemName;
  AddItemImage({this.userData, this.itemName});

  _AddItemImageState createState() => _AddItemImageState(userData: userData, itemName: itemName);
}

class _AddItemImageState extends State<AddItemImage> {
  final List userData;
  final String itemName;
  _AddItemImageState({this.userData, this.itemName});
  final String url1 = '192.168.0.20';
  File _image;

  Future getImageGallery() async {
    String title = '${userData[0]['user_id']}_$itemName';
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = File('$path/$title.jpg')
      ..writeAsBytes(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImg;
    });
  }

  Future getImageCamera() async {
    String title = '${userData[0]['user_id']}_$itemName';
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = File('$path/$title.jpg')
      ..writeAsBytes(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImg;
    });
  }

  Future uploadImage(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://$url1/donatekuy/additemimage.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['userId'] = '${userData[0]['user_id']}';
    request.fields['itemName'] = itemName;
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded');
    } else {
      print('Failed to upload');
    }
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
                      getImageGallery();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add image for $itemName',
      theme: myTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add image for $itemName'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container( 
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: _image == null
                      ? Center(
                          child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: Colors.grey,
                          onPressed: () {
                            _imagePickerDialog(context);
                          },
                        ))
                      : Stack(
                          children: <Widget>[
                            Image.file(_image),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            SizedBox(height: 10),
            OutlineButton(
              onPressed: (){
                uploadImage(_image);
                Navigator.pop(context, true);
              },
              child: Text('Upload image'),
            ),
          ],
        ),
      ),
    );
  }
}
