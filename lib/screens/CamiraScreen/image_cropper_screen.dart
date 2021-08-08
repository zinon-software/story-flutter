import 'package:flutter/material.dart';
import 'package:story/screens/CamiraScreen/page/custom_page.dart';

class ImageCropperScreen extends StatefulWidget {
  @override
  _CamiraScreenState createState() => _CamiraScreenState();
}

class _CamiraScreenState extends State<ImageCropperScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFEDF0F6),
        body: Column(
          children: [
            Expanded(
              child: CustomPage(),
            ),
          ],
        ),
      );
}
