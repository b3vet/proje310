import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class CloudStorage {
  Future<String> changeProfilePicture(AppUser user, XFile file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final profilePicturesRef = storageRef.child('proifilePictures/${user.id}');
    File fileToAdd = File(file.path);
    try {
      await profilePicturesRef.putFile(fileToAdd);
    } on FirebaseException catch (e) {
      print(e);
    }
    return profilePicturesRef.getDownloadURL();
  }

  Future<void> removePostMedia(String postId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final postMediaRef = storageRef.child('postMedia/$postId');
    postMediaRef.delete();
  }
}
