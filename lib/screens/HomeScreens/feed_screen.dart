import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story/models/post_model.dart';
import 'package:story/screens/HomeScreens/view_post_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Widget _buildPost() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  builder: (_) =>
                                                      ViewPostScreen(
                                                    postId: doc.id,
                                                    authorImageUrl:
                                                        doc['imageUrl'],

                                                    timeAgo:
                                                        '5 min', // timeAgo: doc['timeAgo'],

                                                    authorName:
                                                        doc['authorName'],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Instagram',
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 32.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.live_tv),
                        iconSize: 30.0,
                        onPressed: () => print('IGTV'),
                      ),
                      SizedBox(width: 16.0),
                      Container(
                        width: 35.0,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          iconSize: 30.0,
                          onPressed: () => print('Direct Messages'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox(width: 10.0);
                  }
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    width: 60.0,
                    height: 60.0,
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
                          height: 60.0,
                          width: 60.0,
                          image: AssetImage(stories[index - 1]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(child: _buildPost()),
          ],
        ),
      ),
    );
  }
}
