import 'package:astra/models/message.dart';
import 'package:astra/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:astra/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);

  Future<void> signOut() => _firebaseMethods.signout();

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(Message message, User sender, User reciever) => _firebaseMethods.addMessageToDb(message, sender, reciever);
}