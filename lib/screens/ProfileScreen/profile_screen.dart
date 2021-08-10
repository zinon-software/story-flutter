import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/screens/HomeScreens/view_post_screen.dart';
import 'package:story/services/authentication_services/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final logoutProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 32.0,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async => await logoutProvider.logout(),
            icon: Icon(
              Icons.exit_to_app,
            ),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Color(0xFFEDF0F6),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userUid', isEqualTo: firebaseUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading'),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          return ListView(
              children: documents.map((doc) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                width: double.infinity,
                height: 560.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                child: ClipOval(
                                  child: Image(
                                    height: 50.0,
                                    width: 50.0,
                                    image: NetworkImage(doc['imageUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              doc['authorName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle:
                                Text('5 min'), // doc['timeAgo'].toString()
                            trailing: IconButton(
                              icon: Icon(Icons.more_horiz),
                              color: Colors.black,
                              onPressed: () => print('More'),
                            ),
                          ),
                          InkWell(
                            onDoubleTap: () => print('Like post'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewPostScreen(
                                    postId: doc.id,
                                    authorImageUrl: doc['imageUrl'],
                                    timeAgo:
                                        '5 min', // timeAgo: doc['timeAgo'],
                                    authorName: doc['authorName'],
                                    imageUrl: doc['imageUrl'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 5),
                                    blurRadius: 8.0,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(doc['imageUrl']),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          iconSize: 30.0,
                                          onPressed: () => print('Like post'),
                                        ),
                                        Text(
                                          '2,515',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20.0),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.chat),
                                          iconSize: 30.0,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ViewPostScreen(
                                                  postId: doc.id,
                                                  authorImageUrl:
                                                      doc['imageUrl'],

                                                  timeAgo:
                                                      '5 min', // timeAgo: doc['timeAgo'],

                                                  authorName: doc['authorName'],
                                                  imageUrl: doc['imageUrl'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          '350',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.bookmark_border),
                                  iconSize: 30.0,
                                  onPressed: () => print('Save post'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList());
        },
      ),
    );
  }
}