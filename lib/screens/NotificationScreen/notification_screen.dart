
import 'package:flutter/material.dart';
import 'package:story/services/post_services/post_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key key }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
      
      body: PostsObject(),
    );
  }
}