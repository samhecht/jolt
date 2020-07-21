import 'dart:io';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService {
  Future<ImageStorageResult> uploadImage({
    @required File imageToUpload,
    @required String userId,
  }) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(userId);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return ImageStorageResult(
        imageUrl: url,
        imageFileName: userId,
      );
    }
    return null;
  }
}

class ImageStorageResult {
  final String imageUrl;
  final String imageFileName;
  ImageStorageResult({this.imageUrl, this.imageFileName});
}
