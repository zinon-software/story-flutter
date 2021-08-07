import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:story/screens/CamiraScreen/widget/floating_button.dart';
// import 'package:story/screens/CamiraScreen/widget/image_list_widget.dart';
import 'package:story/screens/CamiraScreen/utils.dart';

class CustomPage extends StatefulWidget {
  final bool isGallery;

  const CustomPage({
    Key key,
    @required this.isGallery,
  }) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  // List<File> imageFiles = [];

  File imageFiles;
  // ignore: unused_field
  String _myValue;
  final formKey = GlobalKey<FormState>();

  FirebaseStorage _storage = FirebaseStorage.instance;
  // ignore: unused_field
  UploadTask _uploadTask;

  

  bool validateAndSave() {
    String filePath = 'posts/${DateTime.now()}.png';
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _uploadTask = _storage.ref().child(filePath).putFile(imageFiles);
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
        //   صورة واحدة
          child: imageFiles == null ? Text('Selet an Image') : enableUpload(),
        ),

        // قائمة من الصور
        // ImageListWidget(imageFiles: imageFiles), 

        floatingActionButton: FloatingButtonWidget(
          onClicked: onClickedButton,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );

  Widget enableUpload() {
    return Container(
      child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.file(
                  imageFiles,
                  height: 330.0,
                  width: 600.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    return value.isEmpty
                        ? 'Bold Description is required'
                        : null;
                  },
                  onSaved: (value) {
                    return _myValue = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: validateAndSave,
                  elevation: 10.0,
                  child: Text("Add a new Post"),
                  textColor: Colors.white,
                  color: Colors.pink,
                ),
              ],
            ),
          )),
    );
  }

  Future onClickedButton() async {
    final file = await Utils.pickMedia(
      isGallery: widget.isGallery,
      cropImage: cropCustomImage,
    );

    if (file == null) return;
    // setState(() => imageFiles.add(file));

    setState(() {
      imageFiles = file;
    });
  }

  static Future<File> cropCustomImage(File imageFile) async =>
      await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        sourcePath: imageFile.path,
        androidUiSettings: androidUiSettings(),
        iosUiSettings: iosUiSettings(),
      );

  static IOSUiSettings iosUiSettings() => IOSUiSettings(
        aspectRatioLockEnabled: false,
      );

  static AndroidUiSettings androidUiSettings() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );
}
