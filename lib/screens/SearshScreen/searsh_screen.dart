import 'package:flutter/material.dart';
import 'package:story/services/post_services/post_services.dart';

class SearshScreen extends StatelessWidget {
  const SearshScreen({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PostsObject(),
        // child: ListView(
        //   physics: AlwaysScrollableScrollPhysics(),
        //   children: <Widget>[
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 20.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Text(
        //             'Instagram',
        //             style: TextStyle(
        //               fontFamily: 'Billabong',
        //               fontSize: 32.0,
        //             ),
        //           ),
        //           Row(
        //             children: <Widget>[
        //               IconButton(
        //                 icon: Icon(Icons.live_tv),
        //                 iconSize: 30.0,
        //                 onPressed: () => print('IGTV'),
        //               ),
        //               SizedBox(width: 16.0),
        //               Container(
        //                 width: 35.0,
        //                 child: IconButton(
        //                   icon: Icon(Icons.send),
        //                   iconSize: 30.0,
        //                   onPressed: () => print('Direct Messages'),
        //                 ),
        //               )
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
            
        //   ],
        // ),
      );
  }
}