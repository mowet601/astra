import 'dart:io';
import 'dart:math';
import 'package:astra/enum/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import "package:image/image.dart" as Im;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {
    return email.split("@")[0];
    // test1234@gmail.com -> Test1234
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    // Rivaan -> R
    String lastNameInitial = nameSplit[1][0];
    // Ranawat -> R
    return firstNameInitial + lastNameInitial;
    // RR
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return await compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    // storing files temporarily
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    //Giving Random names to the images
    int rand = Random().nextInt(10000);

    // Read Image
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    // Decreasing dimensions
    Im.copyResize(image, width: 500, height: 500);

    // Decreasing Quality
    return new File("$path/img_$rand.jpg")
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  // Offline -> 0
  // Online -> 1
  // Waiting -> 2
  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
     switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat("dd/MM/yy");
    return formatter.format(dateTime);
  }
}