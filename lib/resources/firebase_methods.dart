import 'dart:io';

import 'package:astra/models/message.dart';
import 'package:astra/provider/image_upload_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:astra/models/user.dart';
import 'package:astra/utils/utilities.dart';

class FirebaseMethods {
  StorageReference _storageRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot =
        await firestore.collection('users').getDocuments();
    var snap = querySnapshot.documents;
    for (var i = 0; i < snap.length; i++) {
      // showing all the users in the app except user
      if (snap[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(snap[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();
    // storing data: MESSAGES -> SENDER_ID -> RECEIVER_ID-> MAP
    await firestore
        .collection("messages")
        .document(message.senderId)
        .collection(message.recieverId)
        .add(map);

    return await firestore
        .collection("messages")
        .document(message.recieverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageRef = FirebaseStorage.instance
          .ref()
          .child("${DateTime.now().millisecondsSinceEpoch}");

      StorageUploadTask _storageUploadTask = _storageRef.putFile((image));

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (err) {
      print(err);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
      message: "Photo",
      senderId: senderId,
      recieverId: receiverId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );

    var map = _message.toImageMap();
    // putting data to database
    await firestore
        .collection("messages")
        .document(_message.senderId)
        .collection(_message.recieverId)
        .add(map);

    await firestore
        .collection("messages")
        .document(_message.recieverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToNotLoading();
    setImageMsg(url, receiverId, senderId);
  }
}
