import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourpage/models/comment.dart';
import 'package:yourpage/models/post.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference postsInfoCollection =
      Firestore.instance.collection('posts');

  ////////
  // USERS
  Stream<DocumentSnapshot> getUserById(String uid) {
    return usersCollection.document(uid).snapshots();
  }

  Query getUserByUsername(String userName) {
    return usersCollection
        .where('accountInfo.userName', isEqualTo: userName)
        .limit(1);
  }

  Future<QuerySnapshot> getAllUsers(DocumentSnapshot lastDocument) {
    return lastDocument == null
        ? usersCollection
            .where('accountInfo.userName', isLessThan: '\uf8ff')
            .limit(5)
            .getDocuments()
        : usersCollection
            .startAfterDocument(lastDocument)
            .where('accountInfo.userName', isLessThan: '\uf8ff')
            .limit(2)
            .getDocuments();
  }

  Future updateUser(String uid, String bio) async {
    try {
      await usersCollection.document(uid).updateData({
        'accountInfo.bio': bio,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ////////
  // POSTS
  Future<DocumentReference> createPost(String uid, Post newPost) {
    return usersCollection
        .document(uid)
        .collection('posts')
        .add(newPost.toMap());
  }

  Future<void> addPostImages(
      String uid, String postId, String imageUrl) {
    return usersCollection
        .document(uid)
        .collection('posts')
        .document(postId)
        .updateData({
      'imagesUrls': FieldValue.arrayUnion([imageUrl]),
      'postId': postId
    });
  }

  Future<void> updatePost(post) {
    return usersCollection
        .document(post['userId'])
        .collection('posts')
        .document(post['postId'])
        .updateData(post);
  }

  Future<QuerySnapshot> getLatestPostsInfo(DocumentSnapshot lastDocument) {
    return lastDocument == null
        ? postsInfoCollection
            .orderBy('date', descending: true)
            .limit(2)
            .getDocuments()
        : postsInfoCollection
            .orderBy('date', descending: true)
            .startAfterDocument(lastDocument)
            .limit(2)
            .getDocuments();
  }

  Query getUserPosts(user, DocumentSnapshot lastDocument) {
    return lastDocument == null
        ? usersCollection
            .document(user['personalInfo']['userId'])
            .collection('posts')
            .orderBy('date', descending: true)
            .limit(4)
        : usersCollection
            .document(user['personalInfo']['userId'])
            .collection('posts')
            .orderBy('date', descending: true)
            .startAfterDocument(lastDocument)
            .limit(2);
  }

  DocumentReference getPost(postInfo) {
    return usersCollection
        .document(postInfo['uid'])
        .collection('posts')
        .document(postInfo['postId']);
  }

  void togglePostLike(updatedPost, String uid, action) {
    usersCollection
        .document(updatedPost['userId'])
        .collection('posts')
        .document(updatedPost['postId'])
        .updateData({
      'likes': action == 0
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid])
    }).catchError((e) => print(e));
  }

  void addComment(post, Comment comment) {
    usersCollection
        .document(post['userId'])
        .collection('posts')
        .document(post['postId'])
        .updateData({
      'comments': FieldValue.arrayUnion([comment.toMap()])
    }).catchError((e) => print(e));
  }
}
