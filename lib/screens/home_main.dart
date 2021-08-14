import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story/screens/CamiraScreen/image_cropper_screen.dart';
import 'package:story/screens/HomeScreens/feed_screen.dart';
import 'package:story/screens/NotificationScreen/notification_screen.dart';
import 'package:story/screens/ProfileScreen/pages/profile_screen.dart';
import 'package:story/screens/SearshScreen/searsh_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final tabs = [
    // FeedScreen(),
    Timeline(),
    // SearshScreen(),
    ActivityFeed(),
    ImageCropperScreen(),
    // NotificationScreen(),
    Search(),
    // ProfileScreen(),
    Profile(profileId: FirebaseAuth.instance.currentUser.uid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: SafeArea(
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text('Searsh'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text('Add'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.circle_notifications),
            title: Text('Notification'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.lightGreenAccent,
          ),
        ],
      ),
    );
  }
}
