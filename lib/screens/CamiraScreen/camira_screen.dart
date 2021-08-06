import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CamiraScreen extends StatefulWidget {
  const CamiraScreen({Key key}) : super(key: key);

  @override
  _CamiraScreenState createState() => _CamiraScreenState();
}

class _CamiraScreenState extends State<CamiraScreen> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    PickedFile selected = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = File(selected.path);
    });
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile ?? _imageFile;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icon(Icons.photo_library),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: [
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: _cropImage,
                  child: Icon(Icons.crop),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: _clear,
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
            Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  const Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask _uploadTask;

  // ignore: unused_element
  void _startUpload() {
    String filePath = 'posts/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    print(_uploadTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder(
        stream: _uploadTask.snapshotEvents,
        builder: (BuildContext context, snapshot) {
        var event = snapshot?.data?.snapshot;
        double progressPercent = event != null ? event.bytesTransferred / event.totalByteCount : 0;
        return Column(children: [
          // if (_uploadTask.isComplete)
          //   Text('hiiii'),

          // if (_uploadTask.isPaused)
          //   FlatButton(onPressed: _uploadTask.resume, child: Icon(Icons.play_arrow)),

          // if (_uploadTask.isInProgress)
          //   FlatButton(onPressed: _uploadTask.pause, child: Icon(Icons.pause)),

          LinearProgressIndicator(value: progressPercent,),

          Text(
            '${(progressPercent * 100).toStringAsFixed(2)} %'
          )

        ],);
      });
    } else {
      // ignore: deprecated_member_use
      return FlatButton.icon(
        onPressed: _startUpload,
        icon: Icon(Icons.cloud_upload),
        label: Text('Upload to Firebase'),
      );
    }
  }
}






































// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class CamiraScreen extends StatefulWidget {
//   const CamiraScreen({Key key}) : super(key: key);

//   @override
//   _CamiraScreenState createState() => _CamiraScreenState();
// }

// class _CamiraScreenState extends State<CamiraScreen> {
//   File sampleImage;
//   String _myValue;
//   final formKey = GlobalKey<FormState>();

//   Future _setImage() async {
//     PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     var tempImae = File(pickedFile.path);

//     setState(() {
//       sampleImage = tempImae;
//     });
//   }

//   bool validateAndSave(){
//     final form = formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     } else{
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.close,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Center(
//           child: sampleImage == null ? Text('Selet an Image') : enableUpload(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _setImage,
//         tooltip: 'Add Image',
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }

//   Widget enableUpload() {
//     return Container(
//       child: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Image.file(
//                   sampleImage,
//                   height: 330.0,
//                   width: 600.0,
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Description'),
//                   validator: (value) {
//                     return value.isEmpty ? 'Bold Description is required' : null;
//                   },
//                   onSaved: (value) {
//                     return _myValue = value;
//                   },
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 RaisedButton(
//                   onPressed: validateAndSave,
//                   elevation: 10.0,
//                   child: Text("Add a new Post"),
//                   textColor: Colors.white,
//                   color: Colors.pink,
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
