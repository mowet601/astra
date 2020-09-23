import 'dart:io';

import 'package:astra/models/user.dart';
import 'package:astra/provider/image_upload_provider.dart';
import 'package:astra/resources/chat_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class StorageMethods {
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

  //user class
  User user = User();

  Future<String> uploadImageToStorage(File imageFile) async {

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // showing loading spinner
    imageUploadProvider.setToLoading();

    // Get url from the storage
    String url = await uploadImageToStorage(image);

    // Hide spinner
    imageUploadProvider.setToNotLoading();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}