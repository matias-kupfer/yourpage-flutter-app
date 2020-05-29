import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourpage/models/comment.dart';

class Post {
  Post(this.userId, this.country, this.city, this.title,
      this.caption);

  final String userId;
  final String postId = null;
  final date = new DateTime.now();
  final String country;
  final String city;
  final List<String> imagesUrls = [];
  final String title;
  final String caption;
  final List likes = [];
  final List comments = [];

  toMap() {
    return {
      'userId': userId,
      'postId': postId,
      'date': date,
      'country': country,
      'city': city,
      'imagesUrls': [],
      'title': title,
      'caption': caption,
      'likes': [],
      'comments': []
    };
  }
}
