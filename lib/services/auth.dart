import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<String> get getUid {
    return _auth.onAuthStateChanged
        .map((user) => user != null ? user.uid : null);
  }

  /*Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirestoreService(result.user.uid)
          .updateUser(UserData(name, null, [Task('This is an example', false)]));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}