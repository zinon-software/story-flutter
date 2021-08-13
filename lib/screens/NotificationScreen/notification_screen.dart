import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key key }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  GroupsModel groupModel;

  Future<List<GroupsModel>> fetchProducts() async {
    http.Response response =
        await http.get(Uri.parse("https://firestore.googleapis.com/v1/projects/story-4a61e/databases/(default)/documents/posts"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)['documents'] as List;
      print('body.length');

      print(body.length);
      print(body);

      // List<GroupsModel> group = [];

      // for (var item in body) {
      // print('body.length');
      // print('body.length');

      //   print(item);
      //   group.add(GroupsModel.fromJson(item));
      // }
      return body.map((o) => GroupsModel.fromJson(o)).toList();
    }
    return null;
  }
  
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
      
      body:Container(child: Center(child: FutureBuilder(
                    future: fetchProducts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<GroupsModel> groups = snapshot.data;
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) => Text(groups[index].documents.join('name')),
                          
                          // GroupCard(
                          //   itemIndex: index,
                          //   groups: groups[index],
                            
                          // ),
                        );
                      }
                    }),
              ),),
    );
  }
}




GroupsModel groupsModelFromJson(String str) => GroupsModel.fromJson(json.decode(str));

String groupsModelToJson(GroupsModel data) => json.encode(data.toJson());

class GroupsModel {
    GroupsModel({
        this.documents,
    });

    List<Document> documents;

    factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
        documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
    };
}

class Document {
    Document({
        this.name,
        this.fields,
        this.createTime,
        this.updateTime,
    });

    String name;
    Fields fields;
    DateTime createTime;
    DateTime updateTime;

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        name: json["name"],
        fields: Fields.fromJson(json["fields"]),
        createTime: DateTime.parse(json["createTime"]),
        updateTime: DateTime.parse(json["updateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "fields": fields.toJson(),
        "createTime": createTime.toIso8601String(),
        "updateTime": updateTime.toIso8601String(),
    };
}

class Fields {
    Fields({
        this.userUid,
        this.authorImageUrl,
        this.likedBy,
        this.timeAgo,
        this.imageUrl,
        this.authorName,
        this.description,
    });

    AuthorImageUrl userUid;
    AuthorImageUrl authorImageUrl;
    LikedBy likedBy;
    TimeAgo timeAgo;
    AuthorImageUrl imageUrl;
    AuthorImageUrl authorName;
    AuthorImageUrl description;

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        userUid: AuthorImageUrl.fromJson(json["userUid"]),
        authorImageUrl: AuthorImageUrl.fromJson(json["authorImageUrl"]),
        likedBy: LikedBy.fromJson(json["likedBy"]),
        timeAgo: TimeAgo.fromJson(json["timeAgo"]),
        imageUrl: AuthorImageUrl.fromJson(json["imageUrl"]),
        authorName: AuthorImageUrl.fromJson(json["authorName"]),
        description: AuthorImageUrl.fromJson(json["description"]),
    );

    Map<String, dynamic> toJson() => {
        "userUid": userUid.toJson(),
        "authorImageUrl": authorImageUrl.toJson(),
        "likedBy": likedBy.toJson(),
        "timeAgo": timeAgo.toJson(),
        "imageUrl": imageUrl.toJson(),
        "authorName": authorName.toJson(),
        "description": description.toJson(),
    };
}

class AuthorImageUrl {
    AuthorImageUrl({
        this.stringValue,
    });

    String stringValue;

    factory AuthorImageUrl.fromJson(Map<String, dynamic> json) => AuthorImageUrl(
        stringValue: json["stringValue"],
    );

    Map<String, dynamic> toJson() => {
        "stringValue": stringValue,
    };
}

class LikedBy {
    LikedBy({
        this.arrayValue,
    });

    ArrayValue arrayValue;

    factory LikedBy.fromJson(Map<String, dynamic> json) => LikedBy(
        arrayValue: ArrayValue.fromJson(json["arrayValue"]),
    );

    Map<String, dynamic> toJson() => {
        "arrayValue": arrayValue.toJson(),
    };
}

class ArrayValue {
    ArrayValue();

    factory ArrayValue.fromJson(Map<String, dynamic> json) => ArrayValue(
    );

    Map<String, dynamic> toJson() => {
    };
}

class TimeAgo {
    TimeAgo({
        this.timestampValue,
    });

    DateTime timestampValue;

    factory TimeAgo.fromJson(Map<String, dynamic> json) => TimeAgo(
        timestampValue: DateTime.parse(json["timestampValue"]),
    );

    Map<String, dynamic> toJson() => {
        "timestampValue": timestampValue.toIso8601String(),
    };
}











class GroupCard extends StatelessWidget {
  const GroupCard({
    Key key,
    this.itemIndex,
    this.groups,
    this.press,
  }) : super(key: key);

  final int itemIndex;
  final GroupsModel groups;
  final Function press;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      width: MediaQuery.of(context).size.width,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Align(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      groups.documents.single.name,
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                ],
              ),
              alignment: Alignment.center,
            ),
           ],
        ),
      ),
    );
  }
}
