import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:story/screens/CamiraScreen/widget/floating_button.dart';
// import 'package:story/screens/CamiraScreen/widget/image_list_widget.dart';
import 'package:story/screens/CamiraScreen/utils.dart';
import 'package:uuid/uuid.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({Key key}) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  bool isGallery = true;

  // List<File> imageFiles = [];

  File imageFiles;
  bool isLoading = false;
  String _description;
  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseStorage _storage = FirebaseStorage.instance;

    String myUsername = '';
    // ignore: unused_local_variable
    String myurlImage = '';
    String postId = Uuid().v4();

    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        myUsername = userData.data()['name'];
        myurlImage = userData.data()['urlImage'];
      });
    });

    if (imageFiles != null) {
      TaskSnapshot addImg =
          await _storage.ref().child('posts/$postId.png').putFile(imageFiles);
      if (addImg.state == TaskState.success) {
        final String downloadUrl = await addImg.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(firebaseUser.uid)
            .collection("userPosts")
            .doc(postId)
            .set(
          {
            "postId": postId,
            "ownerId": firebaseUser.uid,
            "username": myUsername,
            "mediaUrl": downloadUrl,
            "description": _description,
            "location": '',
            "timestamp": DateTime.now(),
            "likes": {},
          },
        );
      }
      setState(() {
        imageFiles = null;
        isLoading = false;
      });
    }
  }

  bool validateAndSave() {
    setState(() {
      isLoading = true;
    });
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      getImage();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Image Cropper',
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 32.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          isGallery ? 'Gallery' : 'Camera',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Switch(
                          value: isGallery,
                          onChanged: (value) =>
                              setState(() => isGallery = value),
                        ),
                        SizedBox(width: 16.0),
                        Container(
                          width: 35.0,
                          child: imageFiles == null
                              ? Text('')
                              : isLoading == true
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.black),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.send),
                                      iconSize: 30.0,
                                      onPressed: validateAndSave,
                                    ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              imageFiles == null ? Text('Selet an Image') : enableUpload(),
            ],
          ),
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
                  height: 5.0,
                ),
                TextFormField(
                  autocorrect: false,
                  style: TextStyle(color: Colors.green),
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    labelText: 'أكتب شرحاً توضيحياً...',
                  ),
                  onSaved: (value) {
                    return _description = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                // ignore: deprecated_member_use
                // RaisedButton(
                //   onPressed: validateAndSave,
                //   elevation: 10.0,
                //   child: Text("Add a new Post"),
                //   textColor: Colors.white,
                //   color: Colors.pink,
                // ),
              ],
            ),
          )),
    );
  }

  Future onClickedButton() async {
    final file = await Utils.pickMedia(
      isGallery: isGallery,
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
