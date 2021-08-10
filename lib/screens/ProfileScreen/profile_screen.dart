import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/models/comment_model.dart';
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














// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:story/models/comment_model.dart';
// import 'package:story/services/authentication_services/auth_services.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var firebaseUser = FirebaseAuth.instance.currentUser;
//     final logoutProvider = Provider.of<AuthServices>(context);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             'Profile',
//             style: TextStyle(
//               fontFamily: 'Billabong',
//               fontSize: 32.0,
//               color: Colors.black,
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async => await logoutProvider.logout(),
//               icon: Icon(
//                 Icons.exit_to_app,
//               ),
//               color: Colors.black,
//             ),
//           ],
//         ),
//         backgroundColor: Color(0xFFEDF0F6),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('posts')
//               .where('userUid', isEqualTo: firebaseUser.uid)
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Something went wrong'),
//               );
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: Text('Loading'),
//               );
//             }
//             final List<DocumentSnapshot> documents = snapshot.data.docs;
//             return ListView(
//                 children: documents.map((doc) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                 child: Container(
//                   width: double.infinity,
//                   height: 560.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10.0),
//                         child: Column(
//                           children: <Widget>[
//                             ListTile(
//                               leading: Container(
//                                 width: 50.0,
//                                 height: 50.0,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black45,
//                                       offset: Offset(0, 2),
//                                       blurRadius: 6.0,
//                                     ),
//                                   ],
//                                 ),
//                                 child: CircleAvatar(
//                                   child: ClipOval(
//                                     child: Image(
//                                       height: 50.0,
//                                       width: 50.0,
//                                       image: NetworkImage(doc['imageUrl']),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               title: Text(
//                                 doc['authorName'],
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle:
//                                   Text('5 min'), // doc['timeAgo'].toString()
//                               trailing: IconButton(
//                                 icon: Icon(Icons.more_horiz),
//                                 color: Colors.black,
//                                 onPressed: () => print('More'),
//                               ),
//                             ),
//                             InkWell(
//                               onDoubleTap: () => print('Like post'),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ViewPostScreen(
//                                       postId: doc.id,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.all(10.0),
//                                 width: double.infinity,
//                                 height: 400.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black45,
//                                       offset: Offset(0, 5),
//                                       blurRadius: 8.0,
//                                     ),
//                                   ],
//                                   image: DecorationImage(
//                                     image: NetworkImage(doc['imageUrl']),
//                                     fit: BoxFit.fitWidth,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Row(
//                                     children: <Widget>[
//                                       Row(
//                                         children: <Widget>[
//                                           IconButton(
//                                             icon: Icon(Icons.favorite_border),
//                                             iconSize: 30.0,
//                                             onPressed: () => print('Like post'),
//                                           ),
//                                           Text(
//                                             '2,515',
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(width: 20.0),
//                                       Row(
//                                         children: <Widget>[
//                                           IconButton(
//                                             icon: Icon(Icons.chat),
//                                             iconSize: 30.0,
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       ViewPostScreen(
//                                                     postId: doc.id,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                           Text(
//                                             '350',
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.bookmark_border),
//                                     iconSize: 30.0,
//                                     onPressed: () => print('Save post'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList());
//           },
//         ));
//   }
// }

// class ViewPostScreen extends StatefulWidget {
//   final String postId;

//   ViewPostScreen({this.postId});

//   @override
//   _ViewPostScreenState createState() => _ViewPostScreenState();
// }

// class _ViewPostScreenState extends State<ViewPostScreen> {
//   TextEditingController _commentController = TextEditingController();

//   Widget _buildComment(int index) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: ListTile(
//         leading: Container(
//           width: 50.0,
//           height: 50.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black45,
//                 offset: Offset(0, 2),
//                 blurRadius: 6.0,
//               ),
//             ],
//           ),
//           child: CircleAvatar(
//             child: ClipOval(
//               child: Image(
//                 height: 50.0,
//                 width: 50.0,
//                 image: AssetImage(comments[index].authorImageUrl),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           comments[index].authorName,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(comments[index].text),
//         trailing: IconButton(
//           icon: Icon(
//             Icons.favorite_border,
//           ),
//           color: Colors.grey,
//           onPressed: () => print('Like comment'),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEDF0F6),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .doc(widget.postId)
//                       .get(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return Text("Something went wrong");
//                     }

