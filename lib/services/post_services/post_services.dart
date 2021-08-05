import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PostsObject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return StreamBuilder<QuerySnapshot>(
      stream: posts.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, ){
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
      return GridView.count(
        crossAxisCount: 2,
        children: snapshot.data.docs.map((DocumentSnapshot document){
        return Container(
          // child: CircleAvatar(
          //   radius: 60.0,
          //   backgroundColor: Colors.white,
          //   child: Image.network(document.data()['authorImageUrl'],),
          // ),
        );
      }).toList(),);
    },);
  }

}