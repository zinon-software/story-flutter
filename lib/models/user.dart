import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String name;
  final int countFollowers;
  final int countFollowing;
  final int countPosts;
  final String urlImage;
  final String location;
  final String bio;
  final List<String> urlPhotos;
  bool isFollowing;

  User({
    @required this.name,
    @required this.countFollowers,
    @required this.countFollowing,
    @required this.countPosts,
    @required this.urlImage,
    @required this.location,
    @required this.bio,
    @required this.urlPhotos,
    this.isFollowing,
  });
}


class Users {
  final String name;
  final int countFollowers;
  final int countFollowing;
  final int countPosts;
  final String urlImage;
  final String location;
  final String bio;
  final List<String> urlPhotos;
  bool isFollowing;

  Users({
    @required this.name,
    @required this.countFollowers,
    @required this.countFollowing,
    @required this.countPosts,
    @required this.urlImage,
    @required this.location,
    @required this.bio,
    @required this.urlPhotos,
    this.isFollowing,
  });
}


class UserV2 {
  final String id;
  final String name;
  final String urlImage;
  final String bio;
  final String location;

  UserV2({
    this.id,
    this.name,
    this.urlImage,
    this.bio,
    this.location,
  });

  factory UserV2.fromDocument(DocumentSnapshot doc) {
    return UserV2(
      id: doc['id'],
      name: doc['name'],
      urlImage: doc['urlImage'],
      bio: doc['bio'],
      location: doc['location'],
    );
  }
}