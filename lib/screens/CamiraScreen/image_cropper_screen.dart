import 'package:flutter/material.dart';
import 'package:story/screens/CamiraScreen/page/custom_page.dart';

class ImageCropperScreen extends StatefulWidget {
  @override
  _CamiraScreenState createState() => _CamiraScreenState();
}

class _CamiraScreenState extends State<ImageCropperScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  bool isGallery = true;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFEDF0F6),
        appBar: AppBar(
          backwardsCompatibility: true,
          backgroundColor: Colors.white,
          title: Text(
            'Image Cropper',
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 32.0,
              color: Colors.black,
            ),
          ),
          actions: [
            Row(
              children: [
                Text(
                  isGallery ? 'Gallery' : 'Camera',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Switch(
                  value: isGallery,
                  onChanged: (value) => setState(() => isGallery = value),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomPage(isGallery: isGallery),
            ),
          ],
        ),
      );
}