//                     if (snapshot.hasData && !snapshot.data.exists) {
//                       return Text("Document does not exist");
//                     }

//                     if (snapshot.connectionState == ConnectionState.done) {
//                       Map<String, dynamic> data =
//                           snapshot.data.data() as Map<String, dynamic>;
//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10.0),
//                         child: Column(
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_back),
//                                   iconSize: 30.0,
//                                   color: Colors.black,
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.8,
//                                   child: ListTile(
//                                     leading: Container(
//                                       width: 50.0,
//                                       height: 50.0,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black45,
//                                             offset: Offset(0, 2),
//                                             blurRadius: 6.0,
//                                           ),
//                                         ],
//                                       ),
//                                       child: CircleAvatar(
//                                         child: ClipOval(
//                                           child: Image(
//                                             height: 50.0,
//                                             width: 50.0,
//                                             image:
//                                                 NetworkImage(data['imageUrl']),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       data['authorName'],
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                         '5 min'), // data['timeAgo'].toString()
//                                     trailing: IconButton(
//                                       icon: Icon(Icons.more_horiz),
//                                       color: Colors.black,
//                                       onPressed: () => print('More'),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             InkWell(
//                               onDoubleTap: () => print('Like post'),
//                               child: Container(
//                                 margin: EdgeInsets.all(10.0),
//                                 width: double.infinity,
//                                 height: 400.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black45,
//                                       offset: Offset(0, 5),
//                                       blurRadius: 8.0,
//                                     ),
//                                   ],
//                                   image: DecorationImage(
//                                     image: NetworkImage(data['imageUrl']),
//                                     fit: BoxFit.fitWidth,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Row(
//                                     children: <Widget>[
//                                       Row(
//                                         children: <Widget>[
//                                           IconButton(
//                                             icon: Icon(Icons.favorite_border),
//                                             iconSize: 30.0,
//                                             onPressed: () => print('Like post'),
//                                           ),
//                                           Text(
//                                             '2,515',
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(width: 20.0),
//                                       Row(
//                                         children: <Widget>[
//                                           IconButton(
//                                             icon: Icon(Icons.chat),
//                                             iconSize: 30.0,
//                                             onPressed: () {
//                                               print('Chat');
//                                             },
//                                           ),
//                                           Text(
//                                             '350',
//                                             style: TextStyle(
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.bookmark_border),
//                                     iconSize: 30.0,
//                                     onPressed: () => print('Save post'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return Text("loading");
//                   },
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               Container(
//                 width: double.infinity,
//                 height: 600.0,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     _buildComment(0),
//                     _buildComment(1),
//                     _buildComment(2),
//                     _buildComment(3),
//                     _buildComment(4),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Transform.translate(
//         offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           height: 100.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 offset: Offset(0, -2),
//                 blurRadius: 6.0,
//               ),
//             ],
//             color: Colors.white,
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(12.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   borderSide: BorderSide(color: Colors.grey),
//                 ),
//                 contentPadding: EdgeInsets.all(20.0),
//                 hintText: 'Add a comment',
//                 prefixIcon: Container(
//                   margin: EdgeInsets.all(4.0),
//                   width: 48.0,
//                   height: 48.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black45,
//                         offset: Offset(0, 2),
//                         blurRadius: 6.0,
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     child: ClipOval(
//                       child: Image(
//                         height: 48.0,
//                         width: 48.0,
//                         image: AssetImage('assets/images/user0.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 suffixIcon: Container(
//                   margin: EdgeInsets.only(right: 4.0),
//                   width: 70.0,
//                   // ignore: deprecated_member_use
//                   child: FlatButton(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     color: Color(0xFF23B66F),
//                     onPressed: () =>
//                         print('Post comment ${_commentController.text}'),
//                     child: Icon(
//                       Icons.send,
//                       size: 25.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
