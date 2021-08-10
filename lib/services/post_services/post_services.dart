// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class PostsObject extends StatefulWidget {
//   @override
//   _PostsObjectState createState() => _PostsObjectState();
// }

// class _PostsObjectState extends State<PostsObject> {
//   final panelController = PanelController();
//   String usersId = '';
//   String userNamt = '';
//   int userCountFollowers = 0;
//   int userCountFollowing = 0;
//   int userCountPosts = 0;
//   String userUrlImage = '';
//   String location = '';
//   String userBio = '';

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference posts = FirebaseFirestore.instance.collection('users');
//     return StreamBuilder<QuerySnapshot>(
//       stream: posts.snapshots(),
//       builder: (
//         BuildContext context,
//         AsyncSnapshot<QuerySnapshot> snapshot,
//       ) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Something went wrong'),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Text('Loading'),
//           );
//         }
//         return SlidingUpPanel(
//         maxHeight: 340,
//         minHeight: 150,
//         parallaxEnabled: true,
//         parallaxOffset: 0.5,
//         controller: panelController,
//         color: Colors.transparent,
//         body: PageView(
//           children: snapshot.data.docs.map((user) {
//             setState(() {
//               usersId = user.id;
//               userNamt = user['namt'];
//               userCountFollowers = user['countFollowers'];
//               userCountFollowing = user['countFollowing'];
//               userCountPosts = user['countPosts'];
//               userUrlImage = user['urlImage'];
//               location = user['location'];
//               userBio = user['bio'];

//             });
//             return Image.network(user['urlImage'], fit: BoxFit.cover);
//           }).toList(),
//         ),
//         panelBuilder: (ScrollController scrollController) => PanelWidget(
//           usersId: usersId,
//           userNamt : userNamt,
//           userCountFollowers:userCountFollowers,
//           userCountFollowing:userCountFollowing,
//           userCountPosts:userCountPosts,
//           userUrlImage:userUrlImage,
//           location:location,
//           userBio:userBio,
//           onClickedPanel: panelController.open,
//           onClickedFollowing: () => setState(() {
//             // user.isFollowing = !user.isFollowing;
//           }),
//         ),
//       );
//       },
//     );
//   }
// }

// class PanelWidget extends StatelessWidget {
//   final String usersId;
//   final String userNamt;
//   final int userCountFollowers;
//   final int userCountFollowing;
//   final int userCountPosts;
//   final String userUrlImage;
//   final String location;
//   final String userBio;

//   final VoidCallback onClickedPanel;
//   final VoidCallback onClickedFollowing;

//   const PanelWidget({
//     @required this.userNamt,
//     @required this.usersId,
//     @required this.userCountFollowers,
//     @required this.userCountFollowing,
//     @required this.userCountPosts,
//     @required this.userUrlImage,
//     @required this.location,
//     @required this.userBio,
//     @required this.onClickedPanel,
//     @required this.onClickedFollowing,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Column(
//         children: [
//           StatsWidget(usersId: usersId,userCountFollowers:userCountFollowers,
//           userCountFollowing:userCountFollowing,
//           userCountPosts:userCountPosts,),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 color: Colors.white,
//               ),
//               child: buildProfile(),
//             ),
//           ),
//         ],
//       );

//   Widget buildProfile() => GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: onClickedPanel,
//         child: Container(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             children: [
//               PanelHeaderWidget(
//                 usersId: usersId,
//                 userNamt: userNamt,
//                 location: location,
//                 onClickedFollowing: onClickedFollowing,
//               ),
//               SizedBox(height: 24),
//               Expanded(child: buildProfileDetails()),
//             ],
//           ),
//         ),
//       );

//   Widget buildProfileDetails() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             userBio,
//             style: TextStyle(fontStyle: FontStyle.italic),
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Photos',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 12),
//           Expanded(
//             child: Container(
//                         height: 100,
//                         width: 100,
//                         padding: EdgeInsets.only(right: 5),
//                         child: Image.asset('assets/photo1.jpg', fit: BoxFit.cover),
//                       ))

//         ],
//       );
// }

// class StatsWidget extends StatelessWidget {
//   final String usersId;
//   final int userCountFollowers;
//   final int userCountFollowing;
//   final int userCountPosts;

//   const StatsWidget({
//     @required this.usersId,
//     @required this.userCountFollowers,
//     @required this.userCountFollowing,
//     @required this.userCountPosts,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             buildStatistic('Followers', userCountFollowers),
//             buildStatistic('Posts', userCountPosts),
//             buildStatistic('Following', userCountFollowing),
//           ],
//         ),
//       );

//   Widget buildStatistic(String text, int value) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '$value',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             text,
//             style: TextStyle(color: Colors.white),
//           )
//         ],
//       );
// }

// class PanelHeaderWidget extends StatelessWidget {
//   final String usersId;
//   final String userNamt;
//   final String location;
//   final VoidCallback onClickedFollowing;

//   const PanelHeaderWidget({
//     @required this.usersId,
//     @required this.userNamt,
//     @required this.location,
//     @required this.onClickedFollowing,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Row(
//         children: [
//           Expanded(child: buildUser()),
//           FollowButtonWidget(
//             isFollowing: true,
//             onClicked: onClickedFollowing,
//           ),
//         ],
//       );

//   Widget buildUser() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             userNamt,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(location),
//         ],
//       );
// }

// class FollowButtonWidget extends StatelessWidget {
//   final bool isFollowing;
//   final VoidCallback onClicked;

//   const FollowButtonWidget({
//     @required this.isFollowing,
//     @required this.onClicked,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onClicked,
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//           width: isFollowing ? 50 : 120,
//           height: 50,
//           child: isFollowing ? buildShrinked() : buildStretched(),
//         ),
//       );

//   Widget buildStretched() => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.red, width: 2.5),
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Center(
//           child: FittedBox(
//             child: Text(
//               'FOLLOW',
//               style: TextStyle(
//                 color: Colors.red,
//                 letterSpacing: 1.5,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget buildShrinked() => Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25), color: Colors.red),
//         child: Icon(
//           Icons.people,
//           color: Colors.white,
//         ),
//       );
// }

// StreamBuilder<QuerySnapshot>(
//       stream: posts.snapshots(),
//       builder: (
//         BuildContext context,
//         AsyncSnapshot<QuerySnapshot> snapshot,
//       ) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Something went wrong'),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Text('Loading'),
//           );
//         }
//         return PageView(
//           children: snapshot.data.docs
//               .map((user) => Image.network(user['imageUrl'], fit: BoxFit.cover))
//               .toList(),
//           // onPageChanged: (index) => setState(() {
//           //   // this.index = index;
//           // }),
//         );
//       },
//     );

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostsObject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return StreamBuilder<QuerySnapshot>(
      stream: posts.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
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
        return PageView(
          children: snapshot.data.docs
              .map((user) => Container(child: Image.network(user['imageUrl'], fit: BoxFit.cover)))
              .toList(),
        );

        // GridView.count(
        //   crossAxisCount: 2,
        //   children: snapshot.data.docs.map((DocumentSnapshot document){
        //   return Container(
        //     padding: EdgeInsets.all(8.0),
        //     child: CircleAvatar(
        //       radius: 60.0,
        //       backgroundColor: Colors.white,
        //       child: Image.network(document['imageUrl'],),
        //     ),
        //   );
        //   }).toList(),);
      },
    );
  }
}
