import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:story/models/user.dart';
import 'package:story/screens/CamiraScreen/utils.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  UserV2 user;
  bool _displayNameValid = true;
  bool _bioValid = true;

  File imageFiles;
  bool isLoading = false;
  bool isLoadingUpdate = false;


  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    user = UserV2.fromDocument(doc);
    displayNameController.text = user.name;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Name",
            errorText: _displayNameValid ? null : " Name too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),
        )
      ],
    );
  }

  Future updateProfileData() async {
    setState(() {
      isLoadingUpdate = true;
    });
    FirebaseStorage _storage = FirebaseStorage.instance;

    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      if (imageFiles != null) {
        TaskSnapshot addImg = await _storage
            .ref()
            .child('users/${firebaseUser.uid}.png')
            .putFile(imageFiles);
        if (addImg.state == TaskState.success) {
          final String downloadUrl = await addImg.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .update({
            "urlImage": downloadUrl,
            "displayName": displayNameController.text,
            "bio": bioController.text,
          });
        }
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          "displayName": displayNameController.text,
          "bio": bioController.text,
        });
      }
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    setState(() {
      isLoadingUpdate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.done,
                size: 30.0,
                color: Colors.green,
              ))
        ],
      ),
      body: isLoading
          ? Center(child: Text('Loading')) //circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () => imageshowDialog(context),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                          ),
                          child: user.urlImage == ''
                              ? CircleAvatar(
                                  radius: 50.0,
                                  child: IconButton(
                                    icon: Icon(Icons.people_alt_rounded),
                                    onPressed: () => imageshowDialog(context),
                                  ),)
                              : imageFiles == null
                                  ? CircleAvatar(
                                      radius: 50.0,
                                      
                                      backgroundImage: CachedNetworkImageProvider(
                                        user.urlImage,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: FileImage(imageFiles),
                                    ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: isLoadingUpdate == true
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.black),
                                    )
                                  : Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  imageshowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: const Text('Image Cropper')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(),
              TextButton(
                child: Text(
                  'Gallery',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onPressed: () => onClickedButton(true)
                    .then((value) => Navigator.pop(context)),
              ),
              TextButton(
                child: Text(
                  'Camera',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onPressed: () => onClickedButton(false).then((value) => Navigator.pop(context)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future onClickedButton(bool isGallery) async {
    final file = await Utils.pickMedia(
      isGallery: isGallery,
      cropImage: cropCustomImage,
    );

    if (file == null) return;

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
