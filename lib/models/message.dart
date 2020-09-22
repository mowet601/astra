import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String recieverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message({this.senderId, this.recieverId, this.type, this.message, this.timestamp});
  Message.imageMessage({this.senderId, this.recieverId, this.type, this.message, this.timestamp, this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map["senderId"] = this.senderId;
    map["recieverId"] = this.recieverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map["senderId"] = this.senderId;
    map["recieverId"] = this.recieverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    map["photoUrl"] = this.photoUrl;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map["senderId"];
    this.recieverId = map["recieverId"];
    this.type = map["type"];
    this.message = map["message"];
    this.timestamp = map["timestamp"];
    this.photoUrl = map["photoUrl"];
  }
}